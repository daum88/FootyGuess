// Example: How to update any game provider to use OptimizedDataService
// This is a documentation file showing before/after patterns

/*
// BEFORE (slow loading):
class GameProvider extends StateNotifier<GameState> {
  Future<void> initialize() async {
    // Slow: loads data from scratch every time
    final players = await CsvPlayerService.loadPlayers();
    final lineups = await CsvLineupService.loadLineups();

    // Game initialization...
    state = state.copyWith(players: players);
  }
}

// AFTER (fast loading with caching):
class OptimizedGameProvider extends StateNotifier<GameState> {
  final Ref _ref;

  OptimizedGameProvider(this._ref) : super(GameState());

  Future<void> initialize() async {
    print('🚀 Fast initialization starting...');
    final stopwatch = Stopwatch()..start();

    // Fast: uses cached data from OptimizedDataService
    final dataService = _ref.read(optimizedDataServiceProvider);
    final players = await dataService.getPlayers();
    final lineups = await dataService.getLineups();

    stopwatch.stop();
    print(
        '🚀 Loaded ${players.length} players in ${stopwatch.elapsedMilliseconds}ms');

    // Game initialization...
    state = state.copyWith(players: players);
  }
}

// Provider definition:
final optimizedGameProvider =
    StateNotifierProvider<OptimizedGameProvider, GameState>((ref) {
  return OptimizedGameProvider(ref);
});

// Usage in pages:
class GamePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Data preloading happens in background via main.dart
    final gameState = ref.watch(optimizedGameProvider);

    // Initialize game (will be fast due to cached data)
    ref.read(optimizedGameProvider.notifier).initialize();

    return Scaffold(
        // Your game UI...
        );
  }
}
*/
