import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/retro_theme.dart';
import '../../../data/models/player.dart';
import '../providers/who_scored_provider.dart';

class WhoScoredPage extends ConsumerStatefulWidget {
  const WhoScoredPage({super.key});

  @override
  ConsumerState<WhoScoredPage> createState() => _WhoScoredPageState();
}

class _WhoScoredPageState extends ConsumerState<WhoScoredPage> {
  final TextEditingController _homeScoreController = TextEditingController();
  final TextEditingController _awayScoreController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(whoScoredGameProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(whoScoredGameProvider);
    final gameNotifier = ref.read(whoScoredGameProvider.notifier);

    if (gameState.gameState == WhoScoredGameState.initial) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: RetroTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: RetroTheme.backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'WHO SCORED?',
          style: RetroTheme.retroHeader.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: gameNotifier.resetGame,
          ),
        ],
      ),
      body: gameState.currentMatch == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMatchHeader(gameState.currentMatch!),
                  const SizedBox(height: 24),
                  _buildScoreSection(gameState, gameNotifier),
                  if (gameState.gameState == WhoScoredGameState.scoreGuessing ||
                      gameState.gameState == WhoScoredGameState.completed) ...[
                    const SizedBox(height: 24),
                    _buildScorersSection(gameState, gameNotifier),
                  ],
                  if (gameState.gameState == WhoScoredGameState.completed) ...[
                    const SizedBox(height: 24),
                    _buildResultsSection(gameState, gameNotifier),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildMatchHeader(MatchData match) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D2E47), Color(0xFF1F2038)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            match.competition,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            match.date,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      match.homeTeamBadge,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.homeTeam,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      match.awayTeamBadge,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.awayTeam,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection(
      WhoScoredState gameState, WhoScoredGameNotifier gameNotifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E47),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_soccer, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Guess the Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      gameState.currentMatch!.homeTeam,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: gameState.scoreRevealed
                            ? (gameState.userHomeScore ==
                                    gameState.currentMatch!.homeScore.toString()
                                ? Colors.green.withValues(alpha: 0.3)
                                : Colors.red.withValues(alpha: 0.3))
                            : const Color(0xFF3A3B5C),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: gameState.scoreRevealed
                          ? Center(
                              child: Text(
                                gameState.currentMatch!.homeScore.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : TextField(
                              controller: _homeScoreController,
                              enabled: !gameState.scoreRevealed,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '?',
                                hintStyle: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 32,
                                ),
                              ),
                              onChanged: gameNotifier.updateHomeScore,
                            ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '-',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      gameState.currentMatch!.awayTeam,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: gameState.scoreRevealed
                            ? (gameState.userAwayScore ==
                                    gameState.currentMatch!.awayScore.toString()
                                ? Colors.green.withValues(alpha: 0.3)
                                : Colors.red.withValues(alpha: 0.3))
                            : const Color(0xFF3A3B5C),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: gameState.scoreRevealed
                          ? Center(
                              child: Text(
                                gameState.currentMatch!.awayScore.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : TextField(
                              controller: _awayScoreController,
                              enabled: !gameState.scoreRevealed,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '?',
                                hintStyle: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 32,
                                ),
                              ),
                              onChanged: gameNotifier.updateAwayScore,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!gameState.scoreRevealed) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: gameState.userHomeScore.isNotEmpty &&
                        gameState.userAwayScore.isNotEmpty
                    ? gameNotifier.submitScore
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Score',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScorersSection(
      WhoScoredState gameState, WhoScoredGameNotifier gameNotifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E47),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Guess the Scorers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User's scorer guesses
          if (gameState.userScorerGuesses.isNotEmpty) ...[
            const Text(
              'Your Guesses:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  gameState.userScorerGuesses.asMap().entries.map((entry) {
                final index = entry.key;
                final guess = entry.value;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: gameState.scorersRevealed
                        ? (gameState.currentMatch!.scorers.any((scorer) =>
                                scorer.name
                                    .toLowerCase()
                                    .contains(guess.toLowerCase()) ||
                                guess
                                    .toLowerCase()
                                    .contains(scorer.name.toLowerCase()))
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.red.withValues(alpha: 0.3))
                        : Colors.blue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        guess,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      if (!gameState.scorersRevealed) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => gameNotifier.removeScorerGuess(index),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Search for players to add
          if (!gameState.scorersRevealed) ...[
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a player...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF3A3B5C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: gameNotifier.searchPlayers,
            ),
            if (gameState.filteredPlayers.isNotEmpty &&
                gameState.searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3B5C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: gameState.filteredPlayers.take(5).length,
                  itemBuilder: (context, index) {
                    final player = gameState.filteredPlayers[index];
                    return ListTile(
                      title: Text(
                        player.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${player.nationality} • ${player.currentClub}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                      onTap: () {
                        gameNotifier.addScorerGuess(player.name);
                        _searchController.clear();
                      },
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: gameState.userScorerGuesses.isNotEmpty
                    ? gameNotifier.submitScorers
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Scorers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],

          // Show actual scorers when revealed
          if (gameState.scorersRevealed) ...[
            const SizedBox(height: 16),
            const Text(
              'Actual Scorers:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...gameState.currentMatch!.scorers.asMap().entries.map((entry) {
              final index = entry.key;
              final scorer = entry.value;
              final minute = gameState.currentMatch!.scoringMinutes[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3B5C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "$minute'",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        scorer.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsSection(
      WhoScoredState gameState, WhoScoredGameNotifier gameNotifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.3),
            Colors.blue.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events,
            size: 48,
            color: Colors.yellow,
          ),
          const SizedBox(height: 16),
          const Text(
            'Match Complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Points: ${gameState.totalPoints}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ${gameState.isScoreCorrect ? "Correct (+10 pts)" : "Incorrect"}',
            style: TextStyle(
              fontSize: 14,
              color: gameState.isScoreCorrect ? Colors.green : Colors.red,
            ),
          ),
          Text(
            'Scorers: ${gameState.correctScorers}/${gameState.currentMatch!.scorers.length} correct (+${gameState.correctScorers * 5} pts)',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: gameNotifier.resetGame,
            icon: const Icon(Icons.refresh),
            label: const Text('Play Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
