import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/game_data_providers.dart';
import '../../../data/models/game_data_models.dart';

enum CareerPathGameState {
  initial,
  playing,
  won,
  lost,
}

class CareerPathState {
  final GamePlayer? targetPlayer;
  final List<CareerEntry> revealedClubs;
  final CareerPathGameState gameState;
  final int currentClue;
  final int attemptsRemaining;
  final List<GamePlayer> guesses;
  final List<GamePlayer> filteredPlayers;
  final String searchQuery;

  const CareerPathState({
    this.targetPlayer,
    this.revealedClubs = const [],
    this.gameState = CareerPathGameState.initial,
    this.currentClue = 0,
    this.attemptsRemaining = 5,
    this.guesses = const [],
    this.filteredPlayers = const [],
    this.searchQuery = '',
  });

  CareerPathState copyWith({
    GamePlayer? targetPlayer,
    List<CareerEntry>? revealedClubs,
    CareerPathGameState? gameState,
    int? currentClue,
    int? attemptsRemaining,
    List<GamePlayer>? guesses,
    List<GamePlayer>? filteredPlayers,
    String? searchQuery,
  }) {
    return CareerPathState(
      targetPlayer: targetPlayer ?? this.targetPlayer,
      revealedClubs: revealedClubs ?? this.revealedClubs,
      gameState: gameState ?? this.gameState,
      currentClue: currentClue ?? this.currentClue,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      guesses: guesses ?? this.guesses,
      filteredPlayers: filteredPlayers ?? this.filteredPlayers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CareerPathGameNotifier extends StateNotifier<CareerPathState> {
  final Ref _ref;
  List<GamePlayer> _allPlayers = [];

  CareerPathGameNotifier(this._ref) : super(const CareerPathState());

  Future<void> initialize() async {
    try {
      final players = await _ref.read(careerPlayersProvider.future);
      _allPlayers = players;

      if (players.isEmpty) {
        state = state.copyWith(gameState: CareerPathGameState.lost);
        return;
      }

      final target = players[DateTime.now().millisecondsSinceEpoch % players.length];
      state = CareerPathState(
        targetPlayer: target,
        gameState: CareerPathGameState.playing,
        filteredPlayers: players,
      );
    } catch (e) {
      debugPrint('❌ CareerPath: initialization failed: $e');
    }
  }

  List<CareerEntry> get _sortedCareer => _sortClubs(state.targetPlayer?.career ?? const []);

  List<CareerEntry> _sortClubs(List<CareerEntry> career) {
    final list = List<CareerEntry>.from(career);
    list.sort((a, b) => (a.startYear ?? 0).compareTo(b.startYear ?? 0));
    return list;
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

  void revealNextClue() {
    if (state.targetPlayer == null ||
        state.gameState != CareerPathGameState.playing) {
      return;
    }
    final sorted = _sortedCareer;
    if (state.currentClue < sorted.length) {
      state = state.copyWith(
        revealedClubs: [...state.revealedClubs, sorted[state.currentClue]],
        currentClue: state.currentClue + 1,
      );
    }
  }

  void makeGuess(GamePlayer player) {
    if (state.gameState != CareerPathGameState.playing) return;

    final newGuesses = [...state.guesses, player];
    final isCorrect = player.name == state.targetPlayer?.name;
    final newAttemptsRemaining = state.attemptsRemaining - 1;

    CareerPathGameState newGameState;
    if (isCorrect) {
      newGameState = CareerPathGameState.won;
    } else if (newAttemptsRemaining <= 0) {
      newGameState = CareerPathGameState.lost;
    } else {
      newGameState = CareerPathGameState.playing;
      revealNextClue();
    }

    state = state.copyWith(
      guesses: newGuesses,
      gameState: newGameState,
      attemptsRemaining: newAttemptsRemaining,
      searchQuery: '',
      filteredPlayers: _allPlayers,
    );
  }

  void resetGame() {
    if (_allPlayers.isEmpty) return;
    final target = _allPlayers[DateTime.now().millisecondsSinceEpoch % _allPlayers.length];
    state = CareerPathState(
      targetPlayer: target,
      gameState: CareerPathGameState.playing,
      filteredPlayers: _allPlayers,
    );
  }

  void revealAnswer() {
    final target = state.targetPlayer;
    if (target == null) return;
    state = state.copyWith(
      revealedClubs: _sortedCareer,
      currentClue: _sortedCareer.length,
      gameState: CareerPathGameState.lost,
      searchQuery: '',
      filteredPlayers: _allPlayers,
    );
  }

  String getClueText(CareerEntry club) {
    final yearStart = club.startYear ?? '????';
    final yearEnd = club.endYear?.toString() ?? 'Present';
    final loanText = club.isLoan ? ' (Loan)' : '';
    return '$yearStart - $yearEnd: ${club.club}$loanText';
  }
}

final careerPathGameProvider =
    StateNotifierProvider<CareerPathGameNotifier, CareerPathState>((ref) {
  return CareerPathGameNotifier(ref);
});
