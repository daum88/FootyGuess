import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/player.dart';
import '../../../data/services/football_database_service.dart';
import '../../../data/services/csv_lineup_service.dart';

final footballDatabaseServiceProvider =
    Provider<FootballDatabaseService>((ref) {
  return FootballDatabaseService();
});

enum MissingXiGameState {
  initial,
  playing,
  won,
  lost,
}

class FormationPosition {
  final String position;
  final double x; // 0.0 to 1.0 (left to right)
  final double y; // 0.0 to 1.0 (top to bottom)
  final Player? player;

  const FormationPosition({
    required this.position,
    required this.x,
    required this.y,
    this.player,
  });

  FormationPosition copyWith({
    String? position,
    double? x,
    double? y,
    Player? player,
  }) {
    return FormationPosition(
      position: position ?? this.position,
      x: x ?? this.x,
      y: y ?? this.y,
      player: player,
    );
  }
}

class MissingXiTeam {
  final String teamName;
  final String description;
  final String formation; // e.g., "4-3-3"
  final List<FormationPosition> positions;

  const MissingXiTeam({
    required this.teamName,
    required this.description,
    required this.formation,
    required this.positions,
  });
}

class MissingXiState {
  final MissingXiTeam? currentTeam;
  final List<FormationPosition> playerPositions;
  final List<Player> availablePlayers;
  final MissingXiGameState gameState;
  final int attemptsRemaining;
  final List<Player> filteredPlayers;
  final String searchQuery;
  final int? selectedPositionIndex;

  const MissingXiState({
    this.currentTeam,
    this.playerPositions = const [],
    this.availablePlayers = const [],
    this.gameState = MissingXiGameState.initial,
    this.attemptsRemaining = 5,
    this.filteredPlayers = const [],
    this.searchQuery = '',
    this.selectedPositionIndex,
  });

  MissingXiState copyWith({
    MissingXiTeam? currentTeam,
    List<FormationPosition>? playerPositions,
    List<Player>? availablePlayers,
    MissingXiGameState? gameState,
    int? attemptsRemaining,
    List<Player>? filteredPlayers,
    String? searchQuery,
    int? selectedPositionIndex,
  }) {
    return MissingXiState(
      currentTeam: currentTeam ?? this.currentTeam,
      playerPositions: playerPositions ?? this.playerPositions,
      availablePlayers: availablePlayers ?? this.availablePlayers,
      gameState: gameState ?? this.gameState,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      filteredPlayers: filteredPlayers ?? this.filteredPlayers,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedPositionIndex: selectedPositionIndex,
    );
  }

  double get progress {
    if (playerPositions.isEmpty) return 0.0;
    final filledPositions =
        playerPositions.where((pos) => pos.player != null).length;
    return filledPositions / playerPositions.length;
  }

  bool get isComplete {
    return playerPositions.isNotEmpty &&
        playerPositions.every((pos) => pos.player != null);
  }
}

class MissingXiGameNotifier extends StateNotifier<MissingXiState> {
  final FootballDatabaseService _databaseService;
  final CsvLineupService _csvService = CsvLineupService();
  List<Player> _allPlayers = [];
  final List<Player> _csvPlayers = []; // Players from CSV teams

  MissingXiGameNotifier(this._databaseService) : super(const MissingXiState());

