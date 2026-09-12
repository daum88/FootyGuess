import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/modern_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // Soft gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFE5F1), // Soft pink
                  Color(0xFFF8F9FA), // Light gray
                  Color(0xFFE5F1FF), // Soft blue
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: _buildHeader(context),
                ),
                
                // Game modes
                SliverPadding(
                  padding: const EdgeInsets.all(ModernTheme.spacing20),
                  sliver: SliverGrid(
                    delegate: SliverChildListDelegate([
                      _GameModeCard(
                        title: 'Guess the Player',
                        description: 'Who is this mystery player?',
                        gradient: ModernTheme.coolGradient,
                        icon: Icons.search_rounded,
                        onTap: () => context.pushNamed('guess-player'),
                      ),
                      _GameModeCard(
                        title: 'Career Path',
                        description: 'Follow their journey',
                        gradient: ModernTheme.warmGradient,
                        icon: Icons.timeline_rounded,
                        onTap: () => context.pushNamed('career-path'),
                      ),
                      _GameModeCard(
                        title: 'Who Scored?',
                        description: 'Memorable match moments',
                        gradient: ModernTheme.freshGradient,
                        icon: Icons.star_rounded,
                        onTap: () => context.pushNamed('who-scored'),
                      ),
                      _GameModeCard(
                        title: 'Tenable',
                        description: 'Complete the list',
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ModernTheme.accentRose,
                            ModernTheme.accentPeach,
                          ],
                        ),
                        icon: Icons.format_list_bulleted_rounded,
                        onTap: () => context.pushNamed('tenable'),
                      ),
                      _GameModeCard(
                        title: 'Missing XI',
                        description: 'Complete the lineup',
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ModernTheme.accentSky,
                            ModernTheme.accentMint,
                          ],
                        ),
                        icon: Icons.sports_soccer_rounded,
                        onTap: () => context.pushNamed('missing-xi'),
                      ),
                    ]),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: ModernTheme.spacing16,
                      crossAxisSpacing: ModernTheme.spacing16,
                      childAspectRatio: 0.85,
                    ),
                  ),
                ),
                
                // Bottom navigation
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      ModernTheme.spacing20,
                      ModernTheme.spacing32,
                      ModernTheme.spacing20,
                      ModernTheme.spacing20,
                    ),
                    child: _buildBottomNav(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Title
          Container(
            padding: const EdgeInsets.all(ModernTheme.spacing24),
            decoration: ModernTheme.glassCard(
              borderRadius: ModernTheme.radiusLarge,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: ModernTheme.coolGradient,
                        borderRadius: BorderRadius.circular(ModernTheme.radiusMedium),
                        boxShadow: ModernTheme.softShadow,
                      ),
                      child: const Icon(
                        Icons.sports_soccer_rounded,
                        color: ModernTheme.textPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: ModernTheme.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FootyGuess',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: ModernTheme.spacing4),
                          Text(
                            'Test your football knowledge',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: ModernTheme.spacing24),
          
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ModernTheme.spacing8),
            child: Text(
              'Choose Your Game',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: ModernTheme.glassCard(
        borderRadius: ModernTheme.radiusPill,
      ),
      padding: const EdgeInsets.all(ModernTheme.spacing8),
      child: Row(
        children: [
          Expanded(
            child: _NavButton(
              icon: Icons.leaderboard_rounded,
              label: 'Leaderboard',
              onTap: () => context.pushNamed('leaderboard'),
            ),
          ),
          const SizedBox(width: ModernTheme.spacing8),
          Expanded(
            child: _NavButton(
              icon: Icons.person_rounded,
              label: 'Profile',
              onTap: () => context.pushNamed('profile'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameModeCard extends StatefulWidget {
  final String title;
  final String description;
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _GameModeCard({
    required this.title,
    required this.description,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GameModeCard> createState() => _GameModeCardState();
}

class _GameModeCardState extends State<_GameModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ModernTheme.fastDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: ModernTheme.snapCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              widget.onTap();
            },
            onTapCancel: () => _controller.reverse(),
            child: Container(
              decoration: ModernTheme.glassFloating(
                borderRadius: ModernTheme.radiusLarge,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ModernTheme.radiusLarge),
                child: Stack(
                  children: [
                    // Gradient background
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: widget.gradient,
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(ModernTheme.spacing20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: ModernTheme.backgroundAccent.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(ModernTheme.radiusMedium),
                              boxShadow: ModernTheme.softShadow,
                            ),
                            child: Icon(
                              widget.icon,
                              color: ModernTheme.textPrimary,
                              size: 28,
                            ),
                          ),
                          
                          // Text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: ModernTheme.spacing4),
                              Text(
                                widget.description,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ModernTheme.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: ModernTheme.fastDuration,
        curve: ModernTheme.snapCurve,
        padding: const EdgeInsets.symmetric(
          vertical: ModernTheme.spacing16,
        ),
        decoration: BoxDecoration(
          gradient: _isPressed ? ModernTheme.coolGradient : null,
          color: _isPressed ? null : ModernTheme.glassOverlay,
          borderRadius: BorderRadius.circular(ModernTheme.radiusPill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: ModernTheme.textPrimary,
              size: 20,
            ),
            const SizedBox(width: ModernTheme.spacing8),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
