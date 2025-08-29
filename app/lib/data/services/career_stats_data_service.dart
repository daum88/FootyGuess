import 'package:flutter/services.dart';
import '../models/player.dart';

class CareerStatsDataService {
  static const String _careerStatsPath =
      'assets/data/football_100_players_stats.csv';

  List<Player>? _cachedPlayers;

  /// Load and parse the career stats CSV file
  Future<List<Player>> loadCareerStatsPlayers() async {
    if (_cachedPlayers != null) {
      return _cachedPlayers!;
    }

    try {
      print('Loading career stats from: $_careerStatsPath');
      final csvString = await rootBundle.loadString(_careerStatsPath);
      print('CSV loaded, length: ${csvString.length}');

      // Debug: print first few lines
      final lines = csvString.split('\n');
      print('Total lines after split: ${lines.length}');
      print('First 5 lines:');
      for (int i = 0; i < 5 && i < lines.length; i++) {
        print('Line $i: "${lines[i]}"');
      }

      // Parse each line manually instead of using CsvToListConverter on the whole string
      final csvData = <List<dynamic>>[];
      for (final line in lines) {
        if (line.trim().isNotEmpty) {
          // Simple CSV parsing - split by comma (this assumes no commas in quoted fields)
          final fields = line.split(',');
          csvData.add(fields);
        }
      }

      print('CSV parsed, rows: ${csvData.length}');

      // Debug: print first few parsed rows
      for (int i = 0; i < csvData.length && i < 3; i++) {
        print('Parsed row $i: ${csvData[i]}');
      }

      // Skip header row
      final rows = csvData.skip(1).toList();
      print('Data rows (excluding header): ${rows.length}');

      // Group rows by player name
      final Map<String, List<List<dynamic>>> playerGroups = {};

      for (final row in rows) {
        print('Processing row: $row (length: ${row.length})');
        if (row.length >= 5) {
          final playerName = row[0].toString().trim();
          if (!playerGroups.containsKey(playerName)) {
            playerGroups[playerName] = [];
          }
          playerGroups[playerName]!.add(row);
        } else {
          print('Skipping row with insufficient columns (need 5): $row');
        }
      }

      print('Player groups found: ${playerGroups.length}');

      // Convert grouped data to Player objects
      final players = <Player>[];

      for (final entry in playerGroups.entries) {
        final playerName = entry.key;
        final careerData = entry.value;

        final player = _createPlayerFromCareerData(playerName, careerData);
        if (player != null) {
          players.add(player);
        }
      }

      print('Players created: ${players.length}');
      _cachedPlayers = players;
      return players;
    } catch (e) {
      print('Error loading career stats data: $e');
      throw Exception('Failed to load career stats data: $e');
    }
  }

  /// Create a Player object from career data
  Player? _createPlayerFromCareerData(
      String playerName, List<List<dynamic>> careerData) {
    try {
      print('Creating player: $playerName with ${careerData.length} clubs');

      // Sort career data by club order (assuming chronological order in CSV)
      final clubs = <ClubHistory>[];
      final allClubNames = <String>[];

      for (int i = 0; i < careerData.length; i++) {
        final row = careerData[i];
        if (row.length >= 5) {
          final clubName = row[1].toString().trim();
          final yearsString = row[2].toString().trim();
          // Note: apps and goals are available but not used in current implementation
          // final apps = _parseApps(row[3].toString());
          // final goals = _parseGoals(row[4].toString());

          print('Processing club: $clubName, years: $yearsString');

          // Parse the years from the CSV (e.g., "1992–2017", "2023–present")
          final yearsParsed = _parseYears(yearsString);

          final clubHistory = ClubHistory(
            clubId: _normalizeClubName(clubName),
            from: yearsParsed['from']!,
            to: yearsParsed['to'],
            isLoan: clubName.toLowerCase().contains('loan'),
          );

          clubs.add(clubHistory);
          allClubNames.add(clubName);
        }
      }

      if (clubs.isEmpty) {
        print('No clubs found for player: $playerName');
        return null;
      }

      // Create player with estimated data
      final player = Player(
        id: _generatePlayerId(playerName),
        name: playerName,
        nationality: _estimateNationality(playerName, allClubNames),
        dateOfBirth: _estimateDateOfBirth(playerName),
        positions: _estimatePositions(playerName),
        primaryPosition: _estimatePrimaryPosition(playerName),
        clubs: clubs,
        leagues: _extractLeagues(allClubNames),
        teammatesHash: _generateTeammatesHash(playerName),
        meta: {
          'dataSource': 'career_stats_csv',
          'totalClubs': clubs.length,
          'careerSpan':
              '${clubs.first.from.year}-${clubs.last.to?.year ?? 'Present'}',
        },
      );

      print(
          'Successfully created player: ${player.name} with ${player.clubs.length} clubs');
      return player;
    } catch (e) {
      print('Error creating player $playerName: $e');
      return null;
    }
  }

