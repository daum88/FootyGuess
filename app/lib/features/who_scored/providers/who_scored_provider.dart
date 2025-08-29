import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/player.dart';
import '../../../data/services/football_database_service.dart';

final footballDatabaseServiceProvider =
    Provider<FootballDatabaseService>((ref) {
  return FootballDatabaseService();
});

enum WhoScoredGameState {
  initial,
  playing,
  scoreGuessing,
  scorersGuessing,
  completed,
  won,
  lost,
}

class MatchData {
  final String homeTeam;
  final String awayTeam;
  final String homeTeamBadge;
  final String awayTeamBadge;
  final String date;
  final String competition;
  final int homeScore;
  final int awayScore;
  final List<Player> scorers;
  final List<int> scoringMinutes;

  const MatchData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamBadge,
    required this.awayTeamBadge,
    required this.date,
    required this.competition,
    required this.homeScore,
    required this.awayScore,
    required this.scorers,
    required this.scoringMinutes,
  });
}

class WhoScoredState {
  final MatchData? currentMatch;
  final WhoScoredGameState gameState;
  final String userHomeScore;
  final String userAwayScore;
  final List<String> userScorerGuesses;
  final List<Player> filteredPlayers;
  final String searchQuery;
  final bool scoreRevealed;
  final bool scorersRevealed;
  final int score;
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
    this.score = 0,
    this.totalPoints = 0,
  });

  WhoScoredState copyWith({
    MatchData? currentMatch,
    WhoScoredGameState? gameState,
    String? userHomeScore,
    String? userAwayScore,
    List<String>? userScorerGuesses,
    List<Player>? filteredPlayers,
    String? searchQuery,
    bool? scoreRevealed,
    bool? scorersRevealed,
    int? score,
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
      score: score ?? this.score,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  bool get isScoreCorrect =>
      userHomeScore == currentMatch?.homeScore.toString() &&
      userAwayScore == currentMatch?.awayScore.toString();

  int get correctScorers {
    if (currentMatch == null) return 0;
    return userScorerGuesses
        .where((guess) => currentMatch!.scorers.any((scorer) =>
            scorer.name.toLowerCase().contains(guess.toLowerCase()) ||
            guess.toLowerCase().contains(scorer.name.toLowerCase())))
        .length;
  }
}

class WhoScoredGameNotifier extends StateNotifier<WhoScoredState> {
  final FootballDatabaseService _databaseService;
  List<Player> _allPlayers = [];

  WhoScoredGameNotifier(this._databaseService) : super(const WhoScoredState());

  Future<void> initialize() async {
    try {
      _allPlayers = await _databaseService.getPlayers();
      if (_allPlayers.isNotEmpty) {
        final match = _generateMatch();
        state = state.copyWith(
          currentMatch: match,
          gameState: WhoScoredGameState.playing,
          filteredPlayers: _allPlayers,
        );
      }
    } catch (e) {
      // Error initializing who scored game: $e
    }
  }

  MatchData _generateMatch() {
    final teams = [
      {'name': 'Manchester City', 'badge': '🔵'},
      {'name': 'Liverpool', 'badge': '🔴'},
      {'name': 'Chelsea', 'badge': '🔵'},
      {'name': 'Arsenal', 'badge': '🔴'},
      {'name': 'Tottenham', 'badge': '⚪'},
      {'name': 'Manchester United', 'badge': '🔴'},
      {'name': 'Newcastle', 'badge': '⚫'},
      {'name': 'Brighton', 'badge': '🔵'},
      {'name': 'West Ham', 'badge': '⚪'},
      {'name': 'Aston Villa', 'badge': '🔴'},
    ];

    final competitions = [
      'Premier League',
      'Champions League',
      'FA Cup',
      'Carabao Cup',
      'Europa League',
    ];

    teams.shuffle();
    final homeTeam = teams[0];
    final awayTeam = teams[1];

    final homeScore = DateTime.now().day % 4; // 0-3 goals
    final awayScore = DateTime.now().hour % 4; // 0-3 goals
    final totalGoals = homeScore + awayScore;

    // Select random scorers
    final scorers = <Player>[];
    final scoringMinutes = <int>[];

    if (totalGoals > 0) {
      final availablePlayers = _allPlayers.toList()..shuffle();
      for (int i = 0; i < totalGoals && i < availablePlayers.length; i++) {
        scorers.add(availablePlayers[i]);
        scoringMinutes.add(15 + (i * 20) + (DateTime.now().minute % 10));
      }
    }

    return MatchData(
      homeTeam: homeTeam['name']!,
      awayTeam: awayTeam['name']!,
      homeTeamBadge: homeTeam['badge']!,
      awayTeamBadge: awayTeam['badge']!,
      date: _generateMatchDate(),
      competition: competitions[DateTime.now().day % competitions.length],
      homeScore: homeScore,
      awayScore: awayScore,
      scorers: scorers,
      scoringMinutes: scoringMinutes,
    );
  }

  String _generateMatchDate() {
    final dates = [
      '15 March 2024',
      '22 April 2024',
      '10 May 2024',
      '18 September 2024',
      '25 October 2024',
      '14 November 2024',
    ];
    return dates[DateTime.now().day % dates.length];
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
    if (state.isScoreCorrect) {
      points += 10; // Bonus for exact score
    }

    state = state.copyWith(
      gameState: WhoScoredGameState.scoreGuessing,
      scoreRevealed: true,
      totalPoints: points,
    );
  }

  void searchPlayers(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        filteredPlayers: _allPlayers,
        searchQuery: '',
      );
      return;
    }

    final filtered = _allPlayers
        .where(
            (player) => player.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    state = state.copyWith(
      filteredPlayers: filtered,
      searchQuery: query,
    );
  }

  void addScorerGuess(String playerName) {
    if (state.gameState != WhoScoredGameState.scoreGuessing) return;

    final newGuesses = [...state.userScorerGuesses, playerName];
    state = state.copyWith(
      userScorerGuesses: newGuesses,
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

    int points = state.totalPoints;

    // Award points for correct scorers
    points += state.correctScorers * 5;

    state = state.copyWith(
      gameState: WhoScoredGameState.completed,
      scorersRevealed: true,
      totalPoints: points,
    );
  }

  void resetGame() {
    if (_allPlayers.isNotEmpty) {
      final match = _generateMatch();
      state = WhoScoredState(
        currentMatch: match,
        gameState: WhoScoredGameState.playing,
        filteredPlayers: _allPlayers,
      );
    }
  }

  String getScoreText() {
    return '${state.totalPoints} pts';
  }

  double getProgress() {
    switch (state.gameState) {
      case WhoScoredGameState.initial:
        return 0.0;
      case WhoScoredGameState.playing:
        return 0.2;
      case WhoScoredGameState.scoreGuessing:
        return 0.6;
      case WhoScoredGameState.completed:
        return 1.0;
      default:
        return 0.0;
    }
  }
}

final whoScoredGameProvider =
    StateNotifierProvider<WhoScoredGameNotifier, WhoScoredState>((ref) {
  final databaseService = ref.read(footballDatabaseServiceProvider);
  return WhoScoredGameNotifier(databaseService);
});
