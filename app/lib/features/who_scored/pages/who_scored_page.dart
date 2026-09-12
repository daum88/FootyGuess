import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/who_scored_provider.dart';
import '../../../core/theme/modern_theme.dart';

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
    final state = ref.watch(whoScoredGameProvider);
    final notifier = ref.read(whoScoredGameProvider.notifier);

    if (state.gameState == WhoScoredGameState.initial ||
        state.currentMatch == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE5F1FF), Color(0xFFF8F9FA)],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final match = state.currentMatch!;

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
                  title: 'Who Scored?',
                  subtitle: '${match.competition} • ${match.date}',
                  onBack: () => context.pop(),
                  onNew: notifier.resetGame,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ModernTheme.spacing16),
                    child: Column(
                      children: [
                        _MatchCard(match: match),
                        const SizedBox(height: ModernTheme.spacing20),
                        if (state.gameState == WhoScoredGameState.playing)
                          _buildScoreSection(state, notifier),
                        if (state.gameState == WhoScoredGameState.scoreGuessing ||
                            state.gameState == WhoScoredGameState.completed) ...[
                          _buildScorersSection(state, notifier),
                        ],
                        if (state.gameState == WhoScoredGameState.completed)
                          _buildResults(state, notifier),
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

  Widget _buildScoreSection(WhoScoredState state, WhoScoredGameNotifier notifier) {
    final match = state.currentMatch!;
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ModernTheme.spacing8),
                decoration: BoxDecoration(
                  gradient: ModernTheme.coolGradient,
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
                ),
                child: const Icon(Icons.sports_soccer_rounded,
                    size: 20, color: ModernTheme.textPrimary),
              ),
              const SizedBox(width: ModernTheme.spacing8),
              Text('Guess the Score',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: ModernTheme.spacing20),
          Row(
            children: [
              Expanded(
                child: _ScoreInput(
                  label: match.homeTeam,
                  controller: _homeScoreController,
                  onChanged: notifier.updateHomeScore,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: ModernTheme.spacing12),
                child: Text('-',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: ModernTheme.textSecondary)),
              ),
              Expanded(
                child: _ScoreInput(
                  label: match.awayTeam,
                  controller: _awayScoreController,
                  onChanged: notifier.updateAwayScore,
                ),
              ),
            ],
          ),
          const SizedBox(height: ModernTheme.spacing20),
          ElevatedButton.icon(
            onPressed: state.userHomeScore.isNotEmpty &&
                    state.userAwayScore.isNotEmpty
                ? notifier.submitScore
                : null,
            icon: const Icon(Icons.check_rounded),
            label: const Text('Submit Score'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScorersSection(
      WhoScoredState state, WhoScoredGameNotifier notifier) {
    final match = state.currentMatch!;
    return Container(
      margin: const EdgeInsets.only(top: ModernTheme.spacing20),
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ModernTheme.spacing8),
                decoration: BoxDecoration(
                  gradient: ModernTheme.warmGradient,
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
                ),
                child: const Icon(Icons.person_rounded,
                    size: 20, color: ModernTheme.textPrimary),
              ),
              const SizedBox(width: ModernTheme.spacing8),
              Text('Guess the Scorers',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          if (state.scoreRevealed) ...[
            const SizedBox(height: ModernTheme.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultChip(
                  text: state.isScoreCorrect ? 'Score ✓' : 'Score ✗',
                  correct: state.isScoreCorrect,
                ),
              ],
            ),
          ],
          const SizedBox(height: ModernTheme.spacing16),

          // Guesses
          if (state.userScorerGuesses.isNotEmpty) ...[
            Wrap(
              spacing: ModernTheme.spacing8,
              runSpacing: ModernTheme.spacing8,
              children: state.userScorerGuesses.asMap().entries.map((entry) {
                final guess = entry.value;
                final isCorrect = state.scorersRevealed &&
                    match.match.scorers.any((s) =>
                        s.player.toLowerCase().contains(guess.toLowerCase()) ||
                        guess.toLowerCase().contains(s.player.toLowerCase()));
                return Chip(
                  label: Text(guess),
                  onDeleted: state.scorersRevealed
                      ? null
                      : () => notifier.removeScorerGuess(entry.key),
                  deleteIcon: state.scorersRevealed
                      ? null
                      : const Icon(Icons.close_rounded, size: 16),
                  backgroundColor: state.scorersRevealed
                      ? (isCorrect
                          ? ModernTheme.successGreen
                          : ModernTheme.errorRose)
                      : ModernTheme.accentSky,
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: ModernTheme.spacing16),
          ],

          if (!state.scorersRevealed) ...[
            Container(
              decoration: ModernTheme.glassCard(
                borderRadius: ModernTheme.radiusPill,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: notifier.searchPlayers,
                decoration: InputDecoration(
                  hintText: 'Search a player...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ModernTheme.radiusPill),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: ModernTheme.spacing20,
                    vertical: ModernTheme.spacing12,
                  ),
                ),
              ),
            ),
            if (state.filteredPlayers.isNotEmpty &&
                state.searchQuery.isNotEmpty) ...[
              const SizedBox(height: ModernTheme.spacing8),
              Container(
                constraints: const BoxConstraints(maxHeight: 160),
                decoration: ModernTheme.glassCard(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(ModernTheme.spacing8),
                  shrinkWrap: true,
                  itemCount: state.filteredPlayers.take(6).length,
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
                      subtitle: Text(player.currentClub,
                          style: Theme.of(context).textTheme.bodySmall),
                      onTap: () {
                        notifier.addScorerGuess(player.name);
                        _searchController.clear();
                      },
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: ModernTheme.spacing16),
            ElevatedButton.icon(
              onPressed: state.userScorerGuesses.isNotEmpty
                  ? notifier.submitScorers
                  : null,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Submit Scorers'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
          ],

          if (state.scorersRevealed) ...[
            const SizedBox(height: ModernTheme.spacing12),
            Text('Actual Scorers',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: ModernTheme.spacing8),
            ...match.scoringMinutes.asMap().entries.map((entry) {
              final scorer = match.scorers[entry.key];
              return Container(
                margin: const EdgeInsets.only(bottom: ModernTheme.spacing8),
                padding: const EdgeInsets.all(ModernTheme.spacing12),
                decoration: BoxDecoration(
                  color: ModernTheme.backgroundAccent,
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
                  border: Border.all(color: ModernTheme.glassBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: ModernTheme.spacing8,
                          vertical: ModernTheme.spacing4),
                      decoration: BoxDecoration(
                        gradient: ModernTheme.warmGradient,
                        borderRadius:
                            BorderRadius.circular(ModernTheme.radiusSmall),
                      ),
                      child: Text("${entry.value}'",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    const SizedBox(width: ModernTheme.spacing12),
                    Expanded(
                      child: Text(scorer.name,
                          style: Theme.of(context).textTheme.labelLarge),
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

  Widget _buildResults(WhoScoredState state, WhoScoredGameNotifier notifier) {
    final match = state.currentMatch!;
    return Container(
      margin: const EdgeInsets.only(top: ModernTheme.spacing20),
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassGradient(
        colors: [ModernTheme.accentMint, ModernTheme.accentSky],
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_rounded,
              size: 48, color: ModernTheme.textPrimary),
          const SizedBox(height: ModernTheme.spacing12),
          Text('Match Complete!',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: ModernTheme.spacing8),
          Text('Total Points: ${state.totalPoints}',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: ModernTheme.spacing8),
          Text(
            'Score ${state.isScoreCorrect ? '+10' : '0'} • '
            'Scorers ${state.correctScorers}/${match.match.scorers.length} '
            '(+${state.correctScorers * 5})',
            style: Theme.of(context).textTheme.bodyMedium,
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

class _MatchCard extends StatelessWidget {
  final MatchData match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing24),
      decoration: ModernTheme.glassCard(borderRadius: ModernTheme.radiusLarge),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(match.homeTeamBadge,
                        style: const TextStyle(fontSize: 44)),
                    const SizedBox(height: ModernTheme.spacing8),
                    Text(match.homeTeam,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ModernTheme.spacing16),
                child: Text('VS',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ModernTheme.textTertiary)),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(match.awayTeamBadge,
                        style: const TextStyle(fontSize: 44)),
                    const SizedBox(height: ModernTheme.spacing8),
                    Text(match.awayTeam,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _ScoreInput({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: ModernTheme.spacing8),
        Container(
          width: 72,
          height: 72,
          decoration: ModernTheme.glassCard(borderRadius: ModernTheme.radiusMedium),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: ModernTheme.textPrimary),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '?',
              hintStyle: TextStyle(fontSize: 32, color: ModernTheme.textTertiary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultChip extends StatelessWidget {
  final String text;
  final bool correct;

  const _ResultChip({required this.text, required this.correct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: ModernTheme.spacing16, vertical: ModernTheme.spacing8),
      decoration: BoxDecoration(
        color: correct ? ModernTheme.successGreen : ModernTheme.errorRose,
        borderRadius: BorderRadius.circular(ModernTheme.radiusPill),
      ),
      child: Text(text,
          style: Theme.of(context).textTheme.labelLarge,
          textAlign: TextAlign.center),
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
        colors: [ModernTheme.accentSky, ModernTheme.accentLavender],
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
