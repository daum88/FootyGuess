import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/game_data_providers.dart';
import '../../../core/theme/modern_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(gameDataProvider);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE5F1FF), Color(0xFFF8F9FA), Color(0xFFFFE5F1)],
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
                      Text('Profile',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ModernTheme.spacing20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(ModernTheme.spacing24),
                          decoration:
                              ModernTheme.glassCard(borderRadius: ModernTheme.radiusLarge),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: ModernTheme.coolGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: ModernTheme.softShadow,
                                ),
                                child: const Icon(Icons.person_rounded,
                                    size: 40, color: ModernTheme.textPrimary),
                              ),
                              const SizedBox(height: ModernTheme.spacing16),
                              Text('Football Fan',
                                  style: Theme.of(context).textTheme.headlineMedium),
                              const SizedBox(height: ModernTheme.spacing4),
                              Text('Daily streak coming soon',
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        const SizedBox(height: ModernTheme.spacing20),
                        data.when(
                          data: (service) => _StatsGrid(
                            players: service.players.length,
                            matches: service.matches.length,
                            lineups: service.lineups.length,
                            clubs: service.clubs.length,
                          ),
                          loading: () => const Center(
                              child: Padding(
                            padding: EdgeInsets.all(ModernTheme.spacing32),
                            child: CircularProgressIndicator(),
                          )),
                          error: (e, _) => Text('$e',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
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
}

class _StatsGrid extends StatelessWidget {
  final int players;
  final int matches;
  final int lineups;
  final int clubs;

  const _StatsGrid({
    required this.players,
    required this.matches,
    required this.lineups,
    required this.clubs,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Players', players, ModernTheme.coolGradient, Icons.group_rounded),
      ('Matches', matches, ModernTheme.warmGradient, Icons.sports_soccer_rounded),
      ('Lineups', lineups, ModernTheme.freshGradient, Icons.grid_on_rounded),
      ('Clubs', clubs, ModernTheme.softGradient, Icons.shield_rounded),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: ModernTheme.spacing16,
      crossAxisSpacing: ModernTheme.spacing16,
      childAspectRatio: 1.3,
      children: stats.map((s) {
        return Container(
          padding: const EdgeInsets.all(ModernTheme.spacing16),
          decoration: ModernTheme.glassCard(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(ModernTheme.spacing8),
                decoration: BoxDecoration(
                  gradient: s.$3,
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
                ),
                child: Icon(s.$4, size: 24, color: ModernTheme.textPrimary),
              ),
              const SizedBox(height: ModernTheme.spacing8),
              Text(s.$2.toString(),
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(s.$1, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }
}