  /// Parse years from CSV format (e.g., "1992–2017", "2023–present")
  Map<String, DateTime?> _parseYears(String yearsString) {
    try {
      final years = yearsString.toLowerCase().trim();

      // Handle various separators (–, -, to)
      String separator = '–';
      if (years.contains('–')) {
        separator = '–';
      } else if (years.contains('-')) {
        separator = '-';
      } else if (years.contains(' to ')) {
        separator = ' to ';
      }

      final parts = years.split(separator);

      if (parts.length >= 2) {
        final startYear = int.tryParse(parts[0].trim());
        final endPart = parts[1].trim();

        if (startYear != null) {
          DateTime? endDate;

          if (endPart.contains('present') || endPart.contains('current')) {
            endDate = null; // Still active
          } else {
            final endYear = int.tryParse(endPart);
            if (endYear != null) {
              endDate = DateTime(endYear, 12, 31); // End of year
            }
          }

          return {
            'from': DateTime(startYear, 1, 1),
            'to': endDate,
          };
        }
      }

      // If parsing fails, try to extract just a year
      final yearMatch = RegExp(r'\d{4}').firstMatch(years);
      if (yearMatch != null) {
        final year = int.parse(yearMatch.group(0)!);
        return {
          'from': DateTime(year, 1, 1),
          'to': DateTime(year, 12, 31),
        };
      }

      // Fallback - return current year
      print('Warning: Could not parse years: $yearsString, using current year');
      return {
        'from': DateTime(2020, 1, 1),
        'to': null,
      };
    } catch (e) {
      print('Error parsing years $yearsString: $e');
      return {
        'from': DateTime(2020, 1, 1),
        'to': null,
      };
    }
  }

  /// Parse appearances from string (remove any non-numeric characters)
  /// Currently unused but available for future enhancements
  // int _parseApps(String appsString) {
  //   final cleaned = appsString.replaceAll(RegExp(r'[^\d]'), '');
  //   return int.tryParse(cleaned) ?? 0;
  // }

  /// Parse goals from string (handle brackets and commas)
  /// Currently unused but available for future enhancements
  // int _parseGoals(String goalsString) {
  //   final cleaned = goalsString.replaceAll(RegExp(r'[^\d]'), '');
  //   return int.tryParse(cleaned) ?? 0;
  // }

  /// Generate a unique ID for the player
  String _generatePlayerId(String playerName) {
    return playerName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }

