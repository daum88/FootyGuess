import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/game_data_providers.dart';
import '../../../data/models/game_data_models.dart';
import '../models/missing_xi_models.dart';

class MissingXiGameNotifier extends StateNotifier<MissingXiState> {
  final Ref _ref;
  List<GamePlayer> _allPlayers = [];
  List<TeamLineup> _lineups = [];

  MissingXiGameNotifier(this._ref) : super(const MissingXiState());

  Future<void> initialize() async {
    try {
      final lineups = await _ref.read(lineupsProvider.future);
      final players = await _ref.read(playersProvider.future);
      _lineups = lineups;
      _allPlayers = players;

      if (lineups.isEmpty) {
        state = state.copyWith(gameState: MissingXiGameState.lost);
        return;
      }

      final team = _pickTeam();
      state = state.copyWith(
        currentTeam: team,
        playerPositions: team.positions,
        availablePlayers: players,
        gameState: MissingXiGameState.playing,
        filteredPlayers: players,
      );
    } catch (e) {
      debugPrint('❌ MissingXi: initialization failed: $e');
    }
  }

  MissingXiTeam _pickTeam() {
    final lineup = _lineups[Random().nextInt(_lineups.length)];
    return _toTeam(lineup);
  }

  MissingXiTeam _toTeam(TeamLineup lineup) {
    final positions = lineup.players
        .asMap()
        .entries
        .map((e) => _makePosition(e.value, e.key))
        .toList();
    final desc = '${lineup.teamName} vs ${lineup.opponent} '
        '(${lineup.competition} ${lineup.season})';
    return MissingXiTeam(
      teamName: lineup.teamName,
      description: desc,
      formation: lineup.formation,
      positions: positions,
    );
  }

  FormationPosition _makePosition(LineupPlayer p, int index) {
    final pos = p.position.toUpperCase();
    final xy = _positionLayout(pos, index);
    return FormationPosition(
      position: pos,
      x: xy.$1,
      y: xy.$2,
      answerName: p.name,
    );
  }

  void searchPlayers(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredPlayers: _allPlayers, searchQuery: '');
      return;
    }
    final filtered = _allPlayers
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .take(20)
        .toList();
    state = state.copyWith(filteredPlayers: filtered, searchQuery: query);
  }

  void selectPosition(int positionIndex) {
    if (state.selectedPositionIndex == positionIndex) return;
    state = state.copyWith(
      selectedPositionIndex: positionIndex,
      filteredPlayers: _allPlayers,
      searchQuery: '',
    );
  }

  void placePlayer(GamePlayer player) {
    final index = state.selectedPositionIndex;
    if (index == null || state.gameState != MissingXiGameState.playing) return;

    final slot = state.playerPositions[index];
    final isCorrect = _namesMatch(player.name, slot.answerName);

    if (!isCorrect) {
      final newAttempts = state.attemptsRemaining - 1;
      final newGameState = newAttempts <= 0
          ? MissingXiGameState.lost
          : MissingXiGameState.playing;
      state = state.copyWith(
        attemptsRemaining: newAttempts,
        gameState: newGameState,
        searchQuery: '',
        filteredPlayers: _allPlayers,
      );
      return;
    }

    final newPositions = List<FormationPosition>.from(state.playerPositions);
    newPositions[index] = newPositions[index].copyWith(player: player);

    MissingXiGameState newGameState = MissingXiGameState.playing;
    if (newPositions.every((pos) => pos.player != null)) {
      newGameState = MissingXiGameState.won;
    }

    state = state.copyWith(
      playerPositions: newPositions,
      gameState: newGameState,
      selectedPositionIndex: null,
      searchQuery: '',
      filteredPlayers: _allPlayers,
    );
  }

  void removePlayer(int positionIndex) {
    final newPositions = List<FormationPosition>.from(state.playerPositions);
    newPositions[positionIndex] =
        newPositions[positionIndex].copyWith(player: null);
    state = state.copyWith(
      playerPositions: newPositions,
      gameState: MissingXiGameState.playing,
    );
  }

  void resetGame() {
    if (_lineups.isEmpty) return;
    final team = _pickTeam();
    state = MissingXiState(
      currentTeam: team,
      playerPositions: team.positions,
      availablePlayers: _allPlayers,
      gameState: MissingXiGameState.playing,
      filteredPlayers: _allPlayers,
    );
  }

  String getProgressText() {
    final filledPositions =
        state.playerPositions.where((pos) => pos.player != null).length;
    return '$filledPositions/${state.playerPositions.length}';
  }

  bool _namesMatch(String a, String b) {
    String norm(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final na = norm(a);
    final nb = norm(b);
    if (na.isEmpty || nb.isEmpty) return false;
    return na == nb || na.contains(nb) || nb.contains(na);
  }
}

final missingXiGameProvider =
    StateNotifierProvider<MissingXiGameNotifier, MissingXiState>((ref) {
  return MissingXiGameNotifier(ref);
});

// ---------------------------------------------------------------------------
// Pitch layout helpers
// ---------------------------------------------------------------------------

const _xByPosition = <String, double>{
  'GK': 0.5,
  'RB': 0.86, 'LB': 0.14, 'CB': 0.5, 'RCB': 0.66, 'LCB': 0.34,
  'RWB': 0.9, 'LWB': 0.1,
  'RM': 0.86, 'LM': 0.14, 'CM': 0.5, 'RCM': 0.66, 'LCM': 0.34,
  'CDM': 0.5, 'RDM': 0.66, 'LDM': 0.34, 'CAM': 0.5,
  'RW': 0.86, 'LW': 0.14, 'ST': 0.5, 'RST': 0.66, 'LST': 0.34, 'CF': 0.5,
};

const _yByGroup = <String, double>{
  'GK': 0.92,
  'DF': 0.72,
  'MF': 0.46,
  'FW': 0.16,
};

String _group(String pos) {
  if (pos == 'GK') return 'GK';
  if (['RB', 'LB', 'CB', 'RCB', 'LCB', 'RWB', 'LWB', 'SW'].contains(pos)) {
    return 'DF';
  }
  if (['RW', 'LW', 'ST', 'RST', 'LST', 'CF', 'SS'].contains(pos)) return 'FW';
  return 'MF';
}

(double, double) _positionLayout(String pos, int index) {
  final x = _xByPosition[pos] ?? 0.5;
  final y = _yByGroup[_group(pos)] ?? 0.46;
  // Nudge duplicate slots on the same line slightly so they don't overlap.
  final nudge = (index % 2 == 0) ? 0.0 : 0.08;
  return ((x + nudge).clamp(0.05, 0.95), y);
}
