import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/game_data_providers.dart';
import '../../../core/theme/modern_theme.dart';
import '../../../data/models/game_data_models.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);

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
                Container(
                  padding: const EdgeInsets.all(ModernTheme.spacing20),
                  decoration: ModernTheme.glassGradient(
                    colors: [ModernTheme.accentPeach, ModernTheme.accentRose],
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
                            Text('Leaderboard',
                                style: Theme.of(context).textTheme.headlineMedium),
                            Text('Most appearances',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: players.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                        child: Text('$e',
                            style: Theme.of(context).textTheme.bodyMedium)),
                    data: (all) => _LeaderboardList(
                      players: _topByAppearances(all),
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

  List<GamePlayer> _topByAppearances(List<GamePlayer> players) {
    final list = players.where((p) => p.appearances > 0).toList()
      ..sort((a, b) => b.appearances.compareTo(a.appearances));
    return list.take(50).toList();
  }
}

class _LeaderboardList extends StatelessWidget {
  final List<GamePlayer> players;

  const _LeaderboardList({required this.players});

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return Center(
          child: Text('No data yet',
              style: Theme.of(context).textTheme.bodyMedium));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(ModernTheme.spacing16),
      itemCount: players.length,
      separatorBuilder: (_, __) => const SizedBox(height: ModernTheme.spacing8),
      itemBuilder: (context, index) {
        final player = players[index];
        final rank = index + 1;
        final medal = _medalColor(rank);
        final medalIcon = _medalIcon(rank);

        return Container(
          padding: const EdgeInsets.all(ModernTheme.spacing12),
          decoration: ModernTheme.glassCard(),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: rank <= 3
                    ? Icon(medalIcon, color: medal, size: 28)
                    : Text('$rank',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: ModernTheme.textTertiary),
                        textAlign: TextAlign.center),
              ),
              const SizedBox(width: ModernTheme.spacing12),
              CircleAvatar(
                backgroundColor: ModernTheme.accentLavender,
                child: Text(
                  player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: ModernTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(player.name,
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(player.currentClub,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text('${player.appearances} apps',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: ModernTheme.textSecondary)),
            ],
          ),
        );
      },
    );
  }

  Color _medalColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFC400); // gold
      case 2:
        return const Color(0xFFB0BEC5); // silver
      case 3:
        return const Color(0xFFBC8A5F); // bronze
      default:
        return ModernTheme.textTertiary;
    }
  }

  IconData _medalIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.workspace_premium_rounded;
      case 2:
        return Icons.workspace_premium_rounded;
      case 3:
        return Icons.workspace_premium_rounded;
      default:
        return Icons.circle;
    }
  }
}
