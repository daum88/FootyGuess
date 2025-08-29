import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/missing_xi_provider.dart';
import '../../../core/theme/retro_theme.dart';
import '../../../data/models/player.dart';

class MissingXiPage extends ConsumerStatefulWidget {
  const MissingXiPage({super.key});

  @override
  ConsumerState<MissingXiPage> createState() => _MissingXiPageState();
}

class _MissingXiPageState extends ConsumerState<MissingXiPage>
    with TickerProviderStateMixin {
  late AnimationController _fieldController;
  late AnimationController _jerseyController;
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  // Local state for search functionality - completely separate from provider
  List<Player> _localFilteredPlayers = [];
  List<Player> _allAvailablePlayers = [];
  int? _selectedPositionIndex;

  @override
  void initState() {
    super.initState();
    _fieldController = RetroAnimations.createBounceController(this);
    _jerseyController = RetroAnimations.createBounceController(this);
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Add listener for local search filtering
    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(missingXiGameProvider.notifier).initialize();
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _localFilteredPlayers = _allAvailablePlayers;
      } else {
        _localFilteredPlayers = _allAvailablePlayers
            .where((player) => player.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _showSearchPopup(BuildContext context, MissingXiState gameState,
      MissingXiGameNotifier notifier) {
    final selectedPosition =
        gameState.playerPositions[gameState.selectedPositionIndex!];

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                margin:
                    const EdgeInsets.only(top: 50), // Position under XI header
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RetroTheme.cardPurple,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RetroTheme.accentGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Text(
                      'SELECT PLAYER FOR ${selectedPosition.position}',
                      style: RetroTheme.retroSubheader.copyWith(
                        color: RetroTheme.accentGreen,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Search input with system keyboard
                    Container(
                      height: 50,
                      decoration: RetroTheme.retroContainer(
                        color: RetroTheme.backgroundDark,
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: true, // Auto-focus to show system keyboard
                        style: RetroTheme.retroBody.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type player name...',
                          hintStyle: RetroTheme.retroBody.copyWith(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: RetroTheme.accentGreen,
                            size: 24,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white54,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setDialogState(() {
                                _localFilteredPlayers = _allAvailablePlayers;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            _onSearchChanged();
                          });
                        },
                        onSubmitted: (value) {
                          if (_localFilteredPlayers.isNotEmpty) {
                            _placePlayerAndClosePopup(
                                _localFilteredPlayers.first, notifier, context);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Player list
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: RetroTheme.retroContainer(
                        color: RetroTheme.backgroundDark,
                      ),
                      child: _localFilteredPlayers.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                _searchController.text.isEmpty
                                    ? 'No compatible players for ${selectedPosition.position}'
                                    : 'No players found matching "${_searchController.text}"',
                                style: RetroTheme.retroBody.copyWith(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    _searchController.text.isEmpty
                                        ? 'Compatible players for ${selectedPosition.position}:'
                                        : 'Found ${_localFilteredPlayers.length} players:',
                                    style: RetroTheme.retroBody.copyWith(
                                      color: RetroTheme.accentGreen,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        _localFilteredPlayers.take(10).length,
                                    itemBuilder: (context, index) {
                                      final player =
                                          _localFilteredPlayers[index];
                                      return _buildPopupPlayerTile(
                                          player, notifier, context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 16),

                    // Close button
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: RetroTheme.retroButtonStyle.copyWith(
                        backgroundColor:
                            WidgetStateProperty.all(RetroTheme.heartRed),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        'CLOSE',
                        style: RetroTheme.retroButton
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _fieldController.dispose();
    _jerseyController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Returns realistic kit numbers based on football position
  int _getKitNumberForPosition(String position, int index) {
    switch (position) {
      case 'GK':
        return 1; // Goalkeeper traditionally wears #1
      case 'RB':
        return 2; // Right-back
      case 'LB':
        return 3; // Left-back
      case 'CB':
        // Center-backs typically wear 4, 5, or 6
        final cbNumbers = [4, 5, 6];
        return cbNumbers[index % cbNumbers.length];
      case 'CDM':
        return 6; // Defensive midfielder
      case 'CM':
        // Central midfielders typically 8, 10
        final cmNumbers = [8, 10];
        return cmNumbers[index % cmNumbers.length];
      case 'CAM':
        return 10; // Attacking midfielder - classic #10
      case 'LM':
        return 11; // Left midfielder
      case 'RM':
        return 7; // Right midfielder - classic winger number
      case 'LW':
        return 11; // Left winger
      case 'RW':
        return 7; // Right winger
      case 'ST':
        return 9; // Striker - classic #9
      case 'CF':
        return 9; // Center forward
      default:
        return (index % 11) + 1; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(missingXiGameProvider);
    final notifier = ref.read(missingXiGameProvider.notifier);

    // Update local state when provider state changes
    if (gameState.availablePlayers.isNotEmpty && _allAvailablePlayers.isEmpty) {
      _allAvailablePlayers = gameState.availablePlayers;
      _localFilteredPlayers = gameState.availablePlayers;
    }

    // Clear search when position changes
    if (_selectedPositionIndex != gameState.selectedPositionIndex) {
      _selectedPositionIndex = gameState.selectedPositionIndex;
      if (_selectedPositionIndex != null) {
        _searchController.clear();
        _localFilteredPlayers = _allAvailablePlayers;
        // Show search popup after position selection
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showSearchPopup(context, gameState, notifier);
        });
      }
    }

    return Scaffold(
      backgroundColor: RetroTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: RetroTheme.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black54,
        title: Text(
          'MISSING XI',
          style: RetroTheme.retroHeader.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: () => notifier.resetGame(),
          ),
        ],
      ),
      body: gameState.currentTeam == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Team header with retro styling - Fixed at top
                if (gameState.currentTeam != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildRetroTeamHeader(gameState.currentTeam!),
                  ),

                // Formation field - Scrollable area
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildRetroFormationField(gameState, notifier),
                      ),

                      // Game over overlay
                      if (gameState.gameState == MissingXiGameState.won ||
                          gameState.gameState == MissingXiGameState.lost)
                        _buildRetroGameOverOverlay(gameState, notifier),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRetroTeamHeader(MissingXiTeam team) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.accentGreen.withOpacity(0.1),
        border: Border.all(color: RetroTheme.accentGreen, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Opponent vs Team header if opponent is available
          if (_extractOpponentFromDescription(team.description) != null)
            Text(
              '${_extractOpponentFromDescription(team.description)!} vs ${team.teamName}',
              style: RetroTheme.retroSubheader.copyWith(
                color: RetroTheme.neonBlue,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
          else
            Text(
              team.teamName,
              style: RetroTheme.retroHeader.copyWith(
                color: RetroTheme.accentGreen,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          Text(
            team.description,
            style: RetroTheme.retroBody.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: RetroTheme.neonBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Formation: ${team.formation}',
              style: RetroTheme.retroBody.copyWith(
                color: RetroTheme.backgroundDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Extract opponent name from team description
  String? _extractOpponentFromDescription(String description) {
    // Try to extract opponent from common patterns in description
    // Looking for patterns like "vs Team", "against Team", etc.
    final vsPattern = RegExp(r'\bvs\s+([^,\(\-]+)', caseSensitive: false);
    final againstPattern =
        RegExp(r'\bagainst\s+([^,\(\-]+)', caseSensitive: false);

    var match = vsPattern.firstMatch(description);
    if (match != null) {
      return match.group(1)?.trim();
    }

    match = againstPattern.firstMatch(description);
    if (match != null) {
      return match.group(1)?.trim();
    }

    return null;
  }

  Widget _buildRetroFormationField(
      MissingXiState gameState, MissingXiGameNotifier notifier) {
    return Container(
      height: 500, // Realistic field height
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12), // Reasonable margins
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E7D32), // Dark green like screenshot
            Color(0xFF4CAF50),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use actual available space from LayoutBuilder
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;

            // Account for jersey size and padding
            const jerseyWidth = 46.0;
            const jerseyHeight = 58.0;
            const padding = 12.0; // Safe padding from edges

            // Calculate usable area for positioning
            final usableWidth = availableWidth - (2 * padding) - jerseyWidth;
            final usableHeight = availableHeight - (2 * padding) - jerseyHeight;

            return Stack(
              children: [
                // Field markings with retro style
                CustomPaint(
                  size: Size.infinite,
                  painter: RetroFieldPainter(),
                ),

                // Player positions with proper bounds checking
                ...gameState.playerPositions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final position = entry.value;

                  // Calculate positions within safe bounds
                  final xPosition = (position.x * usableWidth + padding)
                      .clamp(padding, availableWidth - jerseyWidth - padding);
                  final yPosition = (position.y * usableHeight + padding)
                      .clamp(padding, availableHeight - jerseyHeight - padding);

                  return Positioned(
                    left: xPosition,
                    top: yPosition,
                    child:
                        _buildRetroJersey(position, index, gameState, notifier),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRetroJersey(FormationPosition position, int index,
      MissingXiState gameState, MissingXiGameNotifier notifier) {
    final isSelected = gameState.selectedPositionIndex == index;
    final hasPlayer = position.player != null;

    // Jersey colors like in screenshot
    final jerseyColor = hasPlayer
        ? const Color(0xFF1976D2) // Blue jersey for filled positions
        : isSelected
            ? const Color(0xFFFFD700) // Gold for selected
            : RetroTheme.cardPurple; // Dark for empty

    // Real football kit numbers based on position
    final kitNumber = _getKitNumberForPosition(position.position, index);

    return GestureDetector(
      onTap: () {
        if (hasPlayer) {
          notifier.removePlayer(index);
          _jerseyController.forward().then((_) => _jerseyController.reverse());
        } else if (gameState.selectedPositionIndex != index) {
          // Only select if not already selected
          notifier.selectPosition(index);
        }
      },
      child: AnimatedContainer(
        duration: RetroAnimations.normalDuration,
        width: 46, // Realistic jersey width
        height: 58, // Realistic jersey height
        decoration: RetroTheme.jerseyStyle(
          teamColor: jerseyColor,
          isRevealed: hasPlayer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Jersey number section - properly sized
            Container(
              width: 30,
              height: 26,
              decoration: BoxDecoration(
                color: jerseyColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: hasPlayer
                    ? Text(
                        '$kitNumber',
                        style: RetroTheme.retroSubheader.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? Icons.add : Icons.sports_soccer,
                            color: isSelected ? Colors.black : Colors.white54,
                            size: 12,
                          ),
                          Text(
                            '$kitNumber',
                            style: RetroTheme.retroBody.copyWith(
                              color: Colors.white54,
                              fontSize: 7,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            // Name section - properly sized
            Container(
              width: 30,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: hasPlayer
                    ? Text(
                        position.player!.name.split(' ').last.toUpperCase(),
                        style: RetroTheme.retroBody.copyWith(
                          color: Colors.black,
                          fontSize: 6,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        '0',
                        style: RetroTheme.retroBody.copyWith(
                          color: Colors.black54,
                          fontSize: 7,
                        ),
                      ),
              ),
            ),
            // Position label - well spaced
            const SizedBox(height: 3),
            Text(
              position.position,
              style: RetroTheme.retroBody.copyWith(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                shadows: [
                  const Shadow(
                    color: Colors.black,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placePlayerAndClosePopup(
      Player player, MissingXiGameNotifier notifier, BuildContext context) {
    _searchController.clear();
    notifier.placePlayer(player);
    Navigator.of(context).pop(); // Close the popup
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();
  }

  Widget _buildPopupPlayerTile(
      Player player, MissingXiGameNotifier notifier, BuildContext context) {
    return InkWell(
      onTap: () => _placePlayerAndClosePopup(player, notifier, context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: RetroTheme.cardPurple.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: RetroTheme.accentGreen,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Center(
                child: Text(
                  player.name
                      .split(' ')
                      .map((part) => part.isNotEmpty ? part[0] : '')
                      .take(2)
                      .join(''),
                  style: RetroTheme.retroButton.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: RetroTheme.retroBody.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (player.position.isNotEmpty)
                    Text(
                      player.position,
                      style: RetroTheme.retroBody.copyWith(
                        color: RetroTheme.accentGreen,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline,
              color: RetroTheme.accentGreen,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetroGameOverOverlay(
      MissingXiState gameState, MissingXiGameNotifier notifier) {
    final isWon = gameState.gameState == MissingXiGameState.won;

    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: RetroTheme.retroContainer(
            color: RetroTheme.primaryPurple,
            hasGradient: true,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isWon ? Icons.emoji_events : Icons.close,
                size: 64,
                color: isWon ? RetroTheme.accentGreen : RetroTheme.heartRed,
              ),
              const SizedBox(height: 16),
              Text(
                isWon ? 'FORMATION COMPLETE!' : 'GAME OVER',
                style: RetroTheme.retroHeader.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (gameState.currentTeam != null)
                Text(
                  isWon
                      ? 'You completed the ${gameState.currentTeam!.teamName} formation!'
                      : 'Keep trying to complete the formation!',
                  style: RetroTheme.retroBody.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => notifier.resetGame(),
                style: RetroTheme.retroButtonStyle.copyWith(
                  backgroundColor:
                      WidgetStateProperty.all(RetroTheme.accentGreen),
                  foregroundColor: WidgetStateProperty.all(Colors.black),
                ),
                child: Text(
                  'NEW FORMATION',
                  style: RetroTheme.retroButton.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RetroFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5 // Slightly thinner lines for realism
      ..style = PaintingStyle.stroke;

    // Center circle - more realistic size
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.08, // Smaller, more realistic center circle
      paint,
    );

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Penalty areas with realistic proportions
    final penaltyWidth = size.width * 0.32; // More realistic width
    final penaltyHeight = size.height * 0.16; // More realistic height

    // Top penalty area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyWidth) / 2,
        0,
        penaltyWidth,
        penaltyHeight,
      ),
      paint,
    );

    // Bottom penalty area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyWidth) / 2,
        size.height - penaltyHeight,
        penaltyWidth,
        penaltyHeight,
      ),
      paint,
    );

    // Goal areas - more realistic proportions
    final goalWidth = size.width * 0.12; // Smaller goal area
    final goalHeight = size.height * 0.06; // Smaller goal area

    // Top goal area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalWidth) / 2,
        0,
        goalWidth,
        goalHeight,
      ),
      paint,
    );

    // Bottom goal area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalWidth) / 2,
        size.height - goalHeight,
        goalWidth,
        goalHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
