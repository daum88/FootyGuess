import 'package:flutter_test/flutter_test.dart';
import 'package:footyguess/data/services/game_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameDataService', () {
    test('loads canonical game data', () async {
      final service = GameDataService();
      await service.load();

      expect(service.players, isNotEmpty);
      expect(service.matches, isNotEmpty);
      expect(service.lineups, isNotEmpty);
      expect(service.clubs, isNotEmpty);
      expect(service.tenable, isNotEmpty);
    });

    test('guessable players have age, club and position', () async {
      final service = GameDataService();
      await service.load();

      final guessable = service.guessablePlayers;
      expect(guessable, isNotEmpty);
      for (final p in guessable.take(100)) {
        expect(p.age, isNotNull);
        expect(p.currentClub, isNotEmpty);
        expect(p.positions, isNotEmpty);
      }
    });

    test('career players have at least 2 clubs', () async {
      final service = GameDataService();
      await service.load();

      for (final p in service.careerPlayers.take(100)) {
        expect(p.career.length, greaterThanOrEqualTo(2));
      }
    });

    test('scored matches have scorers', () async {
      final service = GameDataService();
      await service.load();

      final scored = service.scoredMatches;
      expect(scored, isNotEmpty);
      for (final m in scored.take(50)) {
        expect(m.scorers, isNotEmpty);
      }
    });
  });
}
