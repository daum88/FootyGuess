import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/game_data_models.dart';

/// Single source of truth for all game data.
///
/// Loads the canonical JSON files produced by `data_pipeline/build.py` and
/// exposes them as typed models with in-memory caching.
class GameDataService {
  static final GameDataService _instance = GameDataService._internal();
  factory GameDataService() => _instance;
  GameDataService._internal();

  List<GamePlayer>? _players;
  List<GameMatch>? _matches;
  List<TeamLineup>? _lineups;
  List<GameClub>? _clubs;
  List<TenableCategory>? _tenable;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final results = await Future.wait([
        _loadPlayers(),
        _loadMatches(),
        _loadLineups(),
        _loadClubs(),
        _loadTenable(),
      ]);
      _players = results[0] as List<GamePlayer>;
      _matches = results[1] as List<GameMatch>;
      _lineups = results[2] as List<TeamLineup>;
      _clubs = results[3] as List<GameClub>;
      _tenable = results[4] as List<TenableCategory>;
      _loaded = true;
      debugPrint(
          '📦 GameDataService: loaded ${_players!.length} players, ${_matches!.length} matches, '
          '${_lineups!.length} lineups, ${_clubs!.length} clubs, ${_tenable!.length} tenable categories');
    } catch (e) {
      debugPrint('❌ GameDataService: failed to load data: $e');
      _players ??= [];
      _matches ??= [];
      _lineups ??= [];
      _clubs ??= [];
      _tenable ??= [];
      _loaded = true;
    }
  }

  List<GamePlayer> get players => _players ?? const [];
  List<GameMatch> get matches => _matches ?? const [];
  List<TeamLineup> get lineups => _lineups ?? const [];
  List<GameClub> get clubs => _clubs ?? const [];
  List<TenableCategory> get tenable => _tenable ?? const [];

  /// Players suitable for "Guess the Player" (known age + club + position).
  List<GamePlayer> get guessablePlayers =>
      players.where((p) => p.isGuessable).toList();

  /// Players with career history, for the Career Path game.
  List<GamePlayer> get careerPlayers =>
      players.where((p) => p.career.length >= 2).toList();

  /// Matches with known scorers, for the Who Scored game.
  List<GameMatch> get scoredMatches =>
      matches.where((m) => m.hasScorers).toList();

  Future<List<GamePlayer>> _loadPlayers() async {
    final raw = await rootBundle.loadString('assets/data/players.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    return (data['players'] as List)
        .map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<GameMatch>> _loadMatches() async {
    final raw = await rootBundle.loadString('assets/data/matches.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    return (data['matches'] as List)
        .map((e) => GameMatch.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TeamLineup>> _loadLineups() async {
    final raw = await rootBundle.loadString('assets/data/lineups.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    return (data['teams'] as List)
        .map((e) => TeamLineup.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<GameClub>> _loadClubs() async {
    final raw = await rootBundle.loadString('assets/data/clubs.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    return (data['clubs'] as List)
        .map((e) => GameClub.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TenableCategory>> _loadTenable() async {
    final raw = await rootBundle.loadString('assets/data/tenable.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    return (data['categories'] as List)
        .map((e) => TenableCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