  /// Estimate player nationality based on name and clubs
  String _estimateNationality(String playerName, List<String> clubs) {
    // Simple heuristics based on player names and club patterns
    final name = playerName.toLowerCase();

    if (name.contains('ronaldo') ||
        name.contains('ronaldinho') ||
        name.contains('kaká') ||
        name.contains('rivaldo') ||
        name.contains('romário')) {
      return 'Brazil';
    }
    if (name.contains('messi') ||
        name.contains('agüero') ||
        name.contains('tevez') ||
        name.contains('di maría') ||
        name.contains('mascherano') ||
        name.contains('simeone')) {
      return 'Argentina';
    }
    if (name.contains('henry') ||
        name.contains('zidane') ||
        name.contains('ribéry') ||
        name.contains('benzema') ||
        name.contains('griezmann') ||
        name.contains('kanté') ||
        name.contains('pogba') ||
        name.contains('giroud')) {
      return 'France';
    }
    if (name.contains('müller') ||
        name.contains('neuer') ||
        name.contains('lahm') ||
        name.contains('schweinsteiger') ||
        name.contains('klose') ||
        name.contains('ballack') ||
        name.contains('matthäus') ||
        name.contains('klinsmann') ||
        name.contains('kahn')) {
      return 'Germany';
    }
    if (name.contains('iniesta') ||
        name.contains('busquets') ||
        name.contains('casillas') ||
        name.contains('villa') ||
        name.contains('torres') ||
        name.contains('piqué') ||
        name.contains('puyol') ||
        name.contains('alba') ||
        name.contains('fàbregas')) {
      return 'Spain';
    }
    if (name.contains('beckham') ||
        name.contains('shearer') ||
        name.contains('scholes') ||
        name.contains('owen') ||
        name.contains('gerrard') ||
        name.contains('lampard') ||
        name.contains('terry') ||
        name.contains('ferdinand') ||
        name.contains('rooney')) {
      return 'England';
    }
    if (name.contains('van') ||
        name.contains('robben') ||
        name.contains('sneijder') ||
        name.contains('depay') ||
        name.contains('nistelrooy') ||
        name.contains('bergkamp') ||
        name.contains('seedorf') ||
        name.contains('kluivert') ||
        name.contains('overmars')) {
      return 'Netherlands';
    }
    if (name.contains('figo') ||
        name.contains('costa') ||
        name.contains('deco') ||
        name.contains('pepe') ||
        name.contains('moutinho') ||
        name.contains('fernandes')) {
      return 'Portugal';
    }
    if (name.contains('del piero') ||
        name.contains('totti') ||
        name.contains('maldini') ||
        name.contains('buffon') ||
        name.contains('nesta') ||
        name.contains('cannavaro')) {
      return 'Italy';
    }

    // Default fallback
    return 'Unknown';
  }

  /// Estimate date of birth based on career data
  DateTime _estimateDateOfBirth(String playerName) {
    // Simple estimation - assume players start professional career around 18-20
    // and estimate based on known career starts
    final name = playerName.toLowerCase();

    // Some known birth years for major players
    if (name.contains('messi')) return DateTime(1987, 6, 24);
    if (name.contains('ronaldo') &&
        !name.contains('nazário') &&
        !name.contains('ronaldinho')) {
      return DateTime(1985, 2, 5);
    }
    if (name.contains('zidane')) return DateTime(1972, 6, 23);
    if (name.contains('ronaldinho')) return DateTime(1980, 3, 21);
    if (name.contains('kaká')) return DateTime(1982, 4, 22);
    if (name.contains('henry')) return DateTime(1977, 8, 17);
    if (name.contains('beckham')) return DateTime(1975, 5, 2);

    // Default estimation - assume active in 2000s, born around 1980
    return DateTime(1980, 1, 1);
  }

  /// Estimate player positions based on name and career patterns
  List<String> _estimatePositions(String playerName) {
    final name = playerName.toLowerCase();

    // Goalkeepers
    if (name.contains('buffon') ||
        name.contains('casillas') ||
        name.contains('neuer') ||
        name.contains('kahn') ||
        name.contains('van der sar')) {
      return ['GK'];
    }

    // Defenders
    if (name.contains('maldini') ||
        name.contains('nesta') ||
        name.contains('cannavaro') ||
        name.contains('terry') ||
        name.contains('ferdinand') ||
        name.contains('puyol') ||
        name.contains('carlos') ||
        name.contains('cafu') ||
        name.contains('alba') ||
        name.contains('lahm') ||
        name.contains('thuram')) {
      return ['CB', 'LB', 'RB'];
    }

    // Midfielders
    if (name.contains('zidane') ||
        name.contains('iniesta') ||
        name.contains('xavi') ||
        name.contains('busquets') ||
        name.contains('gerrard') ||
        name.contains('lampard') ||
        name.contains('scholes') ||
        name.contains('vieira') ||
        name.contains('makélélé') ||
        name.contains('kroos') ||
        name.contains('pogba') ||
        name.contains('kanté') ||
        name.contains('alonso') ||
        name.contains('fàbregas')) {
      return ['CM', 'CAM', 'CDM'];
    }

    // Wingers/Attacking midfielders
    if (name.contains('ronaldinho') ||
        name.contains('robben') ||
        name.contains('ribéry') ||
        name.contains('beckham') ||
        name.contains('figo') ||
        name.contains('overmars')) {
      return ['LW', 'RW', 'CAM'];
    }

    // Strikers/Forwards
    if (name.contains('ronaldo') ||
        name.contains('messi') ||
        name.contains('henry') ||
        name.contains('torres') ||
        name.contains('villa') ||
        name.contains('benzema') ||
        name.contains('agüero') ||
        name.contains('tevez') ||
        name.contains('owen') ||
        name.contains('shearer') ||
        name.contains('rooney') ||
        name.contains('trezeguet') ||
        name.contains('del piero') ||
        name.contains('totti') ||
        name.contains('kluivert') ||
        name.contains('nistelrooy') ||
        name.contains('bergkamp') ||
        name.contains('giroud') ||
        name.contains('müller') ||
        name.contains('klose')) {
      return ['ST', 'CF', 'LW', 'RW'];
    }

    // Default
    return ['CM'];
  }