  Future<void> initialize() async {
    try {
      print('🚀 MissingXi: Starting OPTIMIZED initialization...');
      final stopwatch = Stopwatch()..start();

      // Load players from database using compatibility method
      final jsonPlayers = await _databaseService.getPlayers();
      _allPlayers = jsonPlayers;
      print('🚀 MissingXi: Loaded ${jsonPlayers.length} JSON players');

      // Load and extract players from CSV teams
      await _loadCsvPlayers();
      stopwatch.stop();
      print(
          '🚀 MissingXi: Total players available: ${_allPlayers.length} in ${stopwatch.elapsedMilliseconds}ms');

      // Try to get CSV team first
      MissingXiTeam? team;
      try {
        print('🚀 MissingXi: Loading CSV team...');
        team = await _csvService.getRandomTeam();
        if (team != null) {
          print(
              '🚀 MissingXi: CSV loaded successfully, got team: ${team.teamName}');
        } else {
          print('🚀 MissingXi: CSV returned null, using fallback');
        }
      } catch (e) {
        print('🚀 MissingXi: CSV loading failed: $e, using fallback');
      }

      // Use CSV team if available, otherwise fallback
      if (team == null) {
        print('🚀 MissingXi: Using fallback team');
        team = _generateRandomTeam();
      }

      state = state.copyWith(
        currentTeam: team,
        playerPositions: team.positions,
        availablePlayers: _allPlayers,
        gameState: MissingXiGameState.playing,
        filteredPlayers: _allPlayers,
      );

      print(
          '🚀 MissingXi: OPTIMIZED initialization complete with team: ${team.teamName}!');
    } catch (e) {
      print('❌ MissingXi: Initialization failed: $e');
      rethrow;
    }
  }

  /// Load all unique players from CSV teams and add them to the player database
  Future<void> _loadCsvPlayers() async {
    try {
      print('🔍 Loading REAL players from CSV data...');

      // Get all unique players from CSV
      final csvPlayerData = await _csvService.getAllPlayersFromCsv();

      // Create a set to track existing player names (case-insensitive)
      final existingPlayerNames =
          _allPlayers.map((p) => p.name.toLowerCase().trim()).toSet();

      print('🔍 Existing JSON players: ${existingPlayerNames.length}');

      // Convert CSV player data to Player objects, avoiding duplicates
      int addedCount = 0;
      for (int i = 0; i < csvPlayerData.length; i++) {
        final playerData = csvPlayerData[i];
        final playerName = playerData['name'] as String;
        final normalizedName = playerName.toLowerCase().trim();

        // Skip if player already exists in JSON data
        if (existingPlayerNames.contains(normalizedName)) {
          continue;
        }

        final position = playerData['position'] as String;
        final nationality = playerData['nationality'] as String;

        // Create comprehensive position lists for each player
        final positions = [position];

        // Add position flexibility based on real football positions
        if (position == 'CB') positions.addAll(['RB', 'LB', 'RCB', 'LCB']);
        if (position == 'CM') positions.addAll(['CDM', 'CAM', 'RCM', 'LCM']);
        if (position == 'LW') positions.addAll(['LM', 'ST', 'LST']);
        if (position == 'RW') positions.addAll(['RM', 'ST', 'RST']);
        if (position == 'ST') positions.addAll(['CF', 'LST', 'RST']);

        final player = Player(
          id: 'csv_${addedCount}_${normalizedName.replaceAll(' ', '_').replaceAll('.', '')}',
          name: playerName,
          nationality: nationality,
          dateOfBirth:
              DateTime(1985 + (addedCount % 20)), // Vary ages between 1985-2005
          positions: positions,
          primaryPosition: position,
          clubs: [], // CSV players don't have club history in this context
          leagues: [],
          teammatesHash: '',
        );

        _csvPlayers.add(player);
        existingPlayerNames.add(normalizedName); // Track this new player
        addedCount++;
      }

      // Combine JSON and unique CSV players
      _allPlayers = [..._allPlayers, ..._csvPlayers];

      print('🔍 Added ${_csvPlayers.length} unique CSV players to database');
      print(
          '🔍 Skipped ${csvPlayerData.length - _csvPlayers.length} duplicate players');
      print('🔍 Total unique players: ${_allPlayers.length}');
      print(
          '🔍 Sample new CSV players: ${_csvPlayers.take(5).map((p) => p.name).join(', ')}');
    } catch (e) {
      print('🔍 Failed to load CSV players: $e');
      // Continue with just JSON players if CSV parsing fails
    }
  }

  MissingXiTeam _generateRandomTeam() {
    final teams = [
      _createClassicBarcelona(),
      _createClassicRealMadrid(),
      _createPremierLeagueTeam(),
      _createWorldCupWinners(),
      _createChampionsLeagueTeam(),
    ];

    return teams[DateTime.now().day % teams.length];
  }

