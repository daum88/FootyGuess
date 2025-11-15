import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/tenable_provider_new.dart';
import '../../../core/theme/retro_theme.dart';

class TenablePageNew extends ConsumerStatefulWidget {
  const TenablePageNew({super.key});

  @override
  ConsumerState<TenablePageNew> createState() => _TenablePageNewState();
}

class _TenablePageNewState extends ConsumerState<TenablePageNew>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bounceController = RetroAnimations.createBounceController(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tenableGameNewProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(tenableGameNewProvider);
    final notifier = ref.read(tenableGameNewProvider.notifier);

    // Unfocus search when game is not in playing state
    if (gameState.gameStatus != GameStatus.playing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.unfocus();
      });
    }

    return Scaffold(
      backgroundColor: RetroTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: RetroTheme.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black54,
        title: Text(
          'TENABLE NEW',
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
      body: gameState.currentCategory == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    // Lives display
                    _buildLivesDisplay(gameState),

                    // Category title
                    _buildCategoryHeader(gameState),

                    // Found answers pyramid
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildFoundAnswers(gameState, notifier),
                      ),
                    ),

                    // Search bar at bottom
                    if (gameState.gameStatus == GameStatus.playing)
                      _buildSearchSection(gameState, notifier),
                  ],
                ),

                // Game over overlay
                if (gameState.gameStatus != GameStatus.playing)
                  _buildGameOverOverlay(gameState, notifier),
              ],
            ),
    );
  }

  Widget _buildLivesDisplay(TenableGameState gameState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: RetroTheme.retroContainer(
        color: RetroTheme.primaryPurple,
        hasGradient: true,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: RetroAnimations.normalDuration,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < gameState.livesRemaining
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: RetroTheme.heartRed,
              size: 32,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryHeader(TenableGameState gameState) {
    final category = gameState.currentCategory!;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: RetroTheme.retroContainer(
        color: RetroTheme.primaryPurple,
        hasGradient: true,
      ),
      child: Column(
        children: [
          Text(
            category.question.toUpperCase(),
            style: RetroTheme.retroHeader.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            category.description,
            style: RetroTheme.retroBody.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Found: ${gameState.foundAnswers.length}/${category.answers.length}',
            style: RetroTheme.retroBody.copyWith(
              color: Colors.white54,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFoundAnswers(
      TenableGameState gameState, TenableGameNotifier notifier) {
    final foundAnswersWithValues = notifier.getFoundAnswersWithValues();
    final totalAnswers = gameState.currentCategory?.answers.length ?? 10;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            gameState.currentCategory?.question ?? 'TENABLE PYRAMID',
            style: RetroTheme.retroSubheader.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildPyramidStructure(
              foundAnswersWithValues, totalAnswers, notifier, gameState),
        ],
      ),
    );
  }

  Widget _buildPyramidStructure(
      List<TenableCsvAnswer> foundAnswers,
      int totalAnswers,
      TenableGameNotifier notifier,
      TenableGameState gameState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalAnswers, (index) {
        final position = index + 1;
        final foundAnswer = foundAnswers
            .firstWhereOrNull((answer) => answer.position == position);
        final isFound = foundAnswer != null;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          width: 280 - (index * 8), // Pyramid shape - narrower at top
          height: 32, // Reduced height to prevent overflow
          child: Container(
            decoration: RetroTheme.retroContainer(
              color: isFound
                  ? RetroTheme.accentGreen
                  : RetroTheme.primaryPurple.withValues(alpha: 0.3),
              hasGradient: isFound,
            ),
            child: Center(
              child: isFound
                  ? _buildFoundAnswerContent(foundAnswer, notifier, gameState)
                  : _buildEmptySlot(position),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFoundAnswerContent(TenableCsvAnswer answer,
      TenableGameNotifier notifier, TenableGameState gameState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            '${answer.position}.',
            style: RetroTheme.retroBody.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              answer.answer,
              style: RetroTheme.retroBody.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '(${answer.value})',
            style: RetroTheme.retroBody.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlot(int position) {
    return Text(
      '$position.',
      style: RetroTheme.retroBody.copyWith(
        color: Colors.white.withValues(alpha: 0.5),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildSearchSection(
      TenableGameState gameState, TenableGameNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: RetroTheme.retroContainer(
        color: RetroTheme.cardPurple,
        hasBorder: false,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search input
          Container(
            decoration: RetroTheme.retroContainer(
              color: RetroTheme.backgroundDark,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: RetroTheme.retroBody.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search answers...',
                hintStyle: RetroTheme.retroBody.copyWith(
                  color: Colors.white54,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: RetroTheme.accentGreen,
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                notifier.search(value);
              },
              onSubmitted: (value) {
                if (gameState.filteredSuggestions.isNotEmpty) {
                  notifier.makeGuess(gameState.filteredSuggestions.first);
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                } else if (value.trim().isNotEmpty) {
                  // Allow direct submission of typed answer
                  notifier.makeGuess(value.trim());
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                }
              },
            ),
          ),

          // Show filtered suggestions
          if (gameState.filteredSuggestions.isNotEmpty &&
              gameState.searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 120,
              decoration: RetroTheme.retroContainer(
                color: RetroTheme.backgroundDark,
              ),
              child: ListView.builder(
                itemCount: gameState.filteredSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = gameState.filteredSuggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      suggestion,
                      style: RetroTheme.retroBody.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Football entity',
                      style: RetroTheme.retroBody.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: RetroTheme.accentGreen,
                      radius: 16,
                      child: Text(
                        suggestion.isNotEmpty
                            ? suggestion.substring(0, 1).toUpperCase()
                            : '?',
                        style: RetroTheme.retroBody.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    onTap: () {
                      notifier.makeGuess(suggestion);
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(
      TenableGameState gameState, TenableGameNotifier notifier) {
    final isWon = gameState.gameStatus == GameStatus.won;
    final allAnswers = notifier.getAllAnswerEntities();
    final missedAnswers = allAnswers
        .where((answer) => !gameState.foundAnswers
            .any((found) => found.answer.toLowerCase() == answer.toLowerCase()))
        .toList();

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
                isWon ? 'CATEGORY COMPLETE!' : 'GAME OVER',
                style: RetroTheme.retroHeader.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Found ${gameState.foundAnswers.length} out of ${gameState.currentCategory!.answers.length} answers',
                style: RetroTheme.retroBody.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isWon && missedAnswers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Some answers you missed:\n${missedAnswers.take(3).join(', ')}',
                    style: RetroTheme.retroBody.copyWith(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                  'NEW CATEGORY',
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
