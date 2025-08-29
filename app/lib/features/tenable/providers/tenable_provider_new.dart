import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/services/tenable_data_service.dart';

extension FirstWhereOrNullList<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// CSV-based Tenable models
class TenableCsvAnswer {
  final int position;
  final String answer;
  final String value;

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

// New unified state for tenable game using CSV data
class TenableGameState {
  final TenableCsvCategory? currentCategory;
  final List<TenableCsvAnswer> foundAnswers; // CSV answers that have been found
  final List<String> incorrectGuesses;
  final GameStatus gameStatus;
  final int livesRemaining;
  final List<String> filteredSuggestions; // String suggestions for CSV data
  final List<String> allPossibleAnswers; // All possible answers user can search
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

  bool get isComplete {
    if (currentCategory == null) return false;
    return foundAnswers.length >= currentCategory!.answers.length;
  }
}

enum GameStatus { loading, playing, won, lost }

class TenableGameNotifier extends StateNotifier<TenableGameState> {
  final TenableDataService _csvService = TenableDataService();
  final Random _random = Random();
  List<TenableCsvCategory> _allCategories = [];
  List<String> _allKnownEntities = []; // All entities that can be searched

  TenableGameNotifier() : super(const TenableGameState());

  Future<void> initialize() async {
    print('TenableGameNotifier: Initializing with CSV data...');

    try {
      // Load categories from CSV
      _allCategories = await _loadCategoriesFromCsv();
      print('TenableGameNotifier: Loaded ${_allCategories.length} categories');

      // Build comprehensive list of all possible searchable entities
      await _buildAllKnownEntities();
      print(
          'TenableGameNotifier: Built ${_allKnownEntities.length} searchable entities');

      if (_allCategories.isEmpty) {
        print('TenableGameNotifier: No categories available');
        state = state.copyWith(gameStatus: GameStatus.lost);
        return;
      }

      // Generate a random category
      await _generateRandomCategory();
    } catch (e) {
      print('TenableGameNotifier: Error during initialization: $e');
      state = state.copyWith(gameStatus: GameStatus.lost);
    }
  }