  MissingXiTeam _createClassicBarcelona() {
    // 4-3-3 formation
    final positions = [
      // Goalkeeper
      FormationPosition(position: 'GK', x: 0.5, y: 0.9),

      // Defense
      FormationPosition(position: 'RB', x: 0.8, y: 0.7),
      FormationPosition(position: 'CB', x: 0.65, y: 0.7),
      FormationPosition(position: 'CB', x: 0.35, y: 0.7),
      FormationPosition(position: 'LB', x: 0.2, y: 0.7),

      // Midfield
      FormationPosition(position: 'CDM', x: 0.5, y: 0.5),
      FormationPosition(position: 'CM', x: 0.3, y: 0.4),
      FormationPosition(position: 'CM', x: 0.7, y: 0.4),

      // Attack
      FormationPosition(position: 'RW', x: 0.8, y: 0.2),
      FormationPosition(position: 'ST', x: 0.5, y: 0.1),
      FormationPosition(position: 'LW', x: 0.2, y: 0.2),
    ];

    return MissingXiTeam(
      teamName: 'FC Barcelona',
      description: 'Classic Barcelona 2008-2012 era',
      formation: '4-3-3',
      positions: positions,
    );
  }

  MissingXiTeam _createClassicRealMadrid() {
    // 4-2-3-1 formation
    final positions = [
      // Goalkeeper
      FormationPosition(position: 'GK', x: 0.5, y: 0.9),

      // Defense
      FormationPosition(position: 'RB', x: 0.8, y: 0.7),
      FormationPosition(position: 'CB', x: 0.6, y: 0.7),
      FormationPosition(position: 'CB', x: 0.4, y: 0.7),
      FormationPosition(position: 'LB', x: 0.2, y: 0.7),

      // Midfield
      FormationPosition(position: 'CDM', x: 0.4, y: 0.5),
      FormationPosition(position: 'CDM', x: 0.6, y: 0.5),

      // Attack
      FormationPosition(position: 'CAM', x: 0.5, y: 0.3),
      FormationPosition(position: 'RW', x: 0.8, y: 0.3),
      FormationPosition(position: 'LW', x: 0.2, y: 0.3),
      FormationPosition(position: 'ST', x: 0.5, y: 0.1),
    ];

    return MissingXiTeam(
      teamName: 'Real Madrid',
      description: 'Galácticos era Real Madrid',
      formation: '4-2-3-1',
      positions: positions,
    );
  }

  MissingXiTeam _createPremierLeagueTeam() {
    // 4-4-2 formation
    final positions = [
      // Goalkeeper
      FormationPosition(position: 'GK', x: 0.5, y: 0.9),

      // Defense
      FormationPosition(position: 'RB', x: 0.8, y: 0.7),
      FormationPosition(position: 'CB', x: 0.6, y: 0.7),
      FormationPosition(position: 'CB', x: 0.4, y: 0.7),
      FormationPosition(position: 'LB', x: 0.2, y: 0.7),

      // Midfield
      FormationPosition(position: 'RM', x: 0.8, y: 0.4),
      FormationPosition(position: 'CM', x: 0.6, y: 0.4),
      FormationPosition(position: 'CM', x: 0.4, y: 0.4),
      FormationPosition(position: 'LM', x: 0.2, y: 0.4),

      // Attack
      FormationPosition(position: 'ST', x: 0.4, y: 0.1),
      FormationPosition(position: 'ST', x: 0.6, y: 0.1),
    ];

    return MissingXiTeam(
      teamName: 'Premier League XI',
      description: 'Best Premier League players',
      formation: '4-4-2',
      positions: positions,
    );
  }

