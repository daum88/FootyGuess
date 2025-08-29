import 'package:flutter/services.dart';
import '../models/player.dart';

class CareerStatsService {
  static List<Player>? _cachedPlayers;
  static DateTime? _cacheTimestamp;
  static const Duration _cacheValidity = Duration(minutes: 10);

  static Future<List<Player>> loadCareerPlayers() async {
    print('🚀 CareerStatsService: Loading career players');
    final stopwatch = Stopwatch()..start();

    // Check cache validity
    if (_cachedPlayers != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheValidity) {
      print(
          '🚀 CareerStatsService: Using cached data (${_cachedPlayers!.length} players) - ${stopwatch.elapsedMilliseconds}ms');
      return _cachedPlayers!;
    }

    try {
      final String csvContent = await rootBundle
          .loadString('assets/data/football_100_players_stats.csv');
      final List<String> lines = csvContent.split('\n');

      // Skip header line
      if (lines.isEmpty || lines.first.trim().isEmpty) {
        throw Exception('CSV file is empty');
      }

      final Map<String, List<ClubHistory>> playerCareerMap = {};

      // Process each line (skip header)
      for (int i = 1; i < lines.length; i++) {
        final String line = lines[i].trim();
        if (line.isEmpty) continue;

        final List<String> parts = line.split(',');
        if (parts.length < 3) continue;

        final String playerName = parts[0].trim();
        final String clubName = parts[1].trim();

        // Handle inconsistent CSV format
        // Some entries have Years column: Player,Club,Years,Apps,Goals
        // Some entries don't have Years: Player,Club,Apps,Goals
        String yearsStr = '';
        bool hasYearsColumn = false;

        if (parts.length >= 5) {
          // Likely format: Player,Club,Years,Apps,Goals
          final potentialYears = parts[2].trim();
          // Check if it looks like a year range (contains dash or "present")
          if (potentialYears.contains('–') ||
              potentialYears.contains('-') ||
              potentialYears.toLowerCase().contains('present') ||
              RegExp(r'^\d{4}$').hasMatch(potentialYears)) {
            yearsStr = potentialYears;
            hasYearsColumn = true;
          }
        }

        // If no valid years found, skip this entry as we can't determine career timeline
        if (!hasYearsColumn || yearsStr.isEmpty) {
          print(
              '⚠️ CareerStatsService: Skipping $playerName at $clubName - no year data');
          continue;
        }

        // Parse years - handle different formats
        DateTime? fromDate;
        DateTime? toDate;

        if (yearsStr.contains('–') || yearsStr.contains('-')) {
          final yearParts = yearsStr.split(RegExp(r'[–-]'));
          if (yearParts.length == 2) {
            final fromYear = int.tryParse(yearParts[0].trim());
            final toYearStr = yearParts[1].trim();

            if (fromYear != null) {
              fromDate = DateTime(fromYear);

              if (toYearStr.toLowerCase().contains('present')) {
                toDate = null; // Current club
              } else {
                final toYear = int.tryParse(toYearStr);
                if (toYear != null) {
                  toDate = DateTime(toYear);
                }
              }
            }
          }
        } else {
          // Single year format
          final year = int.tryParse(yearsStr);
          if (year != null) {
            fromDate = DateTime(year);
            toDate = DateTime(year + 1);
          }
        }

        if (fromDate != null) {
          final clubHistory = ClubHistory(
            clubId: clubName,
            from: fromDate,
            to: toDate,
            isLoan: false, // We don't have loan info in this CSV
          );

          if (!playerCareerMap.containsKey(playerName)) {
            playerCareerMap[playerName] = [];
          }
          playerCareerMap[playerName]!.add(clubHistory);
        }
      }

      // Convert to Player objects
      final List<Player> players = [];

      for (final entry in playerCareerMap.entries) {
        final String playerName = entry.key;
        final List<ClubHistory> clubs = entry.value;

        // Sort clubs by from date
        clubs.sort((a, b) => a.from.compareTo(b.from));

        // Create unique leagues list
        final Set<String> leagues = {};
        for (final club in clubs) {
          // Map common club names to leagues
          final league = _getLeagueForClub(club.clubId);
          if (league.isNotEmpty) {
            leagues.add(league);
          }
        }

        final player = Player(
          id: playerName
              .toLowerCase()
              .replaceAll(' ', '_')
              .replaceAll('é', 'e')
              .replaceAll('ä', 'a')
              .replaceAll('ñ', 'n'),
          name: playerName,
          nationality: _getNationalityForPlayer(playerName),
          dateOfBirth: _getBirthDateForPlayer(playerName),
          positions: ['Unknown'], // We don't have position info in this CSV
          primaryPosition: 'Unknown',
          clubs: clubs,
          leagues: leagues.toList(),
          teammatesHash: '',
        );

        players.add(player);
      }

      // Add some manually curated players with realistic career data for better game experience
      players.addAll(_getManuallyCreatedCareerPlayers());

      // Filter players with meaningful career data (at least 2 clubs)
      final List<Player> validPlayers =
          players.where((player) => player.clubs.length >= 2).toList();

      // Cache the results
      _cachedPlayers = validPlayers;
      _cacheTimestamp = DateTime.now();

      stopwatch.stop();
      print(
          '🚀 CareerStatsService: Loaded ${validPlayers.length} career players in ${stopwatch.elapsedMilliseconds}ms');

      return validPlayers;
    } catch (e) {
      print('❌ CareerStatsService: Error loading career players: $e');
      return [];
    }
  }

