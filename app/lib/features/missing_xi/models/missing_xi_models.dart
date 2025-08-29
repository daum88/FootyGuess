import '../../../data/models/player.dart';

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
