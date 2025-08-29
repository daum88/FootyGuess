import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../core/theme/retro_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('HomePage: Building homepage...');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              RetroTheme.backgroundDark,
              RetroTheme.primaryPurple,
              RetroTheme.backgroundDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with retro styling
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: RetroTheme.retroContainer(
                    color: RetroTheme.primaryPurple,
                    hasGradient: true,
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName.toUpperCase(),
                        style: RetroTheme.retroHeader.copyWith(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'FOOTBALL GUESSING GAMES',
                        style: RetroTheme.retroSubheader.copyWith(
                          color: RetroTheme.accentGreen,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Daily Games Section
                Text(
                  'TODAY\'S CHALLENGES',
                  style: RetroTheme.retroSubheader.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _RetroGameModeCard(
                        title: 'GUESS THE PLAYER',
                        subtitle: 'Wordle-style guessing',
                        mode: AppConstants.guessPlayerMode,
                        onTap: () => context.pushNamed('guess-player'),
                      ),
                      _RetroGameModeCard(
                        title: 'CAREER PATH',
                        subtitle: 'Club timeline reveal',
                        mode: AppConstants.careerPathMode,
                        onTap: () => context.pushNamed('career-path'),
                      ),
                      _RetroGameModeCard(
                        title: 'WHO SCORED?',
                        subtitle: 'Match moments quiz',
                        mode: AppConstants.whoScoredMode,
                        onTap: () => context.pushNamed('who-scored'),
                      ),
                      _RetroGameModeCard(
                        title: 'TENABLE',
                        subtitle: 'Football lists',
                        mode: AppConstants.tenableMode,
                        onTap: () => context.pushNamed('tenable'),
                      ),
                      _RetroGameModeCard(
                        title: 'MISSING XI',
                        subtitle: 'Formation puzzle',
                        mode: AppConstants.missingXiMode,
                        onTap: () => context.pushNamed('missing-xi'),
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RetroBottomNavButton(
                      icon: Icons.leaderboard,
                      label: 'LEADERBOARD',
                      onTap: () => context.pushNamed('leaderboard'),
                    ),
                    _RetroBottomNavButton(
                      icon: Icons.person,
                      label: 'PROFILE',
                      onTap: () => context.pushNamed('profile'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetroGameModeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String mode;
  final VoidCallback onTap;

  const _RetroGameModeCard({
    required this.title,
    required this.subtitle,
    required this.mode,
    required this.onTap,
  });

  @override
  State<_RetroGameModeCard> createState() => _RetroGameModeCardState();
}

class _RetroGameModeCardState extends State<_RetroGameModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: RetroAnimations.fastDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getGameModeColor(widget.mode);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: RetroTheme.retroContainer(
              color: RetroTheme.cardPurple,
              hasGradient: true,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) => _animationController.reverse(),
                onTapCancel: () => _animationController.reverse(),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getGameIcon(widget.mode),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: RetroTheme.retroSubheader.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: RetroTheme.retroBody.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getGameModeColor(String mode) {
    switch (mode) {
      case AppConstants.guessPlayerMode:
        return RetroTheme.accentGreen;
      case AppConstants.careerPathMode:
        return RetroTheme.neonBlue;
      case AppConstants.whoScoredMode:
        return RetroTheme.retroOrange;
      case AppConstants.tenableMode:
        return RetroTheme.accentGreen;
      case AppConstants.missingXiMode:
        return RetroTheme.neonBlue;
      default:
        return RetroTheme.accentGreen;
    }
  }

  IconData _getGameIcon(String mode) {
    switch (mode) {
      case AppConstants.guessPlayerMode:
        return Icons.sports_soccer;
      case AppConstants.careerPathMode:
        return Icons.timeline;
      case AppConstants.whoScoredMode:
        return Icons.quiz;
      case AppConstants.tenableMode:
        return Icons.list;
      case AppConstants.missingXiMode:
        return Icons.grid_3x3;
      default:
        return Icons.sports_soccer;
    }
  }
}

class _RetroBottomNavButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RetroBottomNavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_RetroBottomNavButton> createState() => _RetroBottomNavButtonState();
}

class _RetroBottomNavButtonState extends State<_RetroBottomNavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: RetroAnimations.fastDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: RetroTheme.retroContainer(
              color: RetroTheme.primaryPurple,
              hasGradient: true,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) => _animationController.reverse(),
                onTapCancel: () => _animationController.reverse(),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        color: RetroTheme.accentGreen,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.label,
                        style: RetroTheme.retroButton.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
