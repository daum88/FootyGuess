import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/career_path_provider.dart';
import '../../../core/theme/modern_theme.dart';
import '../../../data/models/game_data_models.dart';

class CareerPathPage extends ConsumerStatefulWidget {
  const CareerPathPage({super.key});

  @override
  ConsumerState<CareerPathPage> createState() => _CareerPathPageState();
}

class _CareerPathPageState extends ConsumerState<CareerPathPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(careerPathGameProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(careerPathGameProvider);
    final notifier = ref.read(careerPathGameProvider.notifier);

    final isLoading = gameState.gameState == CareerPathGameState.initial &&
        gameState.targetPlayer == null;
    final isOver = gameState.gameState == CareerPathGameState.won ||
        gameState.gameState == CareerPathGameState.lost;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFE5F1), Color(0xFFF8F9FA), Color(0xFFE5F1FF)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _Header(
                  title: 'Career Path',
                  subtitle: isOver
                      ? gameState.targetPlayer?.name ?? ''
                      : 'Follow the career journey',
                  onBack: () => context.pop(),
                  onNew: isLoading ? null : notifier.resetGame,
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.all(ModernTheme.spacing16),
                          child: Column(
                            children: [
                              _buildStatusRow(gameState),
                              const SizedBox(height: ModernTheme.spacing16),
                              Expanded(child: _buildCareerTable(gameState)),
                              const SizedBox(height: ModernTheme.spacing16),
                              if (isOver)
                                _buildGameOver(context, gameState, notifier)
                              else
                                _buildSearch(context, gameState, notifier),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(CareerPathState state) {
    return Row(
      children: [
        Expanded(
          child: _Pill(
            icon: Icons.psychology_rounded,
            label: 'Guesses left',
            value: '${state.attemptsRemaining}',
            gradient: ModernTheme.warmGradient,
          ),
        ),
        const SizedBox(width: ModernTheme.spacing12),
        Expanded(
          child: _Pill(
            icon: Icons.lightbulb_rounded,
            label: 'Clues revealed',
            value: '${state.revealedClubs.length}/${state.targetPlayer?.career.length ?? 0}',
            gradient: ModernTheme.coolGradient,
          ),
        ),
      ],
    );
  }

  Widget _buildCareerTable(CareerPathState state) {
    final career = state.targetPlayer?.career ?? const <CareerEntry>[];
    final showAll = state.gameState == CareerPathGameState.won ||
        state.gameState == CareerPathGameState.lost;

    return Container(
      decoration: ModernTheme.glassCard(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ModernTheme.spacing16,
              vertical: ModernTheme.spacing12,
            ),
            decoration: BoxDecoration(
              gradient: ModernTheme.softGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ModernTheme.radiusMedium),
                topRight: Radius.circular(ModernTheme.radiusMedium),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Years',
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                Expanded(
                  flex: 5,
                  child: Text('Club',
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Type',
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(ModernTheme.spacing12),
              itemCount: career.length,
              itemBuilder: (context, index) {
                final club = career[index];
                final revealed =
                    showAll || index < state.revealedClubs.length;
                return Container(
                  margin: const EdgeInsets.only(bottom: ModernTheme.spacing8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: ModernTheme.spacing12,
                    vertical: ModernTheme.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: revealed
                        ? ModernTheme.backgroundAccent
                        : ModernTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
                    border: Border.all(color: ModernTheme.glassBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          revealed
                              ? '${club.startYear ?? '?'}-${club.endYear?.toString() ?? 'Now'}'
                              : '????',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: revealed
                                    ? ModernTheme.textPrimary
                                    : ModernTheme.textTertiary,
                              ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          revealed ? club.club : '?????',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: revealed
                                    ? ModernTheme.textPrimary
                                    : ModernTheme.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          revealed
                              ? (club.isLoan ? 'Loan' : 'Full')
                              : '???',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: revealed && club.isLoan
                                    ? ModernTheme.textSecondary
                                    : ModernTheme.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context, CareerPathState state,
      CareerPathGameNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: ModernTheme.glassCard(
            borderRadius: ModernTheme.radiusPill,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: notifier.searchPlayers,
            decoration: InputDecoration(
              hintText: 'Guess the player...',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusPill),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: ModernTheme.spacing20,
                vertical: ModernTheme.spacing16,
              ),
            ),
          ),
        ),
        if (state.filteredPlayers.isNotEmpty &&
            state.searchQuery.isNotEmpty) ...[
          const SizedBox(height: ModernTheme.spacing8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: ModernTheme.glassCard(),
            child: ListView.builder(
              padding: const EdgeInsets.all(ModernTheme.spacing8),
              shrinkWrap: true,
              itemCount: state.filteredPlayers.take(8).length,
              itemBuilder: (context, index) {
                final player = state.filteredPlayers[index];
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
                    '${player.nationality} • ${player.primaryPosition}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    notifier.makeGuess(player);
                    _searchController.clear();
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGameOver(BuildContext context, CareerPathState state,
      CareerPathGameNotifier notifier) {
    final won = state.gameState == CareerPathGameState.won;
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassCard(),
      child: Column(
        children: [
          Text(
            won ? '🎉 Correct!' : '😔 The answer was ${state.targetPlayer?.name}',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ModernTheme.spacing16),
          ElevatedButton.icon(
            onPressed: notifier.resetGame,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Play Again'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback? onNew;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassGradient(
        colors: [ModernTheme.accentLavender, ModernTheme.accentSky],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: ModernTheme.backgroundAccent.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: ModernTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          if (onNew != null)
            TextButton.icon(
              onPressed: onNew,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('New'),
              style: TextButton.styleFrom(
                backgroundColor: ModernTheme.backgroundAccent.withValues(alpha: 0.8),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final LinearGradient gradient;

  const _Pill({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing16),
      decoration: ModernTheme.glassCard(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ModernTheme.spacing8),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
            ),
            child: Icon(icon, size: 20, color: ModernTheme.textPrimary),
          ),
          const SizedBox(width: ModernTheme.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}