  Future<void> _buildAllKnownEntities() async {
    // Create a comprehensive list of entities that users might search for
    final Set<String> allEntities = {};

    // Add all answers from all categories
    for (final category in _allCategories) {
      for (final answer in category.answers) {
        allEntities.add(answer.answer);
      }
    }

    // Load all players from the comprehensive player dataset
    final allPlayersFromDataset = await _loadAllPlayersFromDataset();
    allEntities.addAll(allPlayersFromDataset);

    // Add common football-related entities that users might try
    // (These will be wrong for most categories, but users should be able to search them)
    final commonFootballEntities = [
      // Top players
      'Lionel Messi', 'Cristiano Ronaldo', 'Kylian Mbappé', 'Erling Haaland',
      'Neymar', 'Mohamed Salah', 'Kevin De Bruyne', 'Sadio Mané',
      'Robert Lewandowski',
      'Virgil van Dijk', 'Luka Modrić', 'N\'Golo Kanté', 'Paul Pogba',
      'Harry Kane',
      'Raheem Sterling', 'Jadon Sancho', 'Phil Foden', 'Jack Grealish',
      'Mason Mount',
      'Jude Bellingham', 'Pedri', 'Gavi', 'Ansu Fati', 'Vinicius Jr',
      'Karim Benzema',
      'Toni Kroos', 'Casemiro', 'Sergio Ramos', 'Marcelo', 'Dani Alves',

      // Top clubs
      'Real Madrid', 'Barcelona', 'Manchester United', 'Manchester City',
      'Liverpool',
      'Chelsea', 'Arsenal', 'Tottenham', 'Bayern Munich', 'Borussia Dortmund',
      'Paris Saint-Germain', 'Juventus', 'AC Milan', 'Inter Milan', 'Napoli',
      'AS Roma', 'Atletico Madrid', 'Sevilla', 'Valencia', 'Ajax', 'PSV',
      'Porto', 'Benfica', 'Sporting CP', 'Galatasaray', 'Fenerbahçe',

      // Countries
      'Brazil', 'Argentina', 'France', 'Germany', 'Spain', 'England',
      'Portugal',
      'Netherlands', 'Italy', 'Belgium', 'Croatia', 'Poland', 'Mexico',
      'Uruguay',
      'Colombia', 'Chile', 'Peru', 'Morocco', 'Senegal', 'Nigeria', 'Ghana',
      'Algeria', 'Egypt', 'South Africa', 'Japan', 'South Korea', 'Australia',

      // Leagues
      'Premier League', 'La Liga', 'Bundesliga', 'Serie A', 'Ligue 1',
      'Eredivisie',
      'Primeira Liga', 'Süper Lig', 'MLS', 'Liga MX', 'Brasileirão',
      'Argentine Primera División',

      // Competitions
      'FIFA World Cup', 'UEFA European Championship', 'Copa América',
      'UEFA Champions League',
      'UEFA Europa League', 'FA Cup', 'Copa del Rey', 'DFB-Pokal',
      'Coppa Italia',
      'Coupe de France', 'EFL Cup', 'UEFA Super Cup', 'FIFA Club World Cup',

      // Positions
      'Goalkeeper', 'Defender', 'Midfielder', 'Forward', 'Striker', 'Winger',
      'Centre-back', 'Full-back', 'Wing-back', 'Defensive midfielder',
      'Central midfielder',
      'Attacking midfielder', 'Left-back', 'Right-back', 'Centre-forward',

      // Awards/Achievements
      'Ballon d\'Or', 'Golden Boot', 'Golden Ball', 'Golden Glove',
      'Player of the Year',
      'Young Player Award', 'Fair Play Award', 'Goal of the Tournament',
    ];

    allEntities.addAll(commonFootballEntities);

    _allKnownEntities = allEntities.toList();
  }

  Future<List<String>> _loadAllPlayersFromDataset() async {
    try {
      print('Loading all players from combined_all_lineups.csv...');
      const csvPath = 'assets/data/combined_all_lineups.csv';
      final csvString = await rootBundle.loadString(csvPath);
      final lines = csvString.split('\n');

      final Set<String> playerNames = {};

      // Skip header row and process each line
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        try {
          final parts = _parseCSVLine(line);
          if (parts.length >= 9) {
            final playerName = parts[8].trim(); // player_name is at index 8

            // Filter out invalid entries (numbers, empty strings, etc.)
            if (playerName.isNotEmpty &&
                !_isNumericString(playerName) &&
                playerName != 'player_name' &&
                playerName.length > 2) {
              playerNames.add(playerName);
            }
          }
        } catch (e) {
          // Skip problematic lines
          continue;
        }
      }

      print('Loaded ${playerNames.length} unique players from dataset');
      return playerNames.toList();
    } catch (e) {
      print('Error loading players from dataset: $e');
      return [];
    }
  }

  bool _isNumericString(String str) {
    return double.tryParse(str) != null;
  }