  static String _getLeagueForClub(String clubName) {
    // Map common clubs to their leagues
    final Map<String, String> clubToLeague = {
      'Barcelona': 'La Liga',
      'Real Madrid': 'La Liga',
      'Atlético Madrid': 'La Liga',
      'Sevilla': 'La Liga',
      'Valencia': 'La Liga',
      'Manchester United': 'Premier League',
      'Manchester City': 'Premier League',
      'Liverpool': 'Premier League',
      'Chelsea': 'Premier League',
      'Arsenal': 'Premier League',
      'Tottenham': 'Premier League',
      'Bayern Munich': 'Bundesliga',
      'Borussia Dortmund': 'Bundesliga',
      'Hamburg': 'Bundesliga',
      'Juventus': 'Serie A',
      'AC Milan': 'Serie A',
      'Inter Milan': 'Serie A',
      'Napoli': 'Serie A',
      'Roma': 'Serie A',
      'Paris Saint-Germain': 'Ligue 1',
      'Monaco': 'Ligue 1',
      'Marseille': 'Ligue 1',
      'Lyon': 'Ligue 1',
      'Nice': 'Ligue 1',
      'Ajax': 'Eredivisie',
      'PSV': 'Eredivisie',
      'Feyenoord': 'Eredivisie',
      'Sporting CP': 'Primeira Liga',
      'Porto': 'Primeira Liga',
      'Benfica': 'Primeira Liga',
      'Galatasaray': 'Super Lig',
      'Fenerbahçe': 'Super Lig',
      'Al-Nassr': 'Saudi Pro League',
      'Al-Gharafa': 'Qatar Stars League',
      'Inter Miami': 'MLS',
      'New York Cosmos': 'MLS',
      'Los Angeles Aztecs': 'MLS',
      'Washington Diplomats': 'MLS',
      'Santos': 'Brasileirão',
      'Corinthians': 'Brasileirão',
      'Flamengo': 'Brasileirão',
      'Fluminense': 'Brasileirão',
      'Grêmio': 'Brasileirão',
      'Atlético Mineiro': 'Brasileirão',
      'Boca Juniors': 'Primera División',
      'River Plate': 'Primera División',
      'Argentinos Juniors': 'Primera División',
      'Newell\'s Old Boys': 'Primera División',
      'Cruzeiro': 'Brasileirão',
      'Querétaro': 'Liga MX',
    };

    return clubToLeague[clubName] ?? 'Unknown League';
  }