  MissingXiTeam _createWorldCupWinners() {
    // 4-2-3-1 formation
    final positions = [
      FormationPosition(position: 'GK', x: 0.5, y: 0.9),
      FormationPosition(position: 'RB', x: 0.8, y: 0.7),
      FormationPosition(position: 'CB', x: 0.6, y: 0.7),
      FormationPosition(position: 'CB', x: 0.4, y: 0.7),
      FormationPosition(position: 'LB', x: 0.2, y: 0.7),
      FormationPosition(position: 'CDM', x: 0.4, y: 0.5),
      FormationPosition(position: 'CDM', x: 0.6, y: 0.5),
      FormationPosition(position: 'CAM', x: 0.5, y: 0.3),
      FormationPosition(position: 'RW', x: 0.8, y: 0.3),
      FormationPosition(position: 'LW', x: 0.2, y: 0.3),
      FormationPosition(position: 'ST', x: 0.5, y: 0.1),
    ];

    return MissingXiTeam(
      teamName: 'World Cup Winners',
      description: 'Recent World Cup winning team',
      formation: '4-2-3-1',
      positions: positions,
    );
  }

  MissingXiTeam _createChampionsLeagueTeam() {
    // 3-5-2 formation
    final positions = [
      FormationPosition(position: 'GK', x: 0.5, y: 0.9),
      FormationPosition(position: 'CB', x: 0.3, y: 0.7),
      FormationPosition(position: 'CB', x: 0.5, y: 0.7),
      FormationPosition(position: 'CB', x: 0.7, y: 0.7),
      FormationPosition(position: 'LWB', x: 0.1, y: 0.5),
      FormationPosition(position: 'CM', x: 0.3, y: 0.4),
      FormationPosition(position: 'CM', x: 0.5, y: 0.4),
      FormationPosition(position: 'CM', x: 0.7, y: 0.4),
      FormationPosition(position: 'RWB', x: 0.9, y: 0.5),
      FormationPosition(position: 'ST', x: 0.4, y: 0.1),
      FormationPosition(position: 'ST', x: 0.6, y: 0.1),
    ];

    return MissingXiTeam(
      teamName: 'Champions League XI',
      description: 'Champions League winning formation',
      formation: '3-5-2',
      positions: positions,
    );
  }

