import 'package:flutter/services.dart';
import '../../features/missing_xi/providers/missing_xi_provider.dart';

class CsvLineupService {
  static const String _csvPath = 'assets/data/combined_all_lineups.csv';

  List<MissingXiTeam>? _cachedTeams;

  /// Load and parse all teams from the CSV file
  Future<List<MissingXiTeam>> loadTeams() async {
    if (_cachedTeams != null) {
      return _cachedTeams!;
    }

    try {
      print('Loading CSV from: $_csvPath');
      // Load the CSV file
      final csvString = await rootBundle.loadString(_csvPath);
      print('CSV loaded, length: ${csvString.length}');

      // Normalize line endings
      final normalizedCsv =
          csvString.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
      final lines = normalizedCsv
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
      print('CSV split into ${lines.length} valid lines');

      if (lines.isEmpty) {
        print('No valid lines found in CSV');
        return [];
      }

      // Parse manually since CsvToListConverter seems to have issues
      final List<List<String>> csvTable = [];
      for (final line in lines) {
        // Simple comma split (assuming no commas in quoted fields for now)
        final row = line.split(',').map((cell) => cell.trim()).toList();
        csvTable.add(row);
      }

      print('CSV parsed manually, rows: ${csvTable.length}');

      if (csvTable.isNotEmpty) {
        print('Header row length: ${csvTable[0].length}');
        print('Header preview: ${csvTable[0].take(5).join(", ")}...');
        if (csvTable.length > 1) {
          print('First data row length: ${csvTable[1].length}');
          print('First data row preview: ${csvTable[1].take(5).join(", ")}...');
        }
      }

      // Skip the header row
      final dataRows = csvTable.skip(1).toList();

      // Group rows by team_id
      final Map<int, List<Map<String, dynamic>>> teamGroups = {};

      for (final row in dataRows) {
        if (row.length < 22) continue; // Ensure we have all required columns

        final teamId = int.tryParse(row[12].toString()) ?? 0;
        if (teamId == 0) continue;

        final rowData = {
          'team_id': teamId,
          'team_name': row[7].toString(),
          'description': row[13].toString(),
          'formation': row[14].toString(),
          'season': row[15].toString(),
          'competition': row[16].toString(),
          'opponent': row[17].toString(),
          'player_name': row[8].toString(),
          'position': row[9].toString(),
          'jersey_number': int.tryParse(row[10].toString()) ?? 0,
          'nationality': row[11].toString(),
          'player_id': row[18].toString(),
          'x_position': double.tryParse(row[19].toString()) ?? 0.5,
          'y_position': double.tryParse(row[20].toString()) ?? 0.5,
        };

        teamGroups.putIfAbsent(teamId, () => []).add(rowData);
      }

      // Convert to MissingXiTeam objects
      final teams = <MissingXiTeam>[];

      for (final entry in teamGroups.entries) {
        final teamData = entry.value;
        if (teamData.length != 11) continue; // Must have exactly 11 players

        // Get team info from first row
        final firstRow = teamData.first;
        final teamName = firstRow['team_name'] as String;
        final description = firstRow['description'] as String;
        final formation = firstRow['formation'] as String;
        final season = firstRow['season'] as String;
        final competition = firstRow['competition'] as String;
        final opponent = firstRow['opponent'] as String;

        // Create enhanced description
        final enhancedDescription = _createEnhancedDescription(
          description,
          season,
          competition,
          opponent,
        );

        // Create positions with placeholder players
        final positions = teamData.map((playerData) {
          // Store player info for reference (will be matched with real player data later)
          // final player = Player(
          //   id: playerData['player_id'] as String,
          //   name: playerData['player_name'] as String,
          //   nationality: playerData['nationality'] as String,
          //   dateOfBirth: DateTime(1990), // Placeholder
          //   positions: [playerData['position'] as String],
          //   primaryPosition: playerData['position'] as String,
          //   clubs: [], // Will be populated from your main player data
          //   leagues: [],
          //   teammatesHash: '',
          // );

          return FormationPosition(
            position: playerData['position'] as String,
            x: playerData['x_position'] as double,
            y: playerData['y_position'] as double,
            player: null, // Start with no player placed
          );
        }).toList();

        // Sort positions by typical formation order (GK first, then by y-position, then x-position)
        positions.sort((a, b) {
          if (a.position == 'GK') return -1;
          if (b.position == 'GK') return 1;

          final yComparison =
              b.y.compareTo(a.y); // Higher y values first (defenders)
          if (yComparison != 0) return yComparison;

          return a.x.compareTo(b.x); // Left to right
        });

        final team = MissingXiTeam(
          teamName: teamName,
          description: enhancedDescription,
          formation: formation,
          positions: positions,
        );

        teams.add(team);
      }

      print('Parsed ${teams.length} teams from CSV');
      _cachedTeams = teams;
      return teams;
    } catch (e) {
      print('Error loading CSV lineup data: $e');
      // Return fallback teams if CSV fails
      return _createFallbackTeams();
    }
  }

