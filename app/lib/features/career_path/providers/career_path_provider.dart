import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/player.dart';
import '../../../data/services/career_stats_service.dart';
import '../../../core/constants.dart';

enum CareerPathGameState {
  initial,
  playing,
  won,
  lost,
}

class CareerPathState {
  final Player? targetPlayer;
  final List<ClubHistory> revealedClubs;
  final CareerPathGameState gameState;
  final int currentClue;
  final int attemptsRemaining;
  final List<Player> guesses;
  final List<Player> filteredPlayers;
  final String searchQuery;

  const CareerPathState({
    this.targetPlayer,
    this.revealedClubs = const [],
    this.gameState = CareerPathGameState.initial,
    this.currentClue = 0,
    this.attemptsRemaining = AppConstants.maxGuesses,
    this.guesses = const [],
    this.filteredPlayers = const [],
    this.searchQuery = '',
  });

  CareerPathState copyWith({
    Player? targetPlayer,
    List<ClubHistory>? revealedClubs,
    CareerPathGameState? gameState,
    int? currentClue,
    int? attemptsRemaining,
    List<Player>? guesses,
    List<Player>? filteredPlayers,
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
  List<Player> _allPlayers = [];

  CareerPathGameNotifier() : super(const CareerPathState());

  Future<void> initialize() async {
    try {
      print('🚀 CareerPathGameNotifier: Initializing game');
      final stopwatch = Stopwatch()..start();

      // Set loading state first
      state = state.copyWith(gameState: CareerPathGameState.initial);

      // Load career players using the real career data
      _allPlayers = await CareerStatsService.loadCareerPlayers();

      stopwatch.stop();
      print(
          '🚀 CareerPathGameNotifier: Loaded ${_allPlayers.length} career players in ${stopwatch.elapsedMilliseconds}ms');

      if (_allPlayers.isNotEmpty) {
        final targetPlayer =
            _allPlayers[DateTime.now().day % _allPlayers.length];
        print(
            '🚀 CareerPathGameNotifier: Selected target player: ${targetPlayer.name}');

        state = state.copyWith(
          targetPlayer: targetPlayer,
          gameState: CareerPathGameState.playing,
          filteredPlayers: _allPlayers,
        );
      } else {
        print(
            '❌ CareerPathGameNotifier: No players available for career path game');
        state = state.copyWith(gameState: CareerPathGameState.initial);
      }
    } catch (e) {
      print(
          '❌ CareerPathGameNotifier: Error initializing career path game: $e');
      state = state.copyWith(gameState: CareerPathGameState.initial);
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

  void revealNextClue() {
    if (state.targetPlayer == null ||
        state.gameState != CareerPathGameState.playing) {
      return;
    }

    final sortedClubs = state.targetPlayer!.clubs.toList()
      ..sort((a, b) => a.from.compareTo(b.from));

    if (state.currentClue < sortedClubs.length) {
      final newRevealedClubs = [
        ...state.revealedClubs,
        sortedClubs[state.currentClue]
      ];

      state = state.copyWith(
        revealedClubs: newRevealedClubs,
        currentClue: state.currentClue + 1,
      );

      print(
          '🚀 CareerPathGameNotifier: Revealed clue ${state.currentClue}: ${sortedClubs[state.currentClue - 1].clubId}');
    }
  }

  void makeGuess(Player player) {
    if (state.gameState != CareerPathGameState.playing) return;

    final newGuesses = [...state.guesses, player];
    final isCorrect = player.name == state.targetPlayer?.name;
    final newAttemptsRemaining = state.attemptsRemaining - 1;

    print(
        '🚀 CareerPathGameNotifier: Player guessed ${player.name}, correct: $isCorrect');

    CareerPathGameState newGameState;
    if (isCorrect) {
      newGameState = CareerPathGameState.won;
      print('🎉 CareerPathGameNotifier: Player won!');
    } else if (newAttemptsRemaining <= 0) {
      newGameState = CareerPathGameState.lost;
      print(
          '💀 CareerPathGameNotifier: Player lost! Answer was ${state.targetPlayer?.name}');
    } else {
      newGameState = CareerPathGameState.playing;
      // Auto-reveal next clue after wrong guess
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
    print('🚀 CareerPathGameNotifier: Resetting game');
    if (_allPlayers.isNotEmpty) {
      final targetPlayer =
          _allPlayers[(DateTime.now().millisecond) % _allPlayers.length];
      print(
          '🚀 CareerPathGameNotifier: New target player: ${targetPlayer.name}');

      state = CareerPathState(
        targetPlayer: targetPlayer,
        gameState: CareerPathGameState.playing,
        filteredPlayers: _allPlayers,
      );
    }
  }

  void revealAnswer() {
    if (state.targetPlayer == null) return;

    print(
        '🚀 CareerPathGameNotifier: Revealing answer: ${state.targetPlayer!.name}');

    // Reveal all clubs
    final sortedClubs = state.targetPlayer!.clubs.toList()
      ..sort((a, b) => a.from.compareTo(b.from));

    state = state.copyWith(
      revealedClubs: sortedClubs,
      currentClue: sortedClubs.length,
      gameState: CareerPathGameState.lost, // Set to lost state to show answer
      searchQuery: '',
      filteredPlayers: _allPlayers,
    );
  }

  String getClueText(ClubHistory club) {
    final yearStart = club.from.year;
    final yearEnd = club.to?.year ?? 'Present';
    final loanText = club.isLoan ? ' (Loan)' : '';

    return '$yearStart - $yearEnd: ${club.clubId}$loanText';
  }
}

final careerPathGameProvider =
    StateNotifierProvider<CareerPathGameNotifier, CareerPathState>((ref) {
  return CareerPathGameNotifier();
});
