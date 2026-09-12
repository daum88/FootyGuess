import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/missing_xi_provider.dart';
import '../models/missing_xi_models.dart';
import '../../../core/theme/modern_theme.dart';
import '../../../data/models/game_data_models.dart';

class MissingXiPage extends ConsumerStatefulWidget {
  const MissingXiPage({super.key});

  @override
  ConsumerState<MissingXiPage> createState() => _MissingXiPageState();
}

class _MissingXiPageState extends ConsumerState<MissingXiPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<GamePlayer> _localFilteredPlayers = [];
  List<GamePlayer> _allAvailablePlayers = [];
  int? _selectedPositionIndex;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(missingXiGameProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _localFilteredPlayers = query.isEmpty
          ? _allAvailablePlayers
          : _allAvailablePlayers
              .where((p) => p.name.toLowerCase().contains(query))
              .toList();
    });
  }

  void _showSearchDialog(BuildContext context, MissingXiState gameState,
      MissingXiGameNotifier notifier, String position) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(ModernTheme.spacing16),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 480),
            padding: const EdgeInsets.all(ModernTheme.spacing16),
            decoration: ModernTheme.glassCard(
              borderRadius: ModernTheme.radiusLarge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Pick a $position',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: ModernTheme.spacing12),
                Container(
                  decoration: ModernTheme.glassCard(
                    borderRadius: ModernTheme.radiusPill,
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Type a player name...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() =>
                              _localFilteredPlayers = _allAvailablePlayers);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ModernTheme.radiusPill),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: ModernTheme.spacing16,
                        vertical: ModernTheme.spacing12,
                      ),
                    ),
                    onChanged: (_) => setState(() => _onSearchChanged()),
                    onSubmitted: (value) {
                      if (_localFilteredPlayers.isNotEmpty) {
                        _placePlayerAndClose(
                            _localFilteredPlayers.first, notifier, dialogContext);
                      }
                    },
                  ),
                ),
                const SizedBox(height: ModernTheme.spacing12),
                Flexible(
                  child: _localFilteredPlayers.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(ModernTheme.spacing20),
                          child: Text('No players found',
                              style: Theme.of(context).textTheme.bodyMedium),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _localFilteredPlayers.take(20).length,
                          itemBuilder: (context, index) {
                            final player = _localFilteredPlayers[index];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                backgroundColor: ModernTheme.accentMint,
                                child: Text(
                                  player.name.isNotEmpty ? player.name[0] : '?',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              title: Text(player.name,
                                  style: Theme.of(context).textTheme.labelLarge),
                              subtitle: Text(
                                player.primaryPosition,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () => _placePlayerAndClose(
                                  player, notifier, dialogContext),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _placePlayerAndClose(GamePlayer player,
      MissingXiGameNotifier notifier, BuildContext dialogContext) {
    _searchController.clear();
    notifier.placePlayer(player);
    Navigator.of(dialogContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(missingXiGameProvider);
    final notifier = ref.read(missingXiGameProvider.notifier);

    if (gameState.availablePlayers.isNotEmpty && _allAvailablePlayers.isEmpty) {
      _allAvailablePlayers = gameState.availablePlayers;
      _localFilteredPlayers = gameState.availablePlayers;
    }

    if (_selectedPositionIndex != gameState.selectedPositionIndex) {
      _selectedPositionIndex = gameState.selectedPositionIndex;
      if (_selectedPositionIndex != null && gameState.currentTeam != null) {
        _searchController.clear();
        _localFilteredPlayers = _allAvailablePlayers;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final position = gameState.playerPositions[_selectedPositionIndex!];
            _showSearchDialog(
                context, gameState, notifier, position.position);
          }
        });
      }
    }

    final team = gameState.currentTeam;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE5F1FF), Color(0xFFF8F9FA), Color(0xFFE5FFE9)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(ModernTheme.spacing20),
                  decoration: ModernTheme.glassGradient(
                    colors: [ModernTheme.accentMint, ModernTheme.accentSky],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              ModernTheme.backgroundAccent.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(width: ModernTheme.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Missing XI',
                                style: Theme.of(context).textTheme.headlineMedium),
                            Text(
                              team != null
                                  ? '${team.teamName} • ${team.formation}'
                                  : 'Complete the lineup',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: notifier.resetGame,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('New'),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              ModernTheme.backgroundAccent.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: team == null
                      ? const Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(ModernTheme.spacing16),
                              child: _Pitch(gameState: gameState, notifier: notifier),
                            ),
                            if (gameState.gameState == MissingXiGameState.won ||
                                gameState.gameState == MissingXiGameState.lost)
                              _GameOverOverlay(
                                won: gameState.gameState ==
                                    MissingXiGameState.won,
                                progress: notifier.getProgressText(),
                                onReplay: notifier.resetGame,
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pitch extends StatelessWidget {
  final MissingXiState gameState;
  final MissingXiGameNotifier notifier;

  const _Pitch({required this.gameState, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF57B564), Color(0xFF3E9C4C)],
        ),
        borderRadius: BorderRadius.circular(ModernTheme.radiusLarge),
        boxShadow: ModernTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ModernTheme.radiusLarge),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const markerWidth = 64.0;
            const markerHeight = 76.0;
            const padding = 20.0;
            final usableWidth = constraints.maxWidth - 2 * padding - markerWidth;
            final usableHeight =
                constraints.maxHeight - 2 * padding - markerHeight;

            return Stack(
              children: [
                CustomPaint(
                  size: Size.infinite,
                  painter: _FieldPainter(),
                ),
                ...gameState.playerPositions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final position = entry.value;
                  final x = (position.x * usableWidth + padding)
                      .clamp(padding, constraints.maxWidth - markerWidth - padding);
                  final y = (position.y * usableHeight + padding)
                      .clamp(padding, constraints.maxHeight - markerHeight - padding);

                  return Positioned(
                    left: x,
                    top: y,
                    child: _PositionMarker(
                      position: position,
                      index: index,
                      isSelected: gameState.selectedPositionIndex == index,
                      onTap: () {
                        if (position.player != null) {
                          notifier.removePlayer(index);
                        } else {
                          notifier.selectPosition(index);
                        }
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PositionMarker extends StatelessWidget {
  final FormationPosition position;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _PositionMarker({
    required this.position,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPlayer = position.player != null;
    final Color color;
    if (hasPlayer) {
      color = ModernTheme.backgroundAccent;
    } else if (isSelected) {
      color = ModernTheme.accentPeach;
    } else {
      color = Colors.white.withValues(alpha: 0.85);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ModernTheme.fastDuration,
        curve: ModernTheme.snapCurve,
        width: 64,
        height: 76,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
          border: Border.all(
            color: isSelected ? ModernTheme.textPrimary : Colors.white,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: ModernTheme.softShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasPlayer
                  ? position.player!.name.split(' ').last.toUpperCase()
                  : position.position,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: ModernTheme.textPrimary,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            if (hasPlayer)
              Text(position.position,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  final bool won;
  final String progress;
  final VoidCallback onReplay;

  const _GameOverOverlay({
    required this.won,
    required this.progress,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.35),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(ModernTheme.spacing32),
            padding: const EdgeInsets.all(ModernTheme.spacing24),
            decoration: ModernTheme.glassCard(
              borderRadius: ModernTheme.radiusLarge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  won ? Icons.emoji_events_rounded : Icons.close_rounded,
                  size: 56,
                  color: won ? ModernTheme.successGreen : ModernTheme.errorRose,
                ),
                const SizedBox(height: ModernTheme.spacing16),
                Text(
                  won ? 'Formation Complete!' : 'Game Over',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ModernTheme.spacing8),
                Text('Filled: $progress',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: ModernTheme.spacing24),
                ElevatedButton.icon(
                  onPressed: onReplay,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('New Formation'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.09,
      paint,
    );

    final penaltyWidth = size.width * 0.4;
    final penaltyHeight = size.height * 0.16;
    canvas.drawRect(
      Rect.fromLTWH(
          (size.width - penaltyWidth) / 2, 0, penaltyWidth, penaltyHeight),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH((size.width - penaltyWidth) / 2, size.height - penaltyHeight,
          penaltyWidth, penaltyHeight),
      paint,
    );

    final goalWidth = size.width * 0.16;
    final goalHeight = size.height * 0.06;
    canvas.drawRect(
      Rect.fromLTWH((size.width - goalWidth) / 2, 0, goalWidth, goalHeight),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH((size.width - goalWidth) / 2, size.height - goalHeight,
          goalWidth, goalHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
