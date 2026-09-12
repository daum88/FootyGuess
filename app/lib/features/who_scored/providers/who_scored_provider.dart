import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/game_data_providers.dart';
import '../../../data/models/game_data_models.dart';

enum WhoScoredGameState {
  initial,
  playing,
  scoreGuessing,
  scorersGuessing,
  completed,
  won,
  lost,
}

/// Wraps a canonical [GameMatch] with the UI fields the page expects.
class MatchData {
  final GameMatch match;
  final String homeTeamBadge;
  final String awayTeamBadge;

  const MatchData({
    required this.match,
    required this.homeTeamBadge,
    required this.awayTeamBadge,
  });

  String get competition => match.competition;
  String get date => match.date;
  String get homeTeam => match.homeTeam;
  String get awayTeam => match.awayTeam;
  int get homeScore => match.homeScore;
  int get awayScore => match.awayScore;

  List<GamePlayer> get scorers => match.scorers
      .map((s) => GamePlayer(id: 'scorer-${s.player}', name: s.player))
      .toList();

  List<int> get scoringMinutes =>
      match.scorers.map((s) => s.minute ?? 0).toList();
}

class WhoScoredState {
  final MatchData? currentMatch;
  final WhoScoredGameState gameState;
  final String userHomeScore;
  final String userAwayScore;
  final List<String> userScorerGuesses;
  final List<GamePlayer> filteredPlayers;
  final String searchQuery;
  final bool scoreRevealed;
  final bool scorersRevealed;
  final int totalPoints;

  const WhoScoredState({
    this.currentMatch,
    this.gameState = WhoScoredGameState.initial,
    this.userHomeScore = '',
    this.userAwayScore = '',
    this.userScorerGuesses = const [],
    this.filteredPlayers = const [],
    this.searchQuery = '',
    this.scoreRevealed = false,
    this.scorersRevealed = false,
    this.totalPoints = 0,
  });

  WhoScoredState copyWith({
    MatchData? currentMatch,
    WhoScoredGameState? gameState,
    String? userHomeScore,
    String? userAwayScore,
    List<String>? userScorerGuesses,
    List<GamePlayer>? filteredPlayers,
    String? searchQuery,
    bool? scoreRevealed,
    bool? scorersRevealed,
    int? totalPoints,
  }) {
    return WhoScoredState(
      currentMatch: currentMatch ?? this.currentMatch,
      gameState: gameState ?? this.gameState,
      userHomeScore: userHomeScore ?? this.userHomeScore,
      userAwayScore: userAwayScore ?? this.userAwayScore,
      userScorerGuesses: userScorerGuesses ?? this.userScorerGuesses,
      filteredPlayers: filteredPlayers ?? this.filteredPlayers,
      searchQuery: searchQuery ?? this.searchQuery,
      scoreRevealed: scoreRevealed ?? this.scoreRevealed,
      scorersRevealed: scorersRevealed ?? this.scorersRevealed,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  bool get isScoreCorrect =>
      userHomeScore == currentMatch?.homeScore.toString() &&
      userAwayScore == currentMatch?.awayScore.toString();

  int get correctScorers {
    final match = currentMatch;
    if (match == null) return 0;
    return userScorerGuesses
        .where((guess) => match.match.scorers.any((scorer) =>
            scorer.player.toLowerCase().contains(guess.toLowerCase()) ||
            guess.toLowerCase().contains(scorer.player.toLowerCase())))
        .length;
  }
}

class WhoScoredGameNotifier extends StateNotifier<WhoScoredState> {
  final Ref _ref;
  List<GamePlayer> _allPlayers = [];

  WhoScoredGameNotifier(this._ref) : super(const WhoScoredState());

  Future<void> initialize() async {
    try {
      final matches = await _ref.read(scoredMatchesProvider.future);
      final players = await _ref.read(playersProvider.future);
      _allPlayers = players;

      if (matches.isNotEmpty) {
        final match = _pickMatch(matches);
        state = state.copyWith(
          currentMatch: match,
          gameState: WhoScoredGameState.playing,
          filteredPlayers: players,
        );
      }
    } catch (e) {
      debugPrint('❌ WhoScored: initialization failed: $e');
    }
  }

  MatchData _pickMatch(List<GameMatch> matches) {
    // Deterministic daily pick + reshuffle on demand.
    final idx = DateTime.now().millisecondsSinceEpoch % matches.length;
    final m = matches[idx];
    return MatchData(match: m, homeTeamBadge: '🔴', awayTeamBadge: '🔵');
  }

  void updateHomeScore(String score) {
    state = state.copyWith(userHomeScore: score);
  }

  void updateAwayScore(String score) {
    state = state.copyWith(userAwayScore: score);
  }

  void submitScore() {
    if (state.gameState != WhoScoredGameState.playing) return;

    int points = 0;
    if (state.isScoreCorrect) points += 10;

    state = state.copyWith(
      gameState: WhoScoredGameState.scoreGuessing,
      scoreRevealed: true,
      totalPoints: points,
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

  void addScorerGuess(String playerName) {
    if (state.gameState != WhoScoredGameState.scoreGuessing) return;
    if (state.userScorerGuesses.any((g) =>
        g.toLowerCase() == playerName.toLowerCase())) {
      return;
    }
    state = state.copyWith(
      userScorerGuesses: [...state.userScorerGuesses, playerName],
      searchQuery: '',
      filteredPlayers: _allPlayers,
    );
  }

  void removeScorerGuess(int index) {
    final newGuesses = [...state.userScorerGuesses];
    newGuesses.removeAt(index);
    state = state.copyWith(userScorerGuesses: newGuesses);
  }

  void submitScorers() {
    if (state.gameState != WhoScoredGameState.scoreGuessing) return;

    int points = state.totalPoints + state.correctScorers * 5;
    state = state.copyWith(
      gameState: WhoScoredGameState.completed,
      scorersRevealed: true,
      totalPoints: points,
    );
  }

  Future<void> resetGame() async {
    final matches = await _ref.read(scoredMatchesProvider.future);
    if (matches.isEmpty) return;
    state = WhoScoredState(
      currentMatch: _pickMatch(matches),
      gameState: WhoScoredGameState.playing,
      filteredPlayers: _allPlayers,
    );
  }
}

final whoScoredGameProvider =
    StateNotifierProvider<WhoScoredGameNotifier, WhoScoredState>((ref) {
  return WhoScoredGameNotifier(ref);
});