  List<String> _parseCSVLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          // Escaped quote
          buffer.write('"');
          i++; // Skip next quote
        } else {
          // Toggle quote state
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        // Field separator
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    // Add the last field
    result.add(buffer.toString());

    return result;
  }

  Future<List<TenableCsvCategory>> _loadCategoriesFromCsv() async {
    try {
      // Load raw CSV data
      final csvCategories = await _csvService.loadTenableCategories();

      // Convert to our model format
      final categories = <TenableCsvCategory>[];

      for (final csvCat in csvCategories) {
        final answers = csvCat.answers.asMap().entries.map((entry) {
          return TenableCsvAnswer(
            position: entry.key + 1,
            answer: entry.value,
            value: '${entry.key + 1}', // Position as value for now
          );
        }).toList();

        categories.add(TenableCsvCategory(
          question: csvCat.category,
          description: csvCat.description,
          answers: answers,
        ));
      }

      return categories;
    } catch (e) {
      print('TenableGameNotifier: Error loading CSV categories: $e');
      return [];
    }
  }

  Future<void> _generateRandomCategory() async {
    if (_allCategories.isEmpty) {
      print('TenableGameNotifier: No categories available');
      state = state.copyWith(gameStatus: GameStatus.lost);
      return;
    }

    // Select random category
    final randomIndex = _random.nextInt(_allCategories.length);
    final selectedCategory = _allCategories[randomIndex];

    print(
        'TenableGameNotifier: Selected category: ${selectedCategory.question}');
    print(
        'TenableGameNotifier: Number of answers: ${selectedCategory.answers.length}');

    state = state.copyWith(
      currentCategory: selectedCategory,
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

    final category = state.currentCategory;
    if (category == null) return;

    // Filter from all known entities, not just category answers
    final lowerQuery = query.toLowerCase();
    final suggestions = _allKnownEntities
        .where((entity) => entity.toLowerCase().contains(lowerQuery))
        .toList();

    // Limit to top 5 suggestions
    state = state.copyWith(
      filteredSuggestions: suggestions.take(5).toList(),
    );
  }

  void makeGuess(String guess) {
    final category = state.currentCategory;
    if (category == null || state.gameStatus != GameStatus.playing) return;

    // Check if we already guessed this answer (correct or incorrect)
    if (state.foundAnswers.any(
            (found) => found.answer.toLowerCase() == guess.toLowerCase()) ||
        state.incorrectGuesses.contains(guess.toLowerCase())) {
      print('TenableGameNotifier: Already guessed $guess, ignoring');
      return;
    }

    // Check if this is a correct answer
    final correctAnswer = category.answers.firstWhereOrNull(
      (answer) => answer.answer.toLowerCase() == guess.toLowerCase(),
    );

    if (correctAnswer != null) {
      // Correct answer!
      final newFoundAnswers = [...state.foundAnswers, correctAnswer];

      print(
          'TenableGameNotifier: Correct answer! $guess (${correctAnswer.value})');

      state = state.copyWith(
        foundAnswers: newFoundAnswers,
        searchQuery: '',
        filteredSuggestions: [],
      );

      // Check if game is complete
      if (newFoundAnswers.length >= category.answers.length) {
        state = state.copyWith(gameStatus: GameStatus.won);
        print('TenableGameNotifier: Category completed!');
      }
    } else {
      // Incorrect answer
      final newIncorrectGuesses = [
        ...state.incorrectGuesses,
        guess.toLowerCase()
      ];
      final newLives = state.livesRemaining - 1;

      print('TenableGameNotifier: Incorrect answer: $guess');

      state = state.copyWith(
        incorrectGuesses: newIncorrectGuesses,
        livesRemaining: newLives,
        searchQuery: '',
        filteredSuggestions: [],
      );

      // Check if game is over
      if (newLives <= 0) {
        state = state.copyWith(gameStatus: GameStatus.lost);
        print('TenableGameNotifier: Game over - no lives remaining');
      }
    }
  }

  void resetGame() {
    print('TenableGameNotifier: Resetting game...');
    state = TenableGameState(allPossibleAnswers: _allKnownEntities);
    _generateRandomCategory();
  }

  // Get found answers with their values and positions (for pyramid display)
  List<TenableCsvAnswer> getFoundAnswersWithValues() {
    return List.from(state.foundAnswers)
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  // Get all answer entities for this category (for showing missed answers)
  List<String> getAllAnswerEntities() {
    final category = state.currentCategory;
    if (category == null) return [];

    return category.answers.map((answer) => answer.answer).toList();
  }

  // Public method to get entity by ID for UI use (simplified for CSV data)
  String? getEntityById(String answer, String type) {
    return answer; // For CSV data, just return the answer itself
  }
}

// Provider
final tenableGameNewProvider =
    StateNotifierProvider<TenableGameNotifier, TenableGameState>((ref) {
  return TenableGameNotifier();
});
