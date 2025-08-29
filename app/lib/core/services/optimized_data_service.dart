import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../data/models/player.dart';

/// Optimized data service that loads and caches all game data efficiently
class OptimizedDataService {
  static final OptimizedDataService _instance =
      OptimizedDataService._internal();
  factory OptimizedDataService() => _instance;
  OptimizedDataService._internal();

  // Cached data
  List<Player>? _cachedPlayers;
  List<Map<String, dynamic>>? _cachedLineups;
  List<Map<String, dynamic>>? _cachedTenableData;
  Map<String, dynamic>? _cachedFootballDatabase;

  // Loading states
  bool _isLoadingPlayers = false;
  bool _isLoadingLineups = false;
  bool _isLoadingTenable = false;
  bool _isLoadingDatabase = false;

  /// Get all players (CSV + JSON combined) with caching
  Future<List<Player>> getPlayers() async {
    if (_cachedPlayers != null) {
      return _cachedPlayers!;
    }

    if (_isLoadingPlayers) {
      // Wait for ongoing load to complete
      while (_isLoadingPlayers) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedPlayers ?? [];
    }

    _isLoadingPlayers = true;
    try {
      print('🚀 OptimizedDataService: Loading players...');
      final stopwatch = Stopwatch()..start();

      // Load both CSV and JSON players in parallel
      final results = await Future.wait([
        _loadCsvPlayers(),
        _loadJsonPlayers(),
      ]);

      final csvPlayers = results[0];
      final jsonPlayers = results[1];

      // Deduplicate players by name (case-insensitive)
      final uniquePlayers = <String, Player>{};

      // Add JSON players first (they have more complete data)
      for (final player in jsonPlayers) {
        uniquePlayers[player.name.toLowerCase().trim()] = player;
      }

      // Add CSV players if they don't already exist
      for (final player in csvPlayers) {
        final key = player.name.toLowerCase().trim();
        if (!uniquePlayers.containsKey(key)) {
          uniquePlayers[key] = player;
        }
      }

      _cachedPlayers = uniquePlayers.values.toList();
      stopwatch.stop();

      print(
          '🚀 OptimizedDataService: Loaded ${_cachedPlayers!.length} unique players in ${stopwatch.elapsedMilliseconds}ms');
      print('🚀 - CSV players: ${csvPlayers.length}');
      print('🚀 - JSON players: ${jsonPlayers.length}');
      print(
          '🚀 - Duplicates removed: ${csvPlayers.length + jsonPlayers.length - _cachedPlayers!.length}');

      return _cachedPlayers!;
    } catch (e) {
      print('❌ OptimizedDataService: Error loading players: $e');
      return [];
    } finally {
      _isLoadingPlayers = false;
    }
  }

  /// Get lineup data with caching
  Future<List<Map<String, dynamic>>> getLineups() async {
    if (_cachedLineups != null) {
      return _cachedLineups!;
    }

    if (_isLoadingLineups) {
      while (_isLoadingLineups) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedLineups ?? [];
    }

    _isLoadingLineups = true;
    try {
      print('🚀 OptimizedDataService: Loading lineups...');
      final stopwatch = Stopwatch()..start();

      // Load in isolate for better performance
      final lineups = await compute(_parseLineupsInIsolate, null);

      _cachedLineups = lineups;
      stopwatch.stop();

      print(
          '🚀 OptimizedDataService: Loaded ${lineups.length} lineups in ${stopwatch.elapsedMilliseconds}ms');
      return lineups;
    } catch (e) {
      print('❌ OptimizedDataService: Error loading lineups: $e');
      return [];
    } finally {
      _isLoadingLineups = false;
    }
  }

