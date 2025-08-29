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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

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
      backgroundColor: const Color(0xFF2D1B69), // Match career path background
      appBar: AppBar(
        backgroundColor: const Color(0xFF4527A0), // Match career path app bar
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
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
      body: Padding(
        padding: const EdgeInsets.all(
            8), // Much smaller padding for full screen usage
        child: Column(
          children: [
            // Compact header section
            _buildCompactHeader(),

            const SizedBox(height: 8), // Reduced spacing

            // Main game area - responsive layout with optimized space allocation
            Expanded(
              child: isWideScreen
                  ? Row(
                      children: [
                        // Guess results table (left side) - maximum space for better visibility
                        Expanded(
                          flex: 7, // Even more space for guess results
                          child: _buildCareerStyleGuessTable(),
                        ),

                        const SizedBox(width: 8), // Minimal spacing

                        // Search section (right side) - very compact
                        SizedBox(
                          width: 240, // Even smaller fixed width for search
                          child: _buildCareerStyleSearchSection(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        // Guess results table (top on mobile) - maximum space
                        Expanded(
                          flex: 4, // Even more space for results on mobile
                          child: _buildCareerStyleGuessTable(),
                        ),

                        const SizedBox(height: 8), // Reduced spacing

                        // Search section (bottom on mobile) - very compact
                        SizedBox(
                          height: 160, // Even smaller fixed height
                          child: _buildCareerStyleSearchSection(),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    final bool isGameOver = _attemptsRemaining <= 0 || (_guesses.isNotEmpty && _guesses.last['isCorrect']);
    final bool hasWon = _guesses.isNotEmpty && _guesses.last['isCorrect'];

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8), // Reduced padding
      decoration: BoxDecoration(
        color: const Color(0xFF4527A0), // Match career path purple
        borderRadius: BorderRadius.circular(8), // Smaller radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4, // Reduced shadow
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Game result or mystery player
          if (isGameOver)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: hasWon ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasWon ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasWon 
                          ? '🎉 Correct! ${_targetPlayer['name']}'
                          : '💀 Answer: ${_targetPlayer['name']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCompactStatCard(
                'MYSTERY PLAYER',
                isGameOver ? _targetPlayer['name'].split(' ').first : '?',
                Icons.help_outline,
                Colors.yellow, // Match career path yellow accents
              ),
              _buildCompactStatCard(
                'ATTEMPTS LEFT',
                '$_attemptsRemaining',
                Icons.psychology,
                Colors.yellow,
              ),
              _buildCompactStatCard(
                'GUESSES MADE',
                '${_guesses.length}',
                Icons.list_alt,
                Colors.yellow,
              ),
            ],
          ),

          // Action buttons
          if (_attemptsRemaining > 0 && !hasWon)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _attemptsRemaining = 0; // End the game
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                    ),
                    child: const Text(
                      'Reveal Answer',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        horizontal: 16,
                        vertical: 6,
                      ),
                    ),
                    child: const Text(
                      'New Game',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // New game button for game over state
          if (isGameOver)
            Padding(
              padding: const EdgeInsets.only(top: 8),
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
                    horizontal: 20,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 6, vertical: 6), // More compact padding
        margin: const EdgeInsets.symmetric(horizontal: 2), // Reduced margin
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B69), // Match career path dark purple
          borderRadius: BorderRadius.circular(6), // Smaller radius
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16), // Smaller icon
            const SizedBox(height: 2), // Less spacing
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 9, // Smaller font
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1), // Minimal spacing
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14, // Smaller value font
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerStyleGuessTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Match career path white background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table header - match career path style
          // Header - Enhanced for full screen
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFE3F2FD),
                  const Color(0xFFBBDEFB),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Guess Results',
                  style: TextStyle(
                    color: const Color(0xFF1565C0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${_guesses.length} guess${_guesses.length != 1 ? 'es' : ''} made',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Horizontal scrollable guess rows
          Expanded(
            child: _guesses.isEmpty
                ? _buildCareerStyleEmptyState()
                : Column(
                    children: [
                      // Column headers - Properly aligned
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 30, // More space for player name on mobile
                              child: _buildColumnHeader('PLAYER'),
                            ),
                            Expanded(
                              flex: 12, // Less space for country (just flag)
                              child: _buildColumnHeader('NAT'),
                            ),
                            Expanded(
                              flex: 28, // Good space for club
                              child: _buildColumnHeader('CLUB'),
                            ),
                            Expanded(
                              flex: 15, // Compact league abbreviation
                              child: _buildColumnHeader('LEA'),
                            ),
                            Expanded(
                              flex: 10, // Compact position
                              child: _buildColumnHeader('POS'),
                            ),
                            Expanded(
                              flex: 5, // Minimal age
                              child: _buildColumnHeader('AGE'),
                            ),
                          ],
                        ),
                      ),

                      // Full width guess rows
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: _guesses
                                .map((guess) => _buildFullWidthGuessRow(guess))
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

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildFullWidthGuessRow(Map<String, dynamic> guess) {
    final isCorrect = guess['isCorrect'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? Colors.green.shade300 : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Player name
          Expanded(
            flex: 30, // More space for player name on mobile
            child: _buildAttributeCell(
              guess['name'],
              guess['isCorrect'],
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Country with flag only (no text to avoid doubling)
          Expanded(
            flex: 12, // Less space for country (just flag)
            child: Container(
              alignment: Alignment.center,
              child: Text(
                LeagueUtils.getCountryFlag(guess['nationality']),
                style: TextStyle(fontSize: 18), // Slightly smaller flag for mobile
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Club
          Expanded(
            flex: 28, // Good space for club
            child: _buildAttributeCell(
              guess['club'],
              guess['clubMatch'],
              fontSize: 10, // Smaller font for mobile
            ),
          ),

          // League
          Expanded(
            flex: 15, // Compact league abbreviation
            child: _buildAttributeCell(
              LeagueUtils.getLeagueAbbreviation(guess['league'] ?? ''),
              guess['leagueMatch'] ?? false,
              fontSize: 10, // Smaller font for mobile
              fontWeight: FontWeight.w600,
            ),
          ),

          // Position
          Expanded(
            flex: 10, // Compact position
            child: _buildAttributeCell(
              guess['position'],
              guess['positionMatch'],
              fontSize: 9, // Even smaller for position
              fontWeight: FontWeight.w600,
            ),
          ),

          // Age with direction
          Expanded(
            flex: 5, // Minimal age
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${guess['age']}',
                  style: TextStyle(
                    fontSize: 10, // Smaller age font
                    fontWeight: FontWeight.bold,
                    color: guess['ageMatch'] ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${guess['ageDirection']}',
                  style: TextStyle(
                    fontSize: 12, // Slightly smaller arrow
                    color: guess['ageMatch'] ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
          ),

          // Position
          Expanded(
            flex: 10, // Compact position
            child: _buildAttributeCell(
              guess['position'],
              guess['positionMatch'],
              fontSize: 9, // Even smaller for position
              fontWeight: FontWeight.w600,
            ),
          ),

          // Age with direction
          Expanded(
            flex: 5, // Minimal age
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${guess['age']}',
                  style: TextStyle(
                    fontSize: 10, // Smaller age font
                    fontWeight: FontWeight.bold,
                    color: guess['ageMatch'] ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${guess['ageDirection']}',
                  style: TextStyle(
                    fontSize: 12, // Slightly smaller arrow
                    color: guess['ageMatch'] ? Colors.green.shade700 : Colors.red.shade700,
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

  Widget _buildAttributeCell(String value, bool isMatch,
      {double fontSize = 11, FontWeight fontWeight = FontWeight.w500}) {
    final color = isMatch ? Colors.green.shade700 : Colors.red.shade700;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        value,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildCareerStyleEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.sports_soccer,
                size: 64,
                color: Colors.blue.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ready to Start Guessing?',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Search for players below to make your first guess!\nEach guess will show how close you are to the mystery player.',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerStyleSearchSection() {
    final bool isGameOver = _attemptsRemaining <= 0 || (_guesses.isNotEmpty && _guesses.last['isCorrect']);

    return Container(
      padding: const EdgeInsets.all(6), // Even more compact padding
      decoration: BoxDecoration(
        color: isGameOver 
            ? Colors.grey.shade600 // Disabled color when game is over
            : const Color(0xFF4527A0), // Match career path purple
        borderRadius: BorderRadius.circular(8), // Smaller radius
      ),
      child: Column(
        children: [
          // Search header - much smaller
          Text(
            isGameOver ? 'GAME OVER' : 'SEARCH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10, // Much smaller font
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          if (!isGameOver) ...[
            const SizedBox(height: 6), // Minimal spacing

            // Search input - very compact
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D1B69), // Match career path dark purple
                borderRadius: BorderRadius.circular(6), // Smaller radius
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterPlayers,
                style: TextStyle(
                    color: Colors.white, fontSize: 11), // Even smaller font
                decoration: InputDecoration(
                  hintText: 'Player name...',
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 11),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.yellow, // Match career path yellow
                    size: 16, // Much smaller icon
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8), // Compact padding
                ),
              ),
            ),

            const SizedBox(height: 6), // Minimal spacing

            // Search results - more compact
            Expanded(
              child: _filteredPlayers.isEmpty
                  ? _buildCareerStyleNoResults()
                  : ListView.builder(
                      itemCount: _filteredPlayers.length,
                      itemBuilder: (context, index) {
                        return _buildCareerStylePlayerCard(
                            _filteredPlayers[index]);
                      },
                    ),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Icon(
              Icons.games,
              size: 48,
              color: Colors.white54,
            ),
            const SizedBox(height: 8),
            Text(
              'Game Finished!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCareerStyleNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.white54,
          ),
          const SizedBox(height: 12),
          Text(
            'NO PLAYERS FOUND',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerStylePlayerCard(Map<String, dynamic> player) {
    final bool isGameOver = _attemptsRemaining <= 0 || (_guesses.isNotEmpty && _guesses.last['isCorrect']);

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 6, vertical: 1), // Even more compact margins
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isGameOver ? null : () => _makeGuess(player), // Disable when game is over
          borderRadius: BorderRadius.circular(6), // Even smaller radius
          child: Container(
            padding: const EdgeInsets.all(4), // Very compact padding
            decoration: BoxDecoration(
              color: isGameOver ? Colors.grey.shade300 : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isGameOver 
                    ? Colors.grey.shade400
                    : const Color(0xFF4527A0).withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: isGameOver ? [] : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.05), // Minimal shadow
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Player avatar - very small
                Container(
                  width: 20, // Very small size
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: isGameOver ? null : LinearGradient(
                      colors: [
                        const Color(0xFF4527A0),
                        const Color(0xFF2D1B69),
                      ],
                    ),
                    color: isGameOver ? Colors.grey.shade500 : null,
                    borderRadius: BorderRadius.circular(10), // Smaller radius
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      player['name']
                          .split(' ')
                          .map((part) => part.isNotEmpty ? part[0] : '')
                          .take(2)
                          .join(''),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8, // Very small font
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6), // Minimal spacing

                // Player details with very compact layout
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player['name'],
                        style: TextStyle(
                          color: isGameOver ? Colors.grey.shade600 : Colors.black87,
                          fontSize: 11, // Even smaller font
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1), // Minimal spacing
                      Row(
                        children: [
                          Text(
                            LeagueUtils.getCountryFlag(player['nationality']),
                            style:
                                const TextStyle(fontSize: 12), // Smaller flags
                          ),
                          const SizedBox(width: 2), // Minimal spacing
                          Text(
                            LeagueUtils.getLeagueFlag(player['league'] ?? ''),
                            style:
                                const TextStyle(fontSize: 10), // Even smaller
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              '${player['club']} • ${LeagueUtils.getLeagueAbbreviation(player['league'] ?? '')}',
                              style: TextStyle(
                                color: isGameOver ? Colors.grey.shade500 : Colors.grey.shade600,
                                fontSize: 9, // Very small font
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
