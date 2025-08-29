import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/player.dart';
import '../services/career_stats_data_service.dart';

part 'data_repository.g.dart';

@Riverpod(keepAlive: true)
DataRepository dataRepository(DataRepositoryRef ref) {
  return DataRepository._();
}

class DataRepository {
  DataRepository._();

  List<Player>? _cachedPlayers;
  List<Club>? _cachedClubs;
  List<Match>? _cachedMatches;
  List<Player>? _cachedCareerStatsPlayers;

  final CareerStatsDataService _careerStatsService = CareerStatsDataService();

  Future<List<Player>> getPlayers() async {
    if (_cachedPlayers != null) return _cachedPlayers!;

    try {
      final String playersJson =
          await rootBundle.loadString('assets/data/players.json');
      final List<dynamic> playersData = json.decode(playersJson);

      _cachedPlayers = playersData
          .map((json) => Player.fromJson(json as Map<String, dynamic>))
          .toList();

      return _cachedPlayers!;
    } catch (e) {
      throw Exception('Failed to load players data: $e');
    }
  }

  /// Get players from career stats CSV - this is the new data source
  Future<List<Player>> getCareerStatsPlayers() async {
    if (_cachedCareerStatsPlayers != null) return _cachedCareerStatsPlayers!;

    try {
      _cachedCareerStatsPlayers =
          await _careerStatsService.loadCareerStatsPlayers();
      return _cachedCareerStatsPlayers!;
    } catch (e) {
      throw Exception('Failed to load career stats players: $e');
    }
  }

  Future<List<Club>> getClubs() async {
    if (_cachedClubs != null) return _cachedClubs!;

    try {
      final String clubsJson =
          await rootBundle.loadString('assets/data/clubs.json');
      final List<dynamic> clubsData = json.decode(clubsJson);

      _cachedClubs = clubsData
          .map((json) => Club.fromJson(json as Map<String, dynamic>))
          .toList();

      return _cachedClubs!;
    } catch (e) {
      throw Exception('Failed to load clubs data: $e');
    }
  }

  Future<List<Match>> getMatches() async {
    if (_cachedMatches != null) return _cachedMatches!;

    try {
      // For now, return empty list - matches will be populated later
      _cachedMatches = [];
      return _cachedMatches!;
    } catch (e) {
      throw Exception('Failed to load matches data: $e');
    }
  }

  Future<Player?> getPlayerById(String id) async {
    final players = await getPlayers();
    try {
      return players.firstWhere((player) => player.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Club?> getClubById(String id) async {
    final clubs = await getClubs();
    try {
      return clubs.firstWhere((club) => club.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Player>> getPlayersByNationality(String nationality) async {
    final players = await getPlayers();
    return players
        .where((player) => player.nationality == nationality)
        .toList();
  }

  Future<List<Player>> getPlayersByPosition(String position) async {
    final players = await getPlayers();
    return players
        .where((player) =>
            player.positions.contains(position) ||
            player.primaryPosition == position)
        .toList();
  }

  Future<List<Player>> getPlayersByClub(String clubId) async {
    final players = await getPlayers();
    return players
        .where((player) => player.clubs.any((club) => club.clubId == clubId))
        .toList();
  }

  Future<List<Player>> getPlayersInAgeRange(int minAge, int maxAge) async {
    final players = await getPlayers();
    final now = DateTime.now();

    return players.where((player) {
      final age = now.difference(player.dateOfBirth).inDays ~/ 365;
      return age >= minAge && age <= maxAge;
    }).toList();
  }

  // Clear cache - useful for testing or when data updates
  void clearCache() {
    _cachedPlayers = null;
    _cachedClubs = null;
    _cachedMatches = null;
    _cachedCareerStatsPlayers = null;
    _careerStatsService.clearCache();
  }
}

@riverpod
Future<List<Player>> allPlayers(AllPlayersRef ref) {
  return ref.watch(dataRepositoryProvider).getPlayers();
}

@riverpod
Future<List<Club>> allClubs(AllClubsRef ref) {
  return ref.watch(dataRepositoryProvider).getClubs();
}

@riverpod
Future<Player?> playerById(PlayerByIdRef ref, String id) {
  return ref.watch(dataRepositoryProvider).getPlayerById(id);
}

@riverpod
Future<Club?> clubById(ClubByIdRef ref, String id) {
  return ref.watch(dataRepositoryProvider).getClubById(id);
}

@riverpod
Future<List<Player>> careerStatsPlayers(CareerStatsPlayersRef ref) {
  return ref.watch(dataRepositoryProvider).getCareerStatsPlayers();
}