  /// Get tenable data with caching
  Future<List<Map<String, dynamic>>> getTenableData() async {
    if (_cachedTenableData != null) {
      return _cachedTenableData!;
    }

    if (_isLoadingTenable) {
      while (_isLoadingTenable) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedTenableData ?? [];
    }

    _isLoadingTenable = true;
    try {
      print('🚀 OptimizedDataService: Loading tenable data...');
      final stopwatch = Stopwatch()..start();

      final tenableData = await compute(_parseTenableInIsolate, null);

      _cachedTenableData = tenableData;
      stopwatch.stop();

      print(
          '🚀 OptimizedDataService: Loaded ${tenableData.length} tenable entries in ${stopwatch.elapsedMilliseconds}ms');
      return tenableData;
    } catch (e) {
      print('❌ OptimizedDataService: Error loading tenable data: $e');
      return [];
    } finally {
      _isLoadingTenable = false;
    }
  }

  /// Get football database with caching
  Future<Map<String, dynamic>> getFootballDatabase() async {
    if (_cachedFootballDatabase != null) {
      return _cachedFootballDatabase!;
    }

    if (_isLoadingDatabase) {
      while (_isLoadingDatabase) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedFootballDatabase ?? {};
    }

    _isLoadingDatabase = true;
    try {
      print('🚀 OptimizedDataService: Loading football database...');
      final stopwatch = Stopwatch()..start();

      final jsonString =
          await rootBundle.loadString('assets/data/football_database.json');
      _cachedFootballDatabase = json.decode(jsonString);

      stopwatch.stop();
      print(
          '🚀 OptimizedDataService: Loaded football database in ${stopwatch.elapsedMilliseconds}ms');
      return _cachedFootballDatabase!;
    } catch (e) {
      print('❌ OptimizedDataService: Error loading football database: $e');
      return {};
    } finally {
      _isLoadingDatabase = false;
    }
  }

