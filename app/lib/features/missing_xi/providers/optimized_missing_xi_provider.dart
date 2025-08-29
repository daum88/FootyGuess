import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/player.dart';
import '../../../core/providers/optimized_data_providers.dart';
import '../models/missing_xi_models.dart';

class OptimizedMissingXiNotifier extends StateNotifier<MissingXiState> {
  final Ref _ref;
  List<Player> _allPlayers = [];

  OptimizedMissingXiNotifier(this._ref) : super(const MissingXiState());

  Future<void> initialize() async {
    try {
      print('🚀 OptimizedMissingXi: Starting fast initialization...');
      final stopwatch = Stopwatch()..start();

      // Get players from optimized cache - this should be nearly instant
      final dataService = _ref.read(optimizedDataServiceProvider);
      final players = await dataService.getPlayers();

      _allPlayers = players;
      stopwatch.stop();

      print(
          '🚀 OptimizedMissingXi: Loaded ${players.length} players in ${stopwatch.elapsedMilliseconds}ms');

      // Generate random team
      final team = _generateRandomTeam();

      state = state.copyWith(
        currentTeam: team,
        playerPositions: team.positions,
        availablePlayers: _allPlayers,
        gameState: MissingXiGameState.playing,
        filteredPlayers: _allPlayers,
      );

      print(
          '🚀 OptimizedMissingXi: Initialization complete with team: ${team.teamName}!');
    } catch (e) {
      print('❌ OptimizedMissingXi: Initialization failed: $e');
      rethrow;
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
      final team = _generateRandomTeam();
      state = MissingXiState(
        currentTeam: team,
        playerPositions: team.positions,
        gameState: MissingXiGameState.playing,
        filteredPlayers: _allPlayers,
        availablePlayers: _allPlayers,
      );
    }
  }

  String getProgressText() {
    final filledPositions =
        state.playerPositions.where((pos) => pos.player != null).length;
    return '$filledPositions/${state.playerPositions.length}';
  }
}

final optimizedMissingXiGameProvider =
    StateNotifierProvider<OptimizedMissingXiNotifier, MissingXiState>((ref) {
  return OptimizedMissingXiNotifier(ref);
});
