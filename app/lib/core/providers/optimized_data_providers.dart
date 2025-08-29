import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/optimized_data_service.dart';
import '../../data/models/player.dart';

/// Provider for the optimized data service singleton
final optimizedDataServiceProvider = Provider<OptimizedDataService>((ref) {
  return OptimizedDataService();
});

/// Provider for efficiently loading all players with caching
final optimizedPlayersProvider = FutureProvider<List<Player>>((ref) async {
  final dataService = ref.read(optimizedDataServiceProvider);
  return await dataService.getPlayers();
});

/// Provider for efficiently loading lineup data with caching
final optimizedLineupsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dataService = ref.read(optimizedDataServiceProvider);
  return await dataService.getLineups();
});

/// Provider for efficiently loading tenable data with caching
final optimizedTenableDataProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dataService = ref.read(optimizedDataServiceProvider);
  return await dataService.getTenableData();
});

/// Provider for efficiently loading football database with caching
final optimizedFootballDatabaseProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final dataService = ref.read(optimizedDataServiceProvider);
  return await dataService.getFootballDatabase();
});

/// Provider to preload all data in the background
final dataPreloadProvider = FutureProvider<bool>((ref) async {
  final dataService = ref.read(optimizedDataServiceProvider);
  await dataService.preloadAllData();
  return true;
});