  static String _getNationalityForPlayer(String playerName) {
    // Map famous players to their nationalities
    final Map<String, String> playerNationalities = {
      'Lionel Messi': 'Argentina',
      'Cristiano Ronaldo': 'Portugal',
      'Kylian Mbappé': 'France',
      'Zinedine Zidane': 'France',
      'Ronaldo Nazário': 'Brazil',
      'Ronaldinho': 'Brazil',
      'Pelé': 'Brazil',
      'Diego Maradona': 'Argentina',
      'Johan Cruyff': 'Netherlands',
      'Franz Beckenbauer': 'Germany',
      'Wesley Sneijder': 'Netherlands',
      'Kevin De Bruyne': 'Belgium',
      'Virgil van Dijk': 'Netherlands',
      'Luka Modrić': 'Croatia',
      'Robert Lewandowski': 'Poland',
      'Erling Haaland': 'Norway',
      'Mohamed Salah': 'Egypt',
      'Sadio Mané': 'Senegal',
      'N\'Golo Kanté': 'France',
      'Paul Pogba': 'France',
      'Toni Kroos': 'Germany',
      'Sergio Ramos': 'Spain',
      'Gerard Piqué': 'Spain',
      'Xavi Hernández': 'Spain',
      'Andrés Iniesta': 'Spain',
      'Thierry Henry': 'France',
      'Karim Benzema': 'France',
      'Gareth Bale': 'Wales',
      'Neymar': 'Brazil',
      'Luis Suárez': 'Uruguay',
      'Antoine Griezmann': 'France',
      'Eden Hazard': 'Belgium',
      'Ángel Di María': 'Argentina',
      'Sergio Agüero': 'Argentina',
      'Paulo Dybala': 'Argentina',
      'Harry Kane': 'England',
      'Raheem Sterling': 'England',
      'Jadon Sancho': 'England',
      'Phil Foden': 'England',
      'Mason Mount': 'England',
      'Jude Bellingham': 'England',
      'Pedri': 'Spain',
      'Gavi': 'Spain',
      'Ansu Fati': 'Spain',
      'Ferran Torres': 'Spain',
      'Joao Felix': 'Portugal',
      'Bruno Fernandes': 'Portugal',
      'Ruben Dias': 'Portugal',
      'Rafael Leão': 'Portugal',
    };

    return playerNationalities[playerName] ?? 'Unknown';
  }

  static DateTime _getBirthDateForPlayer(String playerName) {
    // Map famous players to approximate birth years
    final Map<String, int> playerBirthYears = {
      'Lionel Messi': 1987,
      'Cristiano Ronaldo': 1985,
      'Kylian Mbappé': 1998,
      'Zinedine Zidane': 1972,
      'Ronaldo Nazário': 1976,
      'Ronaldinho': 1980,
      'Pelé': 1940,
      'Diego Maradona': 1960,
      'Johan Cruyff': 1947,
      'Franz Beckenbauer': 1945,
      'Wesley Sneijder': 1984,
      'Kevin De Bruyne': 1991,
      'Virgil van Dijk': 1991,
      'Luka Modrić': 1985,
      'Robert Lewandowski': 1988,
      'Erling Haaland': 2000,
      'Mohamed Salah': 1992,
      'Sadio Mané': 1992,
      'N\'Golo Kanté': 1991,
      'Paul Pogba': 1993,
      'Toni Kroos': 1990,
      'Sergio Ramos': 1986,
      'Gerard Piqué': 1987,
      'Xavi Hernández': 1980,
      'Andrés Iniesta': 1984,
      'Thierry Henry': 1977,
      'Karim Benzema': 1987,
      'Gareth Bale': 1989,
      'Neymar': 1992,
      'Luis Suárez': 1987,
      'Antoine Griezmann': 1991,
      'Eden Hazard': 1991,
      'Ángel Di María': 1988,
      'Sergio Agüero': 1988,
      'Paulo Dybala': 1993,
      'Harry Kane': 1993,
      'Raheem Sterling': 1994,
      'Jadon Sancho': 2000,
      'Phil Foden': 2000,
      'Mason Mount': 1999,
      'Jude Bellingham': 2003,
      'Pedri': 2002,
      'Gavi': 2004,
      'Ansu Fati': 2002,
      'Ferran Torres': 2000,
      'Joao Felix': 1999,
      'Bruno Fernandes': 1994,
      'Ruben Dias': 1997,
      'Rafael Leão': 1999,
    };

    final birthYear = playerBirthYears[playerName] ?? 1990;
    return DateTime(birthYear);
  }

