import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/game_data_models.dart';
import '../../data/services/game_data_service.dart';

/// Singleton data service.
final gameDataServiceProvider = Provider<GameDataService>((ref) {
  return GameDataService();
});

/// Loads all canonical data once and exposes typed getters.
final gameDataProvider = FutureProvider<GameDataService>((ref) async {
  final service = ref.read(gameDataServiceProvider);
  await service.load();
  return service;
});

final playersProvider = FutureProvider<List<GamePlayer>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.players;
});

final guessablePlayersProvider = FutureProvider<List<GamePlayer>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.guessablePlayers;
});

final careerPlayersProvider = FutureProvider<List<GamePlayer>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.careerPlayers;
});

final matchesProvider = FutureProvider<List<GameMatch>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.matches;
});

final scoredMatchesProvider = FutureProvider<List<GameMatch>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.scoredMatches;
});

final lineupsProvider = FutureProvider<List<TeamLineup>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.lineups;
});

final clubsProvider = FutureProvider<List<GameClub>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.clubs;
});

final tenableProvider = FutureProvider<List<TenableCategory>>((ref) async {
  final service = await ref.watch(gameDataProvider.future);
  return service.tenable;
});
