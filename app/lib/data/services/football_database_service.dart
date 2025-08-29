import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/player.dart'; // Import old Player model for compatibility

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class FootballEntity {
  final String id;
  final String name;
  final List<String> alternateNames;

  const FootballEntity({
    required this.id,
    required this.name,
    required this.alternateNames,
  });

  factory FootballEntity.fromJson(Map<String, dynamic> json) {
    return FootballEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      alternateNames: List<String>.from(json['alternateNames'] ?? []),
    );
  }
}

class FootballPlayer extends FootballEntity {
  final String nationality;
  final String? currentClub;
  final String position;
  final int? age;
  final bool? isActive;
  final List<Map<String, dynamic>> careerHistory;
  final List<String> achievements;
  final List<String> tags;

  const FootballPlayer({
    required super.id,
    required super.name,
    required super.alternateNames,
    required this.nationality,
    this.currentClub,
    required this.position,
    this.age,
    this.isActive,
    required this.careerHistory,
    required this.achievements,
    required this.tags,
  });

  factory FootballPlayer.fromJson(Map<String, dynamic> json) {
    return FootballPlayer(
      id: json['id'] as String,
      name: json['name'] as String,
      alternateNames: List<String>.from(json['alternateNames'] ?? []),
      nationality: json['nationality'] as String,
      currentClub: json['currentClub'] as String?,
      position: json['position'] as String,
      age: json['age'] as int?,
      isActive: json['isActive'] as bool?,
      careerHistory:
          List<Map<String, dynamic>>.from(json['careerHistory'] ?? []),
      achievements: List<String>.from(json['achievements'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

class FootballClub extends FootballEntity {
  final String country;
  final String league;
  final int founded;
  final String stadium;
  final List<String> achievements;
  final bool isActive;

  const FootballClub({
    required super.id,
    required super.name,
    required super.alternateNames,
    required this.country,
    required this.league,
    required this.founded,
    required this.stadium,
    required this.achievements,
    required this.isActive,
  });

  factory FootballClub.fromJson(Map<String, dynamic> json) {
    return FootballClub(
      id: json['id'] as String,
      name: json['name'] as String,
      alternateNames: List<String>.from(json['alternateNames'] ?? []),
      country: json['country'] as String,
      league: json['league'] as String,
      founded: json['founded'] as int,
      stadium: json['stadium'] as String,
      achievements: List<String>.from(json['achievements'] ?? []),
      isActive: json['isActive'] as bool,
    );
  }
}

class FootballCountry extends FootballEntity {
  final String continent;
  final List<String> achievements;
  final String confederation;

  const FootballCountry({
    required super.id,
    required super.name,
    required super.alternateNames,
    required this.continent,
    required this.achievements,
    required this.confederation,
  });

  factory FootballCountry.fromJson(Map<String, dynamic> json) {
    return FootballCountry(
      id: json['id'] as String,
      name: json['name'] as String,
      alternateNames: List<String>.from(json['alternateNames'] ?? []),
      continent: json['continent'] as String,
      achievements: List<String>.from(json['achievements'] ?? []),
      confederation: json['confederation'] as String,
    );
  }
}

class TenableAnswer {
  final String entityId;
  final int value;
  final int position;

  const TenableAnswer({
    required this.entityId,
    required this.value,
    required this.position,
  });

  factory TenableAnswer.fromJson(Map<String, dynamic> json) {
    return TenableAnswer(
      entityId: json['entityId'] as String,
      value: json['value'] as int,
      position: json['position'] as int,
    );
  }
}

class TenableCategory {
  final String id;
  final String question;
  final String description;
  final String type; // 'players', 'clubs', 'countries'
  final List<TenableAnswer> answers;

  const TenableCategory({
    required this.id,
    required this.question,
    required this.description,
    required this.type,
    required this.answers,
  });

  factory TenableCategory.fromJson(Map<String, dynamic> json) {
    return TenableCategory(
      id: json['id'] as String,
      question: json['question'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      answers: (json['answers'] as List)
          .map((a) => TenableAnswer.fromJson(a))
          .toList(),
    );
  }
}

class FootballDatabaseService {
  static const String _databasePath = 'assets/data/football_database.json';

  Map<String, dynamic>? _database;
  List<FootballPlayer>? _players;
  List<FootballClub>? _clubs;
  List<FootballCountry>? _countries;
  List<TenableCategory>? _tenableCategories;

  Future<void> loadDatabase() async {
    if (_database != null) return; // Already loaded

    try {
      print('Loading football database from $_databasePath');
      final jsonString = await rootBundle.loadString(_databasePath);
      _database = json.decode(jsonString);

      // Parse entities
      _players = (_database!['players'] as List)
          .map((p) => FootballPlayer.fromJson(p))
          .toList();

      _clubs = (_database!['clubs'] as List)
          .map((c) => FootballClub.fromJson(c))
          .toList();

      _countries = (_database!['countries'] as List)
          .map((c) => FootballCountry.fromJson(c))
          .toList();

      _tenableCategories = (_database!['tenableCategories'] as List)
          .map((tc) => TenableCategory.fromJson(tc))
          .toList();

      print('Football database loaded successfully:');
      print('- ${_players!.length} players');
      print('- ${_clubs!.length} clubs');
      print('- ${_countries!.length} countries');
      print('- ${_tenableCategories!.length} tenable categories');
    } catch (e) {
      print('Error loading football database: $e');
      _database = {};
      _players = [];
      _clubs = [];
      _countries = [];
      _tenableCategories = [];
    }
  }

  // Player methods
  List<FootballPlayer> get players {
    _ensureLoaded();
    return _players ?? [];
  }

  FootballPlayer? getPlayerById(String id) {
    return players.firstWhereOrNull((p) => p.id == id);
  }

  List<FootballPlayer> searchPlayers(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return players.where((player) {
      return player.name.toLowerCase().contains(lowerQuery) ||
          player.alternateNames
              .any((name) => name.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Club methods
  List<FootballClub> get clubs {
    _ensureLoaded();
    return _clubs ?? [];
  }

  FootballClub? getClubById(String id) {
    return clubs.firstWhereOrNull((c) => c.id == id);
  }

  List<FootballClub> searchClubs(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return clubs.where((club) {
      return club.name.toLowerCase().contains(lowerQuery) ||
          club.alternateNames
              .any((name) => name.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Country methods
  List<FootballCountry> get countries {
    _ensureLoaded();
    return _countries ?? [];
  }

  FootballCountry? getCountryById(String id) {
    return countries.firstWhereOrNull((c) => c.id == id);
  }

  // Tenable methods
  List<TenableCategory> get tenableCategories {
    _ensureLoaded();
    return _tenableCategories ?? [];
  }

  TenableCategory? getTenableCategoryById(String id) {
    return tenableCategories.firstWhereOrNull((tc) => tc.id == id);
  }

  // Search across all entity types
  List<FootballEntity> searchAll(String query, {String? type}) {
    final List<FootballEntity> results = [];

    if (type == null || type == 'players') {
      results.addAll(searchPlayers(query));
    }
    if (type == null || type == 'clubs') {
      results.addAll(searchClubs(query));
    }
    if (type == null || type == 'countries') {
      results.addAll(countries.where((country) {
        final lowerQuery = query.toLowerCase();
        return country.name.toLowerCase().contains(lowerQuery) ||
            country.alternateNames
                .any((name) => name.toLowerCase().contains(lowerQuery));
      }));
    }

    return results;
  }

  // Fuzzy matching for tenable answers
  FootballEntity? findEntityByName(String name, {String? type}) {
    final allEntities = searchAll(name, type: type);

    // Exact match first
    for (final entity in allEntities) {
      if (entity.name.toLowerCase() == name.toLowerCase()) {
        return entity;
      }
    }

    // Check alternate names
    for (final entity in allEntities) {
      for (final altName in entity.alternateNames) {
        if (altName.toLowerCase() == name.toLowerCase()) {
          return entity;
        }
      }
    }

    // Partial match
    for (final entity in allEntities) {
      if (entity.name.toLowerCase().contains(name.toLowerCase()) ||
          name.toLowerCase().contains(entity.name.toLowerCase())) {
        return entity;
      }
    }

    return null;
  }

  void _ensureLoaded() {
    if (_database == null) {
      throw StateError('Database not loaded. Call loadDatabase() first.');
    }
  }

  // Compatibility methods that return old model types
  Future<List<Player>> getPlayers() async {
    await loadDatabase();
    return players.map((fp) => _convertToOldPlayer(fp)).toList();
  }

  Future<List<Player>> getCareerStatsPlayers() async {
    await loadDatabase();
    // Filter players that have career history for career path game
    return players
        .where((fp) => fp.careerHistory.isNotEmpty)
        .map((fp) => _convertToOldPlayer(fp))
        .toList();
  }

  Player _convertToOldPlayer(FootballPlayer footballPlayer) {
    // Convert FootballPlayer to old Player model
    return Player(
      id: footballPlayer.id,
      name: footballPlayer.name,
      nationality: footballPlayer.nationality,
      dateOfBirth:
          DateTime.now(), // Default, since FootballPlayer doesn't have this
      positions: [footballPlayer.position],
      primaryPosition: footballPlayer.position,
      clubs: footballPlayer.careerHistory
          .map((ch) => ClubHistory(
                clubId: ch['club'] ?? 'unknown',
                from: DateTime(ch['startYear'] ?? 2000),
                to: ch['endYear'] != null ? DateTime(ch['endYear']) : null,
                isLoan: false,
              ))
          .toList(),
      leagues: footballPlayer.careerHistory
          .map((ch) => ch['league'] as String? ?? 'Unknown')
          .toSet()
          .toList(),
      teammatesHash: '', // Default empty
      meta: {},
    );
  }
}