  static Future<Player?> getRandomCareerPlayer() async {
    final players = await loadCareerPlayers();
    if (players.isEmpty) return null;

    final now = DateTime.now();
    final randomIndex = (now.day + now.hour) % players.length;
    return players[randomIndex];
  }

  static void clearCache() {
    _cachedPlayers = null;
    _cacheTimestamp = null;
  }

  static List<Player> _getManuallyCreatedCareerPlayers() {
    // Add some famous players with realistic career progressions
    // for players that don't have proper year data in the CSV
    return [
      // Wayne Rooney
      Player(
        id: 'wayne_rooney_manual',
        name: 'Wayne Rooney',
        nationality: 'England',
        dateOfBirth: DateTime(1985, 10, 24),
        positions: ['ST', 'CAM'],
        primaryPosition: 'ST',
        clubs: [
          ClubHistory(
            clubId: 'Everton',
            from: DateTime(2002),
            to: DateTime(2004),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'Manchester United',
            from: DateTime(2004),
            to: DateTime(2017),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'Everton',
            from: DateTime(2017),
            to: DateTime(2018),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'D.C. United',
            from: DateTime(2018),
            to: DateTime(2019),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'Derby County',
            from: DateTime(2020),
            to: DateTime(2021),
            isLoan: false,
          ),
        ],
        leagues: ['Premier League', 'MLS', 'Championship'],
        teammatesHash: '',
      ),

      // John Terry
      Player(
        id: 'john_terry_manual',
        name: 'John Terry',
        nationality: 'England',
        dateOfBirth: DateTime(1980, 12, 7),
        positions: ['CB'],
        primaryPosition: 'CB',
        clubs: [
          ClubHistory(
            clubId: 'Chelsea',
            from: DateTime(1998),
            to: DateTime(2017),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'Nottingham Forest',
            from: DateTime(2000),
            to: DateTime(2000),
            isLoan: true,
          ),
          ClubHistory(
            clubId: 'Aston Villa',
            from: DateTime(2017),
            to: DateTime(2018),
            isLoan: false,
          ),
        ],
        leagues: ['Premier League', 'Championship'],
        teammatesHash: '',
      ),

      // Frank Lampard
      Player(
        id: 'frank_lampard_manual',
        name: 'Frank Lampard',
        nationality: 'England',
        dateOfBirth: DateTime(1978, 6, 20),
        positions: ['CM', 'CAM'],
        primaryPosition: 'CM',
        clubs: [
          ClubHistory(
            clubId: 'West Ham United',
            from: DateTime(1995),
            to: DateTime(2001),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'Swansea City',
            from: DateTime(1995),
            to: DateTime(1996),
            isLoan: true,
          ),
          ClubHistory(
            clubId: 'Chelsea',
            from: DateTime(2001),
            to: DateTime(2014),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'Manchester City',
            from: DateTime(2014),
            to: DateTime(2015),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'New York City FC',
            from: DateTime(2014),
            to: DateTime(2015),
            isLoan: false,
          ),
        ],
        leagues: ['Premier League', 'MLS'],
        teammatesHash: '',
      ),

      // Steven Gerrard
      Player(
        id: 'steven_gerrard_manual',
        name: 'Steven Gerrard',
        nationality: 'England',
        dateOfBirth: DateTime(1980, 5, 30),
        positions: ['CM', 'CDM', 'CAM'],
        primaryPosition: 'CM',
        clubs: [
          ClubHistory(
            clubId: 'Liverpool',
            from: DateTime(1998),
            to: DateTime(2015),
            isLoan: false,
          ),
          ClubHistory(
            clubId: 'LA Galaxy',
            from: DateTime(2015),
            to: DateTime(2016),
            isLoan: false,
          ),
        ],
        leagues: ['Premier League', 'MLS'],
        teammatesHash: '',
      ),
    ];
  }
}
