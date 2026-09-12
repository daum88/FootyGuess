import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/game_data_providers.dart';
import '../../../core/utils/league_utils.dart';
import '../../../core/theme/modern_theme.dart';
import '../../../data/models/game_data_models.dart';

class GuessPlayerPageModern extends ConsumerStatefulWidget {
  const GuessPlayerPageModern({super.key});

  @override
  ConsumerState<GuessPlayerPageModern> createState() =>
      _GuessPlayerPageModernState();
}

class _GuessPlayerPageModernState extends ConsumerState<GuessPlayerPageModern>
    with SingleTickerProviderStateMixin {
  final List<_GuessRow> _guesses = [];
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  List<GamePlayer> _filteredPlayers = [];
  List<GamePlayer> _allPlayers = [];
  int _attemptsRemaining = 6;
  GamePlayer? _targetPlayer;
  bool _isLoading = true;
  String _loadingError = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ModernTheme.mediumDuration,
    );
    _loadPlayersAndInitializeGame();
  }

  Future<void> _loadPlayersAndInitializeGame() async {
    try {
      setState(() {
        _isLoading = true;
        _loadingError = '';
      });

      final players = await ref.read(guessablePlayersProvider.future);
      if (players.isEmpty) {
        throw Exception('No players available');
      }

      final target = players[DateTime.now().millisecondsSinceEpoch % players.length];

      if (mounted) {
        setState(() {
          _allPlayers = players;
          _filteredPlayers = List.from(players);
          _targetPlayer = target;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingError = 'Failed to load players: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _makeGuess(GamePlayer player) {
    if (_attemptsRemaining <= 0) return;
    final target = _targetPlayer;
    if (target == null) return;

    setState(() {
      _guesses.add(_GuessRow.from(player, target));
      _attemptsRemaining--;
      _searchController.clear();
      _filteredPlayers = List.from(_allPlayers);
    });

    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _filterPlayers(String query) {
    if (query.isEmpty) {
      setState(() => _filteredPlayers = List.from(_allPlayers));
    } else {
      final lower = query.toLowerCase();
      setState(() {
        _filteredPlayers = _allPlayers
            .where((p) => p.name.toLowerCase().contains(lower))
            .take(10)
            .toList();
      });
    }
  }

  void _resetGame() {
    setState(() {
      _guesses.clear();
      _attemptsRemaining = 6;
      _searchController.clear();
      _filteredPlayers = List.from(_allPlayers);
    });
    _loadPlayersAndInitializeGame();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoadingState();
    if (_loadingError.isNotEmpty) return _buildErrorState();

    final isGameOver = _attemptsRemaining <= 0 ||
        (_guesses.isNotEmpty && _guesses.last.isCorrect);
    final hasWon = _guesses.isNotEmpty && _guesses.last.isCorrect;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE5F1FF),
                    Color(0xFFF8F9FA),
                    Color(0xFFFFE5F1),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isGameOver, hasWon),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(ModernTheme.spacing16),
                    child: Column(
                      children: [
                        _buildStatsRow(isGameOver),
                        const SizedBox(height: ModernTheme.spacing20),
                        Expanded(child: _buildGuessesTable()),
                        const SizedBox(height: ModernTheme.spacing16),
                        if (!isGameOver) _buildSearchSection(),
                        if (isGameOver) _buildGameOverActions(hasWon),
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

  Widget _buildHeader(BuildContext context, bool isGameOver, bool hasWon) {
    final target = _targetPlayer!;
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassGradient(
        colors: [ModernTheme.accentLavender, ModernTheme.accentSky],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
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
                Text(
                  'Guess the Player',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (isGameOver)
                  Text(
                    hasWon ? '🎉 You won!' : '😔 ${target.name}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
          if (!isGameOver)
            TextButton.icon(
              onPressed: _resetGame,
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

  Widget _buildStatsRow(bool isGameOver) {
    final target = _targetPlayer!;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Attempts Left',
            value: '$_attemptsRemaining',
            icon: Icons.psychology_rounded,
            gradient: ModernTheme.warmGradient,
          ),
        ),
        const SizedBox(width: ModernTheme.spacing12),
        Expanded(
          child: _StatCard(
            label: 'Guesses Made',
            value: '${_guesses.length}',
            icon: Icons.list_alt_rounded,
            gradient: ModernTheme.coolGradient,
          ),
        ),
        const SizedBox(width: ModernTheme.spacing12),
        Expanded(
          child: _StatCard(
            label: 'Mystery Player',
            value: isGameOver ? target.name.split(' ').first : '?',
            icon: Icons.help_outline_rounded,
            gradient: ModernTheme.freshGradient,
          ),
        ),
      ],
    );
  }

  Widget _buildGuessesTable() {
    if (_guesses.isEmpty) {
      return Container(
        decoration: ModernTheme.glassCard(),
        padding: const EdgeInsets.all(ModernTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(ModernTheme.spacing20),
              decoration: BoxDecoration(
                gradient: ModernTheme.coolGradient,
                shape: BoxShape.circle,
                boxShadow: ModernTheme.softShadow,
              ),
              child: const Icon(
                Icons.sports_soccer_rounded,
                size: 48,
                color: ModernTheme.textPrimary,
              ),
            ),
            const SizedBox(height: ModernTheme.spacing24),
            Text(
              'Ready to Start?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: ModernTheme.spacing8),
            Text(
              'Search for a player below to make your first guess!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: ModernTheme.glassCard(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ModernTheme.spacing16),
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
                  flex: 3,
                  child: Text('Player', style: Theme.of(context).textTheme.labelLarge),
                ),
                Expanded(
                  child: Text('Nat.', style: Theme.of(context).textTheme.labelLarge),
                ),
                Expanded(
                  child: Text('Club', style: Theme.of(context).textTheme.labelLarge),
                ),
                Expanded(
                  child: Text('Age', style: Theme.of(context).textTheme.labelLarge),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(ModernTheme.spacing12),
              itemCount: _guesses.length,
              itemBuilder: (context, index) => _buildGuessRow(_guesses[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuessRow(_GuessRow guess) {
    final isCorrect = guess.isCorrect;
    return Container(
      margin: const EdgeInsets.only(bottom: ModernTheme.spacing8),
      padding: const EdgeInsets.all(ModernTheme.spacing12),
      decoration: BoxDecoration(
        gradient: isCorrect
            ? const LinearGradient(
                colors: [ModernTheme.successGreen, Color(0xFFD4F5E9)],
              )
            : null,
        color: isCorrect ? null : ModernTheme.backgroundAccent,
        borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
        border: Border.all(
          color: isCorrect ? ModernTheme.successGreen : ModernTheme.glassBorder,
          width: isCorrect ? 2 : 1,
        ),
        boxShadow: isCorrect ? ModernTheme.softShadow : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              guess.player.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isCorrect
                        ? const Color(0xFF2E7D5E)
                        : ModernTheme.textPrimary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: _buildMatchIndicator(
              LeagueUtils.getCountryFlag(guess.player.nationality),
              guess.nationalityMatch,
            ),
          ),
          Expanded(
            child: _buildMatchIndicator(
              guess.player.currentClub.isEmpty
                  ? '—'
                  : guess.player.currentClub.substring(0, 3).toUpperCase(),
              guess.clubMatch,
              isText: true,
            ),
          ),
          Expanded(
            child: _buildMatchIndicator(
              '${guess.player.age ?? '?'}${guess.ageDirection}',
              guess.ageMatch,
              isText: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchIndicator(String value, bool isMatch, {bool isText = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ModernTheme.spacing8,
        vertical: ModernTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: isMatch ? ModernTheme.successGreen : ModernTheme.errorRose,
        borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ModernTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: ModernTheme.glassCard(
            borderRadius: ModernTheme.radiusPill,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterPlayers,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search for a player...',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusPill),
                borderSide: BorderSide.none,
              ),
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: ModernTheme.spacing20,
                vertical: ModernTheme.spacing16,
              ),
            ),
          ),
        ),
        if (_searchController.text.isNotEmpty && _filteredPlayers.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: ModernTheme.spacing8),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: ModernTheme.glassCard(),
            child: ListView.builder(
              padding: const EdgeInsets.all(ModernTheme.spacing8),
              shrinkWrap: true,
              itemCount: _filteredPlayers.length,
              itemBuilder: (context, index) =>
                  _buildPlayerSearchItem(_filteredPlayers[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildPlayerSearchItem(GamePlayer player) {
    return Container(
      margin: const EdgeInsets.only(bottom: ModernTheme.spacing4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _makeGuess(player),
          borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
          child: Container(
            padding: const EdgeInsets.all(ModernTheme.spacing12),
            decoration: BoxDecoration(
              color: ModernTheme.backgroundAccent,
              borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
              border: Border.all(color: ModernTheme.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: ModernTheme.coolGradient,
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      player.name
                          .split(' ')
                          .map((part) => part.isNotEmpty ? part[0] : '')
                          .take(2)
                          .join(''),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(width: ModernTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        '${LeagueUtils.getCountryFlag(player.nationality)} ${player.currentClub} • ${player.age ?? '?'}',
                        style: Theme.of(context).textTheme.bodySmall,
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
  }

  Widget _buildGameOverActions(bool hasWon) {
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing20),
      decoration: ModernTheme.glassCard(),
      child: Column(
        children: [
          Text(
            hasWon
                ? '🎉 Amazing! You guessed it!'
                : '😔 Better luck next time!',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ModernTheme.spacing16),
          ElevatedButton.icon(
            onPressed: _resetGame,
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

  Widget _buildLoadingState() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE5F1FF), Color(0xFFF8F9FA)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(ModernTheme.spacing24),
                decoration: BoxDecoration(
                  color: ModernTheme.backgroundAccent,
                  shape: BoxShape.circle,
                  boxShadow: ModernTheme.softShadow,
                ),
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(height: ModernTheme.spacing24),
              Text(
                'Loading players...',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE5F1), Color(0xFFF8F9FA)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(ModernTheme.spacing32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(ModernTheme.spacing24),
                  decoration: BoxDecoration(
                    color: ModernTheme.errorRose,
                    shape: BoxShape.circle,
                    boxShadow: ModernTheme.softShadow,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: ModernTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: ModernTheme.spacing24),
                Text('Oops!', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: ModernTheme.spacing8),
                Text(
                  _loadingError,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ModernTheme.spacing24),
                ElevatedButton.icon(
                  onPressed: _loadPlayersAndInitializeGame,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuessRow {
  final GamePlayer player;
  final bool isCorrect;
  final bool nationalityMatch;
  final bool clubMatch;
  final bool leagueMatch;
  final bool positionMatch;
  final bool ageMatch;
  final String ageDirection;

  const _GuessRow({
    required this.player,
    required this.isCorrect,
    required this.nationalityMatch,
    required this.clubMatch,
    required this.leagueMatch,
    required this.positionMatch,
    required this.ageMatch,
    required this.ageDirection,
  });

  factory _GuessRow.from(GamePlayer player, GamePlayer target) {
    final ageDirection = (player.age ?? 0) > (target.age ?? 0)
        ? '↓'
        : (player.age ?? 0) < (target.age ?? 0)
            ? '↑'
            : '✓';
    return _GuessRow(
      player: player,
      isCorrect: player.name == target.name,
      nationalityMatch: player.nationality == target.nationality,
      clubMatch: player.currentClub == target.currentClub,
      leagueMatch: player.currentLeague == target.currentLeague,
      positionMatch: player.primaryPosition == target.primaryPosition,
      ageMatch: player.age == target.age,
      ageDirection: ageDirection,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ModernTheme.spacing16),
      decoration: ModernTheme.glassCard(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ModernTheme.spacing8),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
            ),
            child: Icon(icon, size: 24, color: ModernTheme.textPrimary),
          ),
          const SizedBox(height: ModernTheme.spacing8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
