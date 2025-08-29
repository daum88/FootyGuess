import 'package:flutter_test/flutter_test.dart';
import 'package:footyguess/data/services/csv_player_service.dart';

void main() {
  group('CsvPlayerService Tests', () {
    test('should load players from CSV', () async {
      final players = await CsvPlayerService.loadPlayers();

      expect(players, isNotEmpty);
      expect(players.length, greaterThan(10));

      // Check if a sample player exists
      final messiExists = players.any((player) =>
          player['name']?.toString().toLowerCase().contains('messi') ?? false);
      expect(messiExists, isTrue);
    });

    test('should search for players by name', () async {
      final searchResults = await CsvPlayerService.searchPlayers('messi');

      expect(searchResults, isNotEmpty);
      expect(searchResults.first['name']?.toString().toLowerCase(),
          contains('messi'));
    });

    test('should get random player', () async {
      final randomPlayer = await CsvPlayerService.getRandomPlayer();

      expect(randomPlayer, isNotEmpty);
      expect(randomPlayer['name'], isNotNull);
      expect(randomPlayer['nationality'], isNotNull);
      expect(randomPlayer['club'], isNotNull);
      expect(randomPlayer['position'], isNotNull);
      expect(randomPlayer['age'], isNotNull);
    });

    test('should get player by exact name', () async {
      final player = await CsvPlayerService.getPlayerByName('Lionel Messi');

      expect(player, isNotNull);
      expect(player!['name'], equals('Lionel Messi'));
      expect(player['nationality'], equals('Argentina'));
    });
  });
}