  /// Preload all data in background for instant access
  Future<void> preloadAllData() async {
    print('🚀 OptimizedDataService: Starting preload of all data...');
    final stopwatch = Stopwatch()..start();

    try {
      // Load all data in parallel
      await Future.wait([
        getPlayers(),
        getLineups(),
        getTenableData(),
        getFootballDatabase(),
      ]);

      stopwatch.stop();
      print(
          '🚀 OptimizedDataService: Preload completed in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e) {
      print('❌ OptimizedDataService: Preload failed: $e');
    }
  }

  /// Clear all cached data (useful for testing or memory management)
  void clearCache() {
    print('🚀 OptimizedDataService: Clearing cache...');
    _cachedPlayers = null;
    _cachedLineups = null;
    _cachedTenableData = null;
    _cachedFootballDatabase = null;
  }

  /// Load CSV players efficiently
  Future<List<Player>> _loadCsvPlayers() async {
    final csvString = await rootBundle
        .loadString('assets/data/football_players_150_fifa_positions.csv');
    return await compute(_parseCsvPlayersInIsolate, csvString);
  }

  /// Load JSON players efficiently
  Future<List<Player>> _loadJsonPlayers() async {
    try {
      final database = await getFootballDatabase();
      return (database['players'] as List? ?? [])
          .map((p) => _convertFootballPlayerToPlayer(p))
          .toList();
    } catch (e) {
      print('❌ Error loading JSON players: $e');
      return [];
    }
  }

  /// Convert FootballPlayer JSON to Player model
  Player _convertFootballPlayerToPlayer(Map<String, dynamic> footballPlayer) {
    return Player(
      id: footballPlayer['id'] ?? '',
      name: footballPlayer['name'] ?? '',
      nationality: footballPlayer['nationality'] ?? '',
      dateOfBirth: DateTime.now(),
      positions: [footballPlayer['position'] ?? 'Unknown'],
      primaryPosition: footballPlayer['position'] ?? 'Unknown',
      clubs: (footballPlayer['careerHistory'] as List? ?? [])
          .map((ch) => ClubHistory(
                clubId: ch['club'] ?? 'unknown',
                from: DateTime(ch['startYear'] ?? 2000),
                to: ch['endYear'] != null ? DateTime(ch['endYear']) : null,
                isLoan: false,
              ))
          .toList(),
      leagues: (footballPlayer['careerHistory'] as List? ?? [])
          .map((ch) => ch['league'] as String? ?? 'Unknown')
          .toSet()
          .toList(),
      teammatesHash: '',
      meta: {},
    );
  }
}

/// Parse CSV players in isolate for better performance
List<Player> _parseCsvPlayersInIsolate(String csvString) {
  final lines =
      csvString.split('\n').where((line) => line.trim().isNotEmpty).toList();

  if (lines.isEmpty) return [];

  // Parse header
  final headers =
      _parseCsvLine(lines[0]).map((h) => h.toLowerCase().trim()).toList();
  final players = <Player>[];

  // Parse data rows
  for (int i = 1; i < lines.length; i++) {
    try {
      final values = _parseCsvLine(lines[i]);
      if (values.length >= headers.length) {
        final playerData = <String, dynamic>{};
        for (int j = 0; j < headers.length; j++) {
          playerData[headers[j]] = values[j].trim();
        }

        final name = playerData['name'] ?? '';
        if (name.isEmpty) continue;

        final position = playerData['position'] ?? 'Unknown';
        final nationality = playerData['nationality'] ?? 'Unknown';
        final age = int.tryParse(playerData['age']?.toString() ?? '25') ?? 25;

        final positions = <String>[position];
        if (position == 'CB') positions.addAll(['RB', 'LB']);
        if (position == 'CM') positions.addAll(['CDM', 'CAM']);
        if (position == 'LW') positions.addAll(['LM', 'ST']);
        if (position == 'RW') positions.addAll(['RM', 'ST']);

        final player = Player(
          id: 'csv_${name.toLowerCase().replaceAll(' ', '_').replaceAll('.', '')}',
          name: name,
          nationality: nationality,
          dateOfBirth: DateTime(DateTime.now().year - age),
          positions: positions,
          primaryPosition: position,
          clubs: [],
          leagues: [],
          teammatesHash: '',
          meta: {'source': 'csv'},
        );

        players.add(player);
      }
    } catch (e) {
      // Skip invalid rows
      continue;
    }
  }

  return players;
}

/// Parse lineup data in isolate
Future<List<Map<String, dynamic>>> _parseLineupsInIsolate(dynamic _) async {
  try {
    final csvString =
        await rootBundle.loadString('assets/data/combined_all_lineups.csv');
    final lines =
        csvString.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) return [];

    final headers =
        _parseCsvLine(lines[0]).map((h) => h.toLowerCase().trim()).toList();
    final lineups = <Map<String, dynamic>>[];

    // Parse only first 500 lines for better performance
    final maxLines = lines.length > 500 ? 500 : lines.length;

    for (int i = 1; i < maxLines; i++) {
      try {
        final values = _parseCsvLine(lines[i]);
        if (values.length >= headers.length) {
          final lineup = <String, dynamic>{};
          for (int j = 0; j < headers.length; j++) {
            lineup[headers[j]] = values[j].trim();
          }
          lineups.add(lineup);
        }
      } catch (e) {
        continue;
      }
    }

    return lineups;
  } catch (e) {
    return [];
  }
}

/// Parse tenable data in isolate
Future<List<Map<String, dynamic>>> _parseTenableInIsolate(dynamic _) async {
  try {
    final csvString = await rootBundle.loadString(
        'assets/data/tenable_game_dataset_full_normalized_10only_clean.csv');
    final lines =
        csvString.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) return [];

    final headers =
        _parseCsvLine(lines[0]).map((h) => h.toLowerCase().trim()).toList();
    final tenableData = <Map<String, dynamic>>[];

    for (int i = 1; i < lines.length; i++) {
      try {
        final values = _parseCsvLine(lines[i]);
        if (values.length >= headers.length) {
          final entry = <String, dynamic>{};
          for (int j = 0; j < headers.length; j++) {
            entry[headers[j]] = values[j].trim();
          }
          tenableData.add(entry);
        }
      } catch (e) {
        continue;
      }
    }

    return tenableData;
  } catch (e) {
    return [];
  }
}

/// Parse CSV line handling quotes and commas
List<String> _parseCsvLine(String line) {
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