  /// Estimate primary position
  String _estimatePrimaryPosition(String playerName) {
    final positions = _estimatePositions(playerName);
    return positions.first;
  }

  /// Normalize club names for consistency
  String _normalizeClubName(String clubName) {
    final normalized = clubName.trim();

    // Remove common suffixes like (1st spell), (loan), etc.
    final cleaned =
        normalized.replaceAll(RegExp(r'\s*\([^)]*\)\s*'), '').trim();

    return cleaned.isEmpty ? normalized : cleaned;
  }

  /// Extract leagues from club names
  List<String> _extractLeagues(List<String> clubNames) {
    final leagues = <String>{};

    for (final club in clubNames) {
      final league = _getLeagueFromClub(club);
      if (league.isNotEmpty) {
        leagues.add(league);
      }
    }

    return leagues.toList();
  }

  /// Get league from club name
  String _getLeagueFromClub(String clubName) {
    final club = clubName.toLowerCase();

    // Premier League
    if (club.contains('manchester') ||
        club.contains('arsenal') ||
        club.contains('liverpool') ||
        club.contains('chelsea') ||
        club.contains('tottenham') ||
        club.contains('everton') ||
        club.contains('west ham') ||
        club.contains('newcastle') ||
        club.contains('aston villa') ||
        club.contains('leicester') ||
        club.contains('stoke') ||
        club.contains('bolton') ||
        club.contains('blackburn') ||
        club.contains('southampton') ||
        club.contains('nottingham') ||
        club.contains('queens park rangers')) {
      return 'Premier League';
    }

    // La Liga
    if (club.contains('barcelona') ||
        club.contains('real madrid') ||
        club.contains('atlético madrid') ||
        club.contains('valencia') ||
        club.contains('sevilla') ||
        club.contains('deportivo') ||
        club.contains('real sociedad') ||
        club.contains('zaragoza') ||
        club.contains('sporting gijón') ||
        club.contains('hércules')) {
      return 'La Liga';
    }

    // Serie A
    if (club.contains('juventus') ||
        club.contains('ac milan') ||
        club.contains('inter milan') ||
        club.contains('roma') ||
        club.contains('lazio') ||
        club.contains('napoli') ||
        club.contains('parma') ||
        club.contains('fiorentina') ||
        club.contains('sampdoria') ||
        club.contains('padova')) {
      return 'Serie A';
    }

    // Bundesliga
    if (club.contains('bayern munich') ||
        club.contains('borussia') ||
        club.contains('schalke') ||
        club.contains('werder bremen') ||
        club.contains('hamburger') ||
        club.contains('kaiserslautern') ||
        club.contains('bayer leverkusen') ||
        club.contains('vfb stuttgart') ||
        club.contains('karlsruher')) {
      return 'Bundesliga';
    }

    // Ligue 1
    if (club.contains('paris saint-germain') ||
        club.contains('marseille') ||
        club.contains('lyon') ||
        club.contains('monaco') ||
        club.contains('bordeaux') ||
        club.contains('cannes') ||
        club.contains('nantes') ||
        club.contains('saint-étienne') ||
        club.contains('auxerre') ||
        club.contains('montpellier') ||
        club.contains('grenoble') ||
        club.contains('strasbourg') ||
        club.contains('caen') ||
        club.contains('tours') ||
        club.contains('istres') ||
        club.contains('boulogne') ||
        club.contains('nîmes')) {
      return 'Ligue 1';
    }

    return 'Other';
  }

  /// Generate teammates hash (simplified)
  String _generateTeammatesHash(String playerName) {
    return playerName.hashCode.toString();
  }

  /// Clear cached data
  void clearCache() {
    _cachedPlayers = null;
  }
}
