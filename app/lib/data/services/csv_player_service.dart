import 'package:flutter/services.dart';

class CsvPlayerService {
  static const String _csvPath =
      'assets/data/football_players_150_fifa_positions.csv';

  static List<Map<String, dynamic>>? _cachedPlayers;
  static DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 10);

  /// Load and parse players from the CSV file with smart caching
  static Future<List<Map<String, dynamic>>> loadPlayers() async {
    // Check if cache is still valid
    if (_cachedPlayers != null && _lastLoadTime != null) {
      final cacheAge = DateTime.now().difference(_lastLoadTime!);
      if (cacheAge < _cacheValidDuration) {
        print(
            '🚀 CsvPlayerService: Using cached data (${_cachedPlayers!.length} players)');
        return _cachedPlayers!;
      }
    }

    try {
      print('🚀 CsvPlayerService: Loading fresh data...');
      final stopwatch = Stopwatch()..start();

      final csvString = await rootBundle.loadString(_csvPath);
      final lines = csvString
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // Parse header
      final headers = _parseCsvLine(lines[0]);
      final players = <Map<String, dynamic>>[];

      // Parse data rows with better error handling
      int validRows = 0;
      int skippedRows = 0;

      for (int i = 1; i < lines.length; i++) {
        try {
          final values = _parseCsvLine(lines[i]);
          if (values.length >= headers.length) {
            final player = <String, dynamic>{};
            for (int j = 0; j < headers.length; j++) {
              player[headers[j].toLowerCase().trim()] = values[j].trim();
            }

            // Convert age to int if present
            if (player['age'] != null) {
              player['age'] = int.tryParse(player['age'].toString()) ?? 0;
            }

            // Validate required fields
            if (player['name']?.toString().isNotEmpty == true) {
              players.add(player);
              validRows++;
            } else {
              skippedRows++;
            }
          } else {
            skippedRows++;
          }
        } catch (e) {
          skippedRows++;
          // Continue processing other rows
        }
      }

      _cachedPlayers = players;
      _lastLoadTime = DateTime.now();
      stopwatch.stop();

      print(
          '🚀 CsvPlayerService: Loaded $validRows players in ${stopwatch.elapsedMilliseconds}ms (skipped $skippedRows invalid rows)');
      return players;
    } catch (e) {
      // Fallback to sample data if CSV loading fails
      print('❌ CsvPlayerService: Error loading CSV: $e');
      print('🔄 CsvPlayerService: Using fallback sample data');
      _cachedPlayers = _getSamplePlayers();
      _lastLoadTime = DateTime.now();
      return _cachedPlayers!;
    }
  }

  /// Parse a CSV line handling quotes and commas properly
  static List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    bool inQuotes = false;
    String current = '';

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current);
        current = '';
      } else {
        current += char;
      }
    }

    result.add(current);
    return result;
  }

  /// Get a random player from the loaded data
  static Future<Map<String, dynamic>> getRandomPlayer() async {
    final players = await loadPlayers();
    if (players.isEmpty) {
      throw Exception('No players available');
    }

    final randomIndex = DateTime.now().millisecondsSinceEpoch % players.length;
    return players[randomIndex];
  }

  /// Search for players by name
  static Future<List<Map<String, dynamic>>> searchPlayers(String query) async {
    if (query.isEmpty) return [];

    final players = await loadPlayers();
    final lowerQuery = query.toLowerCase();

    return players
        .where((player) {
          final name = player['name']?.toString().toLowerCase() ?? '';
          return name.contains(lowerQuery);
        })
        .take(10)
        .toList(); // Limit to 10 results
  }

  /// Get player by exact name match
  static Future<Map<String, dynamic>?> getPlayerByName(String name) async {
    final players = await loadPlayers();
    try {
      return players.firstWhere(
        (player) =>
            player['name']?.toString().toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Clear cached players (useful for testing or refreshing data)
  static void clearCache() {
    _cachedPlayers = null;
  }

  /// Fallback sample players if CSV loading fails
  static List<Map<String, dynamic>> _getSamplePlayers() {
    return [
      {
        'name': 'Lionel Messi',
        'nationality': 'Argentina',
        'club': 'Inter Miami',
        'position': 'RW',
        'age': 37
      },
      {
        'name': 'Cristiano Ronaldo',
        'nationality': 'Portugal',
        'club': 'Al Nassr',
        'position': 'ST',
        'age': 39
      },
      {
        'name': 'Neymar Jr',
        'nationality': 'Brazil',
        'club': 'Al Hilal',
        'position': 'LW',
        'age': 32
      },
      {
        'name': 'Kylian Mbappé',
        'nationality': 'France',
        'club': 'Real Madrid',
        'position': 'ST',
        'age': 25
      },
      {
        'name': 'Erling Haaland',
        'nationality': 'Norway',
        'club': 'Manchester City',
        'position': 'ST',
        'age': 24
      },
      {
        'name': 'Kevin De Bruyne',
        'nationality': 'Belgium',
        'club': 'Manchester City',
        'position': 'CAM',
        'age': 33
      },
      {
        'name': 'Luka Modrić',
        'nationality': 'Croatia',
        'club': 'Real Madrid',
        'position': 'CM',
        'age': 39
      },
      {
        'name': 'Virgil van Dijk',
        'nationality': 'Netherlands',
        'club': 'Liverpool',
        'position': 'CB',
        'age': 33
      },
      {
        'name': 'Mohamed Salah',
        'nationality': 'Egypt',
        'club': 'Liverpool',
        'position': 'RW',
        'age': 32
      },
      {
        'name': 'Robert Lewandowski',
        'nationality': 'Poland',
        'club': 'Barcelona',
        'position': 'ST',
        'age': 36
      }
    ];
  }
}
