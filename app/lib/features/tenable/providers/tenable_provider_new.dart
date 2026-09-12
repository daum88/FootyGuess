import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/game_data_providers.dart';
import '../../../data/models/game_data_models.dart';

extension FirstWhereOrNullExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// Tenable models (kept compatible with the existing page).
class TenableCsvAnswer {
  final int position;
  final String answer;
  final int value;

  const TenableCsvAnswer({
    required this.position,
    required this.answer,
    required this.value,
  });
}

class TenableCsvCategory {
  final String question;
  final String description;
  final List<TenableCsvAnswer> answers;

  const TenableCsvCategory({
    required this.question,
    required this.description,
    required this.answers,
  });
}

class TenableGameState {
  final TenableCsvCategory? currentCategory;
  final List<TenableCsvAnswer> foundAnswers;
  final List<String> incorrectGuesses;
  final GameStatus gameStatus;
  final int livesRemaining;
  final List<String> filteredSuggestions;
  final List<String> allPossibleAnswers;
  final String searchQuery;

  const TenableGameState({
    this.currentCategory,
    this.foundAnswers = const [],
    this.incorrectGuesses = const [],
    this.gameStatus = GameStatus.loading,
    this.livesRemaining = 3,
    this.filteredSuggestions = const [],
    this.allPossibleAnswers = const [],
    this.searchQuery = '',
  });

  TenableGameState copyWith({
    TenableCsvCategory? currentCategory,
    List<TenableCsvAnswer>? foundAnswers,
    List<String>? incorrectGuesses,
    GameStatus? gameStatus,
    int? livesRemaining,
    List<String>? filteredSuggestions,
    List<String>? allPossibleAnswers,
    String? searchQuery,
  }) {
    return TenableGameState(
      currentCategory: currentCategory ?? this.currentCategory,
      foundAnswers: foundAnswers ?? this.foundAnswers,
      incorrectGuesses: incorrectGuesses ?? this.incorrectGuesses,
      gameStatus: gameStatus ?? this.gameStatus,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      filteredSuggestions: filteredSuggestions ?? this.filteredSuggestions,
      allPossibleAnswers: allPossibleAnswers ?? this.allPossibleAnswers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  double get progress {
    if (currentCategory == null) return 0.0;
    return foundAnswers.length / currentCategory!.answers.length;
  }

  bool get isComplete =>
      currentCategory != null &&
      foundAnswers.length >= currentCategory!.answers.length;
}

enum GameStatus { loading, playing, won, lost }

class TenableGameNotifier extends StateNotifier<TenableGameState> {
  final Ref _ref;
  final Random _random = Random();
  List<TenableCsvCategory> _allCategories = [];
  List<String> _allKnownEntities = [];

  TenableGameNotifier(this._ref) : super(const TenableGameState());

  Future<void> initialize() async {
    try {
      final categories = await _ref.read(tenableProvider.future);
      final players = await _ref.read(playersProvider.future);
      final clubs = await _ref.read(clubsProvider.future);

      _allCategories = categories.map(_toCsvCategory).toList();
      _allKnownEntities = _buildEntities(categories, players, clubs);

      if (_allCategories.isEmpty) {
        state = state.copyWith(gameStatus: GameStatus.lost);
        return;
      }
      _generateRandomCategory();
    } catch (e) {
      debugPrint('❌ Tenable: initialization failed: $e');
      state = state.copyWith(gameStatus: GameStatus.lost);
    }
  }

  TenableCsvCategory _toCsvCategory(TenableCategory cat) {
    return TenableCsvCategory(
      question: cat.question,
      description: cat.description,
      answers: cat.answers
          .map((a) => TenableCsvAnswer(
                position: a.position,
                answer: a.answer,
                value: a.value,
              ))
          .toList(),
    );
  }

  List<String> _buildEntities(
      List<TenableCategory> categories, List<GamePlayer> players, List<GameClub> clubs) {
    final entities = <String>{};
    for (final cat in categories) {
      for (final a in cat.answers) {
        entities.add(a.answer);
      }
    }
    entities.addAll(players.map((p) => p.name));
    entities.addAll(clubs.map((c) => c.name));
    return entities.toList();
  }

  void _generateRandomCategory() {
    if (_allCategories.isEmpty) return;
    final selected = _allCategories[_random.nextInt(_allCategories.length)];
    state = state.copyWith(
      currentCategory: selected,
      foundAnswers: [],
      incorrectGuesses: [],
      gameStatus: GameStatus.playing,
      livesRemaining: 3,
      searchQuery: '',
      filteredSuggestions: [],
      allPossibleAnswers: _allKnownEntities,
    );
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    if (query.isEmpty) {
      state = state.copyWith(filteredSuggestions: []);
      return;
    }
    final lower = query.toLowerCase();
    final suggestions = _allKnownEntities
        .where((e) => e.toLowerCase().contains(lower))
        .take(5)
        .toList();
    state = state.copyWith(filteredSuggestions: suggestions);
  }

  void makeGuess(String guess) {
    final category = state.currentCategory;
    if (category == null || state.gameStatus != GameStatus.playing) return;

    final normalized = guess.trim().toLowerCase();
    if (normalized.isEmpty) return;

    if (state.foundAnswers.any((a) => a.answer.toLowerCase() == normalized) ||
        state.incorrectGuesses.contains(normalized)) {
      return;
    }

    TenableCsvAnswer? correct;
    for (final a in category.answers) {
      if (a.answer.toLowerCase() == normalized) {
        correct = a;
        break;
      }
    }

    if (correct != null) {
      final newFound = [...state.foundAnswers, correct];
      final won = newFound.length >= category.answers.length;
      state = state.copyWith(
        foundAnswers: newFound,
        gameStatus: won ? GameStatus.won : GameStatus.playing,
        searchQuery: '',
        filteredSuggestions: [],
      );
    } else {
      final newIncorrect = [...state.incorrectGuesses, normalized];
      final newLives = state.livesRemaining - 1;
      state = state.copyWith(
        incorrectGuesses: newIncorrect,
        livesRemaining: newLives,
        gameStatus: newLives <= 0 ? GameStatus.lost : GameStatus.playing,
        searchQuery: '',
        filteredSuggestions: [],
      );
    }
  }

  void resetGame() {
    state = TenableGameState(allPossibleAnswers: _allKnownEntities);
    _generateRandomCategory();
  }

  List<TenableCsvAnswer> getFoundAnswersWithValues() {
    return List.from(state.foundAnswers)
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  List<String> getAllAnswerEntities() {
    final category = state.currentCategory;
    if (category == null) return [];
    return category.answers.map((a) => a.answer).toList();
  }
}

final tenableGameNewProvider =
    StateNotifierProvider<TenableGameNotifier, TenableGameState>((ref) {
  return TenableGameNotifier(ref);
});
