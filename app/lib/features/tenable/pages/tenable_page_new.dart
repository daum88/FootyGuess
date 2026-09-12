import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/tenable_provider_new.dart';
import '../../../core/theme/modern_theme.dart';

class TenablePageNew extends ConsumerStatefulWidget {
  const TenablePageNew({super.key});

  @override
  ConsumerState<TenablePageNew> createState() => _TenablePageNewState();
}

class _TenablePageNewState extends ConsumerState<TenablePageNew> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tenableGameNewProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(tenableGameNewProvider);
    final notifier = ref.read(tenableGameNewProvider.notifier);

    final isOver = gameState.gameStatus != GameStatus.playing &&
        gameState.gameStatus != GameStatus.loading;

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
                _Header(
                  title: 'Tenable',
                  subtitle: 'Complete the list',
                  onBack: () => context.pop(),
                  onNew: notifier.resetGame,
                ),
                Expanded(
                  child: gameState.currentCategory == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            _LivesRow(lives: gameState.livesRemaining),
                            _CategoryCard(category: gameState.currentCategory!),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: ModernTheme.spacing16),
                                child: _Pyramid(
                                  found: notifier.getFoundAnswersWithValues(),
                                  total: gameState.currentCategory!.answers.length,
                                ),
                              ),
                            ),
                            if (gameState.gameStatus == GameStatus.playing)
                              _SearchBar(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                suggestions: gameState.filteredSuggestions,
                                showSuggestions: gameState.searchQuery.isNotEmpty,
                                onChanged: notifier.search,
                                onSubmitted: (value) {
                                  if (gameState.filteredSuggestions.isNotEmpty) {
                                    notifier.makeGuess(
                                        gameState.filteredSuggestions.first);
                                  } else if (value.trim().isNotEmpty) {
                                    notifier.makeGuess(value.trim());
                                  }
                                  _searchController.clear();
                                },
                                onSuggestionTap: (s) {
                                  notifier.makeGuess(s);
                                  _searchController.clear();
                                  _searchFocusNode.unfocus();
                                },
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          if (isOver)
            _GameOverOverlay(
              won: gameState.gameStatus == GameStatus.won,
              found: gameState.foundAnswers.length,
              total: gameState.currentCategory?.answers.length ?? 10,
              missed: notifier
                  .getAllAnswerEntities()
                  .where((a) => !gameState.foundAnswers
                      .any((f) => f.answer.toLowerCase() == a.toLowerCase()))
                  .toList(),
              onReplay: notifier.resetGame,
            ),
        ],
      ),
    );
  }
}

class _LivesRow extends StatelessWidget {
  final int lives;

  const _LivesRow({required this.lives});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          ModernTheme.spacing16, ModernTheme.spacing12, ModernTheme.spacing16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: ModernTheme.spacing4),
            child: Icon(
              i < lives ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: i < lives
                  ? ModernTheme.errorRose
                  : ModernTheme.textTertiary,
              size: 28,
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final TenableCsvCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ModernTheme.spacing16),
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassCard(borderRadius: ModernTheme.radiusLarge),
      child: Column(
        children: [
          Text(category.question,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: ModernTheme.spacing8),
          Text(category.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Pyramid extends StatelessWidget {
  final List<TenableCsvAnswer> found;
  final int total;

  const _Pyramid({required this.found, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final position = index + 1;
        final answer = found.firstWhereOrNull((a) => a.position == position);
        final isFound = answer != null;
        final width = 300.0 - (index * 14);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          width: width,
          height: 40,
          decoration: BoxDecoration(
            gradient: isFound ? ModernTheme.freshGradient : null,
            color: isFound ? null : ModernTheme.glassSurface,
            borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
            border: Border.all(color: ModernTheme.glassBorder),
          ),
          child: Center(
            child: isFound
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${answer.position}.',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(width: ModernTheme.spacing8),
                      Flexible(
                        child: Text(
                          answer.answer,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: ModernTheme.spacing8),
                      Text('(${answer.value})',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  )
                : Text('$position.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: ModernTheme.textTertiary)),
          ),
        );
      }),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> suggestions;
  final bool showSuggestions;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onSuggestionTap;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.showSuggestions,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing16),
      decoration: BoxDecoration(
        color: ModernTheme.glassSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(ModernTheme.radiusLarge),
          topRight: Radius.circular(ModernTheme.radiusLarge),
        ),
        border: Border.all(color: ModernTheme.glassBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: 'Search answers...',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusPill),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: ModernTheme.backgroundAccent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: ModernTheme.spacing20,
                vertical: ModernTheme.spacing12,
              ),
            ),
          ),
          if (showSuggestions && suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: ModernTheme.spacing8),
              constraints: const BoxConstraints(maxHeight: 140),
              decoration: ModernTheme.glassCard(),
              child: ListView.builder(
                padding: const EdgeInsets.all(ModernTheme.spacing8),
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final s = suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ModernTheme.accentMint,
                      child: Text(
                        s.isNotEmpty ? s[0].toUpperCase() : '?',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    title: Text(s, style: Theme.of(context).textTheme.labelLarge),
                    onTap: () => onSuggestionTap(s),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  final bool won;
  final int found;
  final int total;
  final List<String> missed;
  final VoidCallback onReplay;

  const _GameOverOverlay({
    required this.won,
    required this.found,
    required this.total,
    required this.missed,
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
                  won ? 'Category Complete!' : 'Game Over',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ModernTheme.spacing8),
                Text(
                  'Found $found out of $total answers',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (!won && missed.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: ModernTheme.spacing12),
                    child: Text(
                      'Some you missed:\n${missed.take(3).join(', ')}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: ModernTheme.spacing24),
                ElevatedButton.icon(
                  onPressed: onReplay,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('New Category'),
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

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onNew;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassGradient(
        colors: [ModernTheme.accentRose, ModernTheme.accentPeach],
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