  void searchPlayers(String query) {
    print('🔍 Search called with query: "$query"');

    // Don't update state if the query hasn't actually changed
    if (state.searchQuery == query) {
      print('🔍 Query unchanged, skipping update');
      return;
    }

    if (query.isEmpty) {
      final allPlayers = _getCorrectPlayersForPosition();
      print('🔍 Empty query, showing ${allPlayers.length} players');
      state = state.copyWith(
        filteredPlayers: allPlayers,
        searchQuery: '',
      );
      return;
    }

    // Get only the correct players for the selected position, then filter by query
    final correctPlayers = _getCorrectPlayersForPosition();
    final filtered = correctPlayers
        .where(
            (player) => player.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    print(
        '🔍 Filtered ${correctPlayers.length} -> ${filtered.length} players for query "$query"');

    state = state.copyWith(
      filteredPlayers: filtered,
      searchQuery: query,
    );
  }

  /// Get the correct players for the currently selected position from CSV data
  List<Player> _getCorrectPlayersForPosition() {
    // Return ALL players for search - let users search themselves
    print(
        '🔍 Returning ALL ${_allPlayers.length} players for search (no position filtering)');
    return _allPlayers;
  }

  /// Check if positions are compatible (e.g., CM can play CDM, CB can play RB, etc.)
  bool _isPositionCompatible(
      String requiredPosition, List<String> playerPositions) {
    final defensive = ['CB', 'RB', 'LB', 'RWB', 'LWB', 'RCB', 'LCB', 'SW'];
    final midfield = [
      'CDM',
      'CM',
      'CAM',
      'RM',
      'LM',
      'RW',
      'LW',
      'RCM',
      'LCM',
      'AM'
    ];
    final attacking = [
      'ST',
      'CF',
      'RW',
      'LW',
      'LST',
      'RST',
      'SS',
      'F',
      'LF',
      'RF'
    ];

    // Goalkeeper variations
    if (requiredPosition == 'GK' || requiredPosition == 'GKP') {
      return playerPositions.any((pos) => pos == 'GK' || pos == 'GKP');
    }

    // Check if any player position is in the same category as required position
    if (defensive.contains(requiredPosition)) {
      return playerPositions.any((pos) => defensive.contains(pos));
    }

    if (midfield.contains(requiredPosition)) {
      return playerPositions.any((pos) => midfield.contains(pos));
    }

    if (attacking.contains(requiredPosition)) {
      return playerPositions.any((pos) => attacking.contains(pos));
    }

    return false;
  }

  /// Check if the selected player is correct for the position
  bool _isCorrectPlayerForPosition(Player player, FormationPosition position) {
    if (state.currentTeam == null) return false;

    // For CSV teams, we need to implement actual team roster matching
    // For now, accept any player with compatible position as a placeholder
    // This should be replaced with actual CSV team data matching

    final playerPositions =
        player.positions.map((p) => p.toUpperCase()).toList();
    final requiredPosition = position.position.toUpperCase();

    // Accept direct position match or compatible positions
    final isValid = playerPositions.contains(requiredPosition) ||
        _isPositionCompatible(requiredPosition, playerPositions);

    print(
        '🔍 Validating player: ${player.name} (${player.positions.join(', ')}) for ${position.position} -> ${isValid ? 'CORRECT' : 'WRONG'}');

    return isValid;
  }

  void selectPosition(int positionIndex) {
    // Don't update state if the same position is already selected
    if (state.selectedPositionIndex == positionIndex) {
      print('🎯 Position $positionIndex already selected, skipping update');
      return;
    }

    final availablePlayers = _getCorrectPlayersForPosition();
    print(
        '🎯 Position $positionIndex selected (was ${state.selectedPositionIndex}), initializing with ${availablePlayers.length} players');

    state = state.copyWith(
      selectedPositionIndex: positionIndex,
      filteredPlayers:
          availablePlayers, // Show all compatible players initially
      searchQuery: '', // Clear search query for new position
    );
  }

  void placePlayer(Player player) {
    if (state.selectedPositionIndex == null ||
        state.gameState != MissingXiGameState.playing) {
      return;
    }

    final selectedPosition =
        state.playerPositions[state.selectedPositionIndex!];

    // Check if the player belongs to the current team for this position
    final isCorrectPlayer =
        _isCorrectPlayerForPosition(player, selectedPosition);

    if (!isCorrectPlayer) {
      // Wrong player - decrement attempts but keep position selected
      final newAttempts = state.attemptsRemaining - 1;
      final newGameState = newAttempts <= 0
          ? MissingXiGameState.lost
          : MissingXiGameState.playing;

      state = state.copyWith(
        attemptsRemaining: newAttempts,
        gameState: newGameState,
        searchQuery: '', // Clear search but keep position selected
        filteredPlayers: _allPlayers,
      );
      return;
    }

    // Correct player - place them and clear selection
    final newPositions = List<FormationPosition>.from(state.playerPositions);
    newPositions[state.selectedPositionIndex!] =
        newPositions[state.selectedPositionIndex!].copyWith(player: player);

    MissingXiGameState newGameState = MissingXiGameState.playing;
    if (newPositions.every((pos) => pos.player != null)) {
      newGameState = MissingXiGameState.won;
    }

    state = state.copyWith(
      playerPositions: newPositions,
      gameState: newGameState,
      selectedPositionIndex: null, // Only clear selection on correct guess
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

  void resetGame() async {
    if (_allPlayers.isNotEmpty) {
      final team = await _csvService.getRandomTeam();
      if (team != null) {
        state = MissingXiState(
          currentTeam: team,
          playerPositions: team.positions,
          gameState: MissingXiGameState.playing,
          filteredPlayers: _allPlayers,
        );
      }
    }
  }

  String getProgressText() {
    final filledPositions =
        state.playerPositions.where((pos) => pos.player != null).length;
    return '$filledPositions/${state.playerPositions.length}';
  }
}

final missingXiGameProvider =
    StateNotifierProvider<MissingXiGameNotifier, MissingXiState>((ref) {
  final databaseService = ref.read(footballDatabaseServiceProvider);
  return MissingXiGameNotifier(databaseService);
});
