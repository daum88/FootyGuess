import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/csv_player_service.dart';
import '../../../core/utils/league_utils.dart';

class GuessPlayerPage extends ConsumerStatefulWidget {
  const GuessPlayerPage({super.key});

  @override
  ConsumerState<GuessPlayerPage> createState() => _GuessPlayerPageState();
}

class _GuessPlayerPageState extends ConsumerState<GuessPlayerPage> {
  final List<Map<String, dynamic>> _guesses = [];
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredPlayers = [];
  List<Map<String, dynamic>> _allPlayers = [];
  int _attemptsRemaining = 6;
  Map<String, dynamic> _targetPlayer = {};
  bool _isLoading = true;
  String _loadingError = '';

  @override
  void initState() {
    super.initState();
    _loadPlayersAndInitializeGame();
  }

  Future<void> _loadPlayersAndInitializeGame() async {
    try {
      setState(() {
        _isLoading = true;
        _loadingError = '';
      });

      final players = await CsvPlayerService.loadPlayers();
      final targetPlayer = await CsvPlayerService.getRandomPlayer();

      setState(() {
        _allPlayers = players;
        _filteredPlayers = List.from(players);
        _targetPlayer = targetPlayer;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _loadingError = 'Failed to load players: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _makeGuess(Map<String, dynamic> player) {
    if (_attemptsRemaining <= 0) return;

    setState(() {
      _guesses.add({
        'name': player['name'],
        'nationality': player['nationality'],
        'club': player['club'],
        'league': player['league'],
        'position': player['position'],
        'age': player['age'],
        'isCorrect': player['name'] == _targetPlayer['name'],
        'nationalityMatch':
            player['nationality'] == _targetPlayer['nationality'],
        'clubMatch': player['club'] == _targetPlayer['club'],
        'leagueMatch': player['league'] == _targetPlayer['league'],
        'positionMatch': player['position'] == _targetPlayer['position'],
        'ageMatch': player['age'] == _targetPlayer['age'],
        'ageDirection': player['age'] > _targetPlayer['age']
            ? '↓'
            : player['age'] < _targetPlayer['age']
                ? '↑'
                : '=',
      });
      _attemptsRemaining--;
      _searchController.clear();
      _filteredPlayers = List.from(_allPlayers);
    });
  }

  void _filterPlayers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredPlayers = List.from(_allPlayers);
      });
    } else {
      try {
        final searchResults = await CsvPlayerService.searchPlayers(query);
        setState(() {
          _filteredPlayers = searchResults;
        });
      } catch (e) {
        setState(() {
          _filteredPlayers = _allPlayers
              .where((player) =>
                  player['name']
                      ?.toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false)
              .take(10)
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF2D1B69),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4527A0),
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'GUESS THE PLAYER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Loading players...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Show error state
    if (_loadingError.isNotEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF2D1B69),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4527A0),
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'GUESS THE PLAYER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                _loadingError,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPlayersAndInitializeGame,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2D1B69),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4527A0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'GUESS THE PLAYER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            // Compact header section
            _buildMobileHeader(),
            const SizedBox(height: 6),

            // Mobile layout - vertical stacking
            Expanded(
              child: Column(
                children: [
                  // Guess results table (top) - more space
                  Expanded(
                    flex: 3,
                    child: _buildMobileGuessTable(),
                  ),
                  const SizedBox(height: 6),

                  // Search section (bottom) - compact
                  SizedBox(
                    height: 140,
                    child: _buildMobileSearchSection(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    final bool isGameOver = _attemptsRemaining <= 0 ||
        (_guesses.isNotEmpty && _guesses.last['isCorrect']);
    final bool hasWon = _guesses.isNotEmpty && _guesses.last['isCorrect'];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF4527A0),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Game result or mystery player
          if (isGameOver)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: hasWon ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasWon ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hasWon
                          ? '🎉 Correct! ${_targetPlayer['name']}'
                          : '💀 Answer: ${_targetPlayer['name']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

          // Stats row - mobile optimized
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMobileStatCard(
                'MYSTERY',
                isGameOver ? _targetPlayer['name'].split(' ').first : '?',
                Icons.help_outline,
                Colors.yellow,
              ),
              _buildMobileStatCard(
                'LEFT',
                '$_attemptsRemaining',
                Icons.psychology,
                Colors.yellow,
              ),
              _buildMobileStatCard(
                'MADE',
                '${_guesses.length}',
                Icons.list_alt,
                Colors.yellow,
              ),
            ],
          ),

          // Action buttons - more compact for mobile
          if (_attemptsRemaining > 0 && !hasWon)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _attemptsRemaining = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(
                      'Reveal',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _guesses.clear();
                        _attemptsRemaining = 6;
                        _searchController.clear();
                        _filteredPlayers = List.from(_allPlayers);
                      });
                      _loadPlayersAndInitializeGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(
                      'New Game',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

          // New game button for game over state
          if (isGameOver)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _guesses.clear();
                    _attemptsRemaining = 6;
                    _searchController.clear();
                    _filteredPlayers = List.from(_allPlayers);
                  });
                  _loadPlayersAndInitializeGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B69),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(height: 1),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileGuessTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header - mobile optimized
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFFBBDEFB),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Guess Results',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_guesses.length} guess${_guesses.length != 1 ? 'es' : ''} made',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Mobile table content
          Expanded(
            child: _guesses.isEmpty
                ? _buildMobileEmptyState()
                : Column(
                    children: [
                      // Column headers - mobile optimized
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 35, // More space for player name
                              child: _buildMobileColumnHeader('PLAYER'),
                            ),
                            Expanded(
                              flex: 10, // Just for flag
                              child: _buildMobileColumnHeader('NAT'),
                            ),
                            Expanded(
                              flex: 30, // Good space for club
                              child: _buildMobileColumnHeader('CLUB'),
                            ),
                            Expanded(
                              flex: 15, // League abbreviation
                              child: _buildMobileColumnHeader('LEA'),
                            ),
                            Expanded(
                              flex: 10, // Position abbreviation
                              child: _buildMobileColumnHeader('AGE'),
                            ),
                          ],
                        ),
                      ),

                      // Guess rows
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: _guesses
                                .map((guess) => _buildMobileGuessRow(guess))
                                .toList(),
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

  Widget _buildMobileColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMobileGuessRow(Map<String, dynamic> guess) {
    final isCorrect = guess['isCorrect'];

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isCorrect ? Colors.green.shade300 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Player name - more space
          Expanded(
            flex: 35,
            child: _buildMobileAttributeCell(
              guess['name'],
              guess['isCorrect'],
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Country with flag only
          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                LeagueUtils.getCountryFlag(guess['nationality']),
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Club - good space
          Expanded(
            flex: 30,
            child: _buildMobileAttributeCell(
              guess['club'],
              guess['clubMatch'],
              fontSize: 8,
            ),
          ),

          // League abbreviation
          Expanded(
            flex: 15,
            child: _buildMobileAttributeCell(
              LeagueUtils.getLeagueAbbreviation(guess['league'] ?? ''),
              guess['leagueMatch'] ?? false,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Age with direction - compact
          Expanded(
            flex: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${guess['age']}',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: guess['ageMatch']
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${guess['ageDirection']}',
                  style: TextStyle(
                    fontSize: 10,
                    color: guess['ageMatch']
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAttributeCell(String value, bool isMatch,
      {double fontSize = 8, FontWeight fontWeight = FontWeight.w500}) {
    final color = isMatch ? Colors.green.shade700 : Colors.red.shade700;
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        value,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildMobileEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.sports_soccer,
                size: 32,
                color: Colors.blue.shade400,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ready to Start?',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Search for players below to make your first guess!',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSearchSection() {
    final bool isGameOver = _attemptsRemaining <= 0 ||
        (_guesses.isNotEmpty && _guesses.last['isCorrect']);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isGameOver ? Colors.grey.shade600 : const Color(0xFF4527A0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Search header - mobile
          Text(
            isGameOver ? 'GAME OVER' : 'SEARCH PLAYERS',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          if (!isGameOver) ...[
            const SizedBox(height: 4),

            // Search input - mobile optimized
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D1B69),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterPlayers,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Player name...',
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 12),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: 18,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Search results - mobile
            Expanded(
              child: _filteredPlayers.isEmpty
                  ? _buildMobileNoResults()
                  : ListView.builder(
                      itemCount: _filteredPlayers.length,
                      itemBuilder: (context, index) {
                        return _buildMobilePlayerCard(_filteredPlayers[index]);
                      },
                    ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            const Icon(
              Icons.games,
              size: 32,
              color: Colors.white54,
            ),
            const SizedBox(height: 4),
            const Text(
              'Game Finished!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileNoResults() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 24,
            color: Colors.white54,
          ),
          SizedBox(height: 6),
          Text(
            'NO PLAYERS FOUND',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePlayerCard(Map<String, dynamic> player) {
    final bool isGameOver = _attemptsRemaining <= 0 ||
        (_guesses.isNotEmpty && _guesses.last['isCorrect']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isGameOver ? null : () => _makeGuess(player),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isGameOver ? Colors.grey.shade300 : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isGameOver
                    ? Colors.grey.shade400
                    : const Color(0xFF4527A0).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Player avatar - very small for mobile
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    gradient: isGameOver
                        ? null
                        : const LinearGradient(
                            colors: [
                              Color(0xFF4527A0),
                              Color(0xFF2D1B69),
                            ],
                          ),
                    color: isGameOver ? Colors.grey.shade500 : null,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      player['name']
                          .split(' ')
                          .map((part) => part.isNotEmpty ? part[0] : '')
                          .take(2)
                          .join(''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                // Player details - mobile compact
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player['name'],
                        style: TextStyle(
                          color: isGameOver
                              ? Colors.grey.shade600
                              : Colors.black87,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            LeagueUtils.getCountryFlag(player['nationality']),
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            LeagueUtils.getLeagueFlag(player['league'] ?? ''),
                            style: const TextStyle(fontSize: 8),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              '${player['club']} • ${LeagueUtils.getLeagueAbbreviation(player['league'] ?? '')}',
                              style: TextStyle(
                                color: isGameOver
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade600,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
  }
}