  /// Create an enhanced description with more context
  String _createEnhancedDescription(
    String description,
    String season,
    String competition,
    String opponent,
  ) {
    // Clean up the description and add context
    String enhanced = description;

    // Add opponent information prominently
    if (opponent.isNotEmpty && opponent != 'Unknown') {
      enhanced = '$enhanced vs $opponent';
    }

    // Add season if not already included
    if (!enhanced.contains(season) && season.isNotEmpty) {
      enhanced = '$enhanced ($season)';
    }

    // Add competition context if meaningful
    if (!enhanced.toLowerCase().contains(competition.toLowerCase()) &&
        competition.isNotEmpty &&
        competition != 'Unknown') {
      enhanced = '$enhanced - $competition';
    }

    return enhanced;
  }

  /// Get a random team from the loaded teams
  Future<MissingXiTeam?> getRandomTeam() async {
    final teams = await loadTeams();
    if (teams.isEmpty) return null;

    final randomIndex = DateTime.now().millisecondsSinceEpoch % teams.length;
    return teams[randomIndex];
  }

  /// Get a specific team by index
  Future<MissingXiTeam?> getTeamByIndex(int index) async {
    final teams = await loadTeams();
    if (teams.isEmpty || index < 0 || index >= teams.length) return null;

    return teams[index];
  }

  /// Get total number of available teams
  Future<int> getTeamCount() async {
    final teams = await loadTeams();
    return teams.length;
  }

  /// Get teams by competition
  Future<List<MissingXiTeam>> getTeamsByCompetition(String competition) async {
    final teams = await loadTeams();
    return teams
        .where((team) =>
            team.description.toLowerCase().contains(competition.toLowerCase()))
        .toList();
  }

  /// Get teams by formation
  Future<List<MissingXiTeam>> getTeamsByFormation(String formation) async {
    final teams = await loadTeams();
    return teams.where((team) => team.formation == formation).toList();
  }

  /// Extract all unique players from CSV data
  Future<List<Map<String, dynamic>>> getAllPlayersFromCsv() async {
    try {
      print('🔍 Extracting all players from CSV data...');

      final csvString = await rootBundle.loadString(_csvPath);
      final normalizedCsv =
          csvString.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
      final lines = normalizedCsv
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      final List<List<String>> csvTable = [];
      for (final line in lines) {
        final row = line.split(',').map((cell) => cell.trim()).toList();
        csvTable.add(row);
      }

      final dataRows = csvTable.skip(1).toList();
      final Set<String> uniquePlayerNames = {};
      final List<Map<String, dynamic>> allPlayers = [];

      for (final row in dataRows) {
        if (row.length < 22) continue;

        final playerName = row[8].toString().trim();
        final position = row[9].toString().trim();
        final nationality = row[11].toString().trim();

        if (playerName.isNotEmpty && !uniquePlayerNames.contains(playerName)) {
          uniquePlayerNames.add(playerName);

          allPlayers.add({
            'name': playerName,
            'position': position,
            'nationality': nationality.isNotEmpty ? nationality : 'Unknown',
          });
        }
      }

      print('🔍 Extracted ${allPlayers.length} unique players from CSV');
      return allPlayers;
    } catch (e) {
      print('🔍 Error extracting CSV players: $e');
      return [];
    }
  }

  /// Clear the cache (useful for testing or if CSV is updated)
  void clearCache() {
    _cachedTeams = null;
  }

  /// Create fallback teams if CSV loading fails
  List<MissingXiTeam> _createFallbackTeams() {
    return [
      MissingXiTeam(
        teamName: 'FC Barcelona',
        description: 'Classic Barcelona 2008-2012 era',
        formation: '4-3-3',
        positions: [
          // Goalkeeper
          FormationPosition(position: 'GK', x: 0.5, y: 0.9),
          // Defense
          FormationPosition(position: 'RB', x: 0.8, y: 0.7),
          FormationPosition(position: 'CB', x: 0.65, y: 0.7),
          FormationPosition(position: 'CB', x: 0.35, y: 0.7),
          FormationPosition(position: 'LB', x: 0.2, y: 0.7),
          // Midfield
          FormationPosition(position: 'CDM', x: 0.5, y: 0.5),
          FormationPosition(position: 'CM', x: 0.3, y: 0.4),
          FormationPosition(position: 'CM', x: 0.7, y: 0.4),
          // Attack
          FormationPosition(position: 'RW', x: 0.8, y: 0.2),
          FormationPosition(position: 'ST', x: 0.5, y: 0.1),
          FormationPosition(position: 'LW', x: 0.2, y: 0.2),
        ],
      ),
      MissingXiTeam(
        teamName: 'Real Madrid',
        description: 'Galácticos era Real Madrid',
        formation: '4-2-3-1',
        positions: [
          // Goalkeeper
          FormationPosition(position: 'GK', x: 0.5, y: 0.9),
          // Defense
          FormationPosition(position: 'RB', x: 0.8, y: 0.7),
          FormationPosition(position: 'CB', x: 0.6, y: 0.7),
          FormationPosition(position: 'CB', x: 0.4, y: 0.7),
          FormationPosition(position: 'LB', x: 0.2, y: 0.7),
          // Midfield
          FormationPosition(position: 'CDM', x: 0.4, y: 0.5),
          FormationPosition(position: 'CDM', x: 0.6, y: 0.5),
          // Attack
          FormationPosition(position: 'CAM', x: 0.5, y: 0.3),
          FormationPosition(position: 'RW', x: 0.8, y: 0.3),
          FormationPosition(position: 'LW', x: 0.2, y: 0.3),
          FormationPosition(position: 'ST', x: 0.5, y: 0.1),
        ],
      ),
    ];
  }
}
