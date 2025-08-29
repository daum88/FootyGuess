import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/player.dart';
import '../../../data/services/football_database_service.dart';
import '../../../core/constants.dart';
import '../utils/guess_analyzer.dart';

final footballDatabaseServiceProvider =
    Provider<FootballDatabaseService>((ref) {
  return FootballDatabaseService();
});

enum GuessPlayerState {
  initial,
  playing,
  won,
  lost,
}

class GuessPlayerGameState {
  final Player? targetPlayer;
  final List<Player> guesses;
  final GuessPlayerState state;
  final int attemptsRemaining;
  final List<Player> filteredPlayers;
  final String searchQuery;
  final bool showHint;

  GuessPlayerGameState({
    this.targetPlayer,
    this.guesses = const [],
    this.state = GuessPlayerState.initial,
    this.attemptsRemaining = AppConstants.maxGuesses,
    this.filteredPlayers = const [],
    this.searchQuery = '',
    this.showHint = false,
  });

  GuessPlayerGameState copyWith({
    Player? targetPlayer,
    List<Player>? guesses,
    GuessPlayerState? state,
    int? attemptsRemaining,
    List<Player>? filteredPlayers,
    String? searchQuery,
    bool? showHint,
  }) {
    return GuessPlayerGameState(
      targetPlayer: targetPlayer ?? this.targetPlayer,
      guesses: guesses ?? this.guesses,
      state: state ?? this.state,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      filteredPlayers: filteredPlayers ?? this.filteredPlayers,
      searchQuery: searchQuery ?? this.searchQuery,
      showHint: showHint ?? this.showHint,
    );
  }
}

class GuessPlayerGameNotifier extends StateNotifier<GuessPlayerGameState> {
  final FootballDatabaseService _databaseService;
  List<Player> _allPlayers = [];

  GuessPlayerGameNotifier(this._databaseService)
      : super(GuessPlayerGameState());

  Future<void> initialize() async {
    try {
      _allPlayers = await _databaseService.getPlayers();
      if (_allPlayers.isNotEmpty) {
        final targetPlayer =
            _allPlayers[DateTime.now().day % _allPlayers.length];
        state = state.copyWith(
          targetPlayer: targetPlayer,
          state: GuessPlayerState.playing,
          filteredPlayers: _allPlayers,
        );
      }
    } catch (e) {
      // Handle error
      // Error initializing game: $e
    }
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

  void makeGuess(Player player) {
    if (state.state != GuessPlayerState.playing) return;

    final newGuesses = [...state.guesses, player];
    final isCorrect = player.name == state.targetPlayer?.name;
    final newAttemptsRemaining = state.attemptsRemaining - 1;

    GuessPlayerState newState;
    if (isCorrect) {
      newState = GuessPlayerState.won;
    } else if (newAttemptsRemaining <= 0) {
      newState = GuessPlayerState.lost;
    } else {
      newState = GuessPlayerState.playing;
    }

    state = state.copyWith(
      guesses: newGuesses,
      state: newState,
      attemptsRemaining: newAttemptsRemaining,
      searchQuery: '',
      filteredPlayers: _allPlayers,
    );
  }

  void showHint() {
    if (state.attemptsRemaining > 1) {
      state = state.copyWith(showHint: true);
    }
  }

  void resetGame() {
    if (_allPlayers.isNotEmpty) {
      final targetPlayer =
          _allPlayers[(DateTime.now().millisecond) % _allPlayers.length];
      state = GuessPlayerGameState(
        targetPlayer: targetPlayer,
        state: GuessPlayerState.playing,
        filteredPlayers: _allPlayers,
      );
    }
  }

  String getHintText() {
    if (!state.showHint || state.targetPlayer == null) return '';

    final player = state.targetPlayer!;
    final hints = [
      'Position: ${player.position}',
      'Current club: ${player.currentClub}',
      'Nationality: ${player.nationality}',
      'Age: ${player.age}',
    ];

    // Return a random hint
    return hints[DateTime.now().second % hints.length];
  }

  GuessComparison? getGuessComparison(Player guess) {
    if (state.targetPlayer == null) return null;
    return GuessAnalyzer.compareGuess(guess, state.targetPlayer!);
  }
}

final guessPlayerGameProvider =
    StateNotifierProvider<GuessPlayerGameNotifier, GuessPlayerGameState>((ref) {
  final databaseService = ref.read(footballDatabaseServiceProvider);
  return GuessPlayerGameNotifier(databaseService);
});
