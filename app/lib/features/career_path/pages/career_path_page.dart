import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/career_path_provider.dart';

class CareerPathPage extends ConsumerStatefulWidget {
  const CareerPathPage({super.key});

  @override
  ConsumerState<CareerPathPage> createState() => _CareerPathPageState();
}

class _CareerPathPageState extends ConsumerState<CareerPathPage> {
  final TextEditingController _guessController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the game when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('CareerPathPage: Initializing game');
      ref.read(careerPathGameProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _guessController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _makeGuess(String playerName) {
    final state = ref.read(careerPathGameProvider);
    final selectedPlayer = state.filteredPlayers
        .where((p) => p.name.toLowerCase() == playerName.toLowerCase())
        .firstOrNull;

    if (selectedPlayer != null) {
      ref.read(careerPathGameProvider.notifier).makeGuess(selectedPlayer);
      _guessController.clear();
      _searchController.clear();
    }
  }

  void _resetGame() {
    ref.read(careerPathGameProvider.notifier).resetGame();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(careerPathGameProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF2D1B69), // Dark purple background
      appBar: AppBar(
        backgroundColor: const Color(0xFF4527A0),
        title: Text(
          'SENIOR CAREER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: gameState.gameState == CareerPathGameState.initial ||
              gameState.targetPlayer == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading career data...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(careerPathGameProvider.notifier).initialize();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Career table container
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFE3F2FD), // Light blue header
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Senior Career',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (gameState.gameState ==
                                    CareerPathGameState.won)
                                  Text(
                                    '✅ ${gameState.targetPlayer!.name}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                if (gameState.gameState ==
                                    CareerPathGameState.lost)
                                  Text(
                                    '❌ Answer: ${gameState.targetPlayer!.name}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),

                          // Column headers
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 20, // Smaller for mobile years
                                  child: Text(
                                    'Years',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12, // Smaller for mobile
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 60, // More space for team names
                                  child: Text(
                                    'Team',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12, // Smaller for mobile
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 20, // Smaller for type
                                  child: Text(
                                    'Type',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12, // Smaller for mobile
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Career data rows
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: gameState.targetPlayer!.clubs.length,
                              itemBuilder: (context, index) {
                                final club =
                                    gameState.targetPlayer!.clubs[index];
                                final isRevealed =
                                    index < gameState.revealedClubs.length ||
                                        gameState.gameState ==
                                            CareerPathGameState.won ||
                                        gameState.gameState ==
                                            CareerPathGameState.lost;

                                final yearStart = club.from.year;
                                final yearEnd = club.to?.year ?? 'Present';
                                final yearsText = '$yearStart-$yearEnd';

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isRevealed
                                        ? Colors.white
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 20, // Smaller for mobile years
                                        child: Text(
                                          isRevealed ? yearsText : '????-????',
                                          style: TextStyle(
                                            fontSize: 10, // Smaller for mobile
                                            color: isRevealed
                                                ? Colors.black
                                                : Colors.grey.shade600,
                                            fontWeight: isRevealed
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 60, // More space for team names
                                        child: Text(
                                          isRevealed ? club.clubId : '????',
                                          style: TextStyle(
                                            fontSize: 10, // Smaller for mobile
                                            color: isRevealed
                                                ? Colors.black
                                                : Colors.grey.shade600,
                                            fontWeight: isRevealed
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20, // Smaller for type
                                        child: Text(
                                          isRevealed
                                              ? (club.isLoan ? 'Loan' : 'Full')
                                              : '???',
                                          style: TextStyle(
                                            fontSize: 10, // Smaller for mobile
                                            color: isRevealed
                                                ? (club.isLoan
                                                    ? Colors.orange
                                                    : Colors.black)
                                                : Colors.grey.shade600,
                                            fontWeight: isRevealed
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Game controls section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4527A0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Game status and controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Clue reveal button
                            if (gameState.gameState ==
                                CareerPathGameState.playing)
                              ElevatedButton(
                                onPressed: gameState.currentClue <
                                        gameState.targetPlayer!.clubs.length
                                    ? () => ref
                                        .read(careerPathGameProvider.notifier)
                                        .revealNextClue()
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  'Reveal Clue',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                            // Game status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Attempts: ${gameState.attemptsRemaining}/6',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Reveal Answer and Reset buttons
                            Row(
                              children: [
                                // Reveal Answer button
                                if (gameState.gameState ==
                                    CareerPathGameState.playing)
                                  ElevatedButton(
                                    onPressed: () => ref
                                        .read(careerPathGameProvider.notifier)
                                        .revealAnswer(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      'Reveal Answer',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),

                                const SizedBox(width: 8),

                                // Reset button
                                ElevatedButton(
                                  onPressed: _resetGame,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: Text(
                                    'New Game',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Player search and guess
                        if (gameState.gameState ==
                            CareerPathGameState.playing) ...[
                          // Search field
                          TextField(
                            controller: _searchController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search for player...',
                              hintStyle: TextStyle(color: Colors.white60),
                              filled: true,
                              fillColor: const Color(0xFF2D1B69),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (query) {
                              ref
                                  .read(careerPathGameProvider.notifier)
                                  .searchPlayers(query);
                            },
                          ),

                          const SizedBox(height: 8),

                          // Player suggestions
                          if (gameState.searchQuery.isNotEmpty)
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D1B69),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                itemCount:
                                    gameState.filteredPlayers.take(5).length,
                                itemBuilder: (context, index) {
                                  final player =
                                      gameState.filteredPlayers[index];
                                  return ListTile(
                                    title: Text(
                                      player.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      '${player.nationality} • ${player.primaryPosition}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    onTap: () => _makeGuess(player.name),
                                  );
                                },
                              ),
                            ),
                        ],

                        // Previous guesses
                        if (gameState.guesses.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Previous Guesses:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...gameState.guesses.map((guess) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '❌ ${guess.name}',
                                  style: TextStyle(color: Colors.red.shade300),
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
