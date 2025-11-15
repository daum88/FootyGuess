import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:footyguess/core/services/optimized_data_service.dart';
import 'package:footyguess/data/services/csv_player_service.dart';

void main() {
  group('Data Loading Performance Tests', () {
    test('Compare old vs new player loading performance', () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      print('🔥 Performance Benchmark: Data Loading Speed');
      print('=' * 50);

      // Test old method
      final oldStopwatch = Stopwatch()..start();
      try {
        final oldPlayers = await CsvPlayerService.loadPlayers();
        oldStopwatch.stop();
        print(
            '📊 OLD METHOD: ${oldPlayers.length} players in ${oldStopwatch.elapsedMilliseconds}ms');
      } catch (e) {
        oldStopwatch.stop();
        print('❌ OLD METHOD failed: $e');
      }

      // Test new optimized method
      final newStopwatch = Stopwatch()..start();
      try {
        final optimizedService = OptimizedDataService();
        final newPlayers = await optimizedService.getPlayers();
        newStopwatch.stop();
        print(
            '🚀 NEW METHOD: ${newPlayers.length} players in ${newStopwatch.elapsedMilliseconds}ms');

        // Test cached access (should be near instant)
        final cacheStopwatch = Stopwatch()..start();
        final cachedPlayers = await optimizedService.getPlayers();
        cacheStopwatch.stop();
        print(
            '⚡ CACHED ACCESS: ${cachedPlayers.length} players in ${cacheStopwatch.elapsedMilliseconds}ms');

        // Calculate improvement
        if (oldStopwatch.elapsedMilliseconds > 0) {
          final improvement = ((oldStopwatch.elapsedMilliseconds -
                  newStopwatch.elapsedMilliseconds) /
              oldStopwatch.elapsedMilliseconds *
              100);
          print(
              '📈 PERFORMANCE IMPROVEMENT: ${improvement.toStringAsFixed(1)}%');
        }

        print(
            '💾 CACHE SPEEDUP: ${(newStopwatch.elapsedMilliseconds / cacheStopwatch.elapsedMilliseconds).toStringAsFixed(1)}x faster');
      } catch (e) {
        newStopwatch.stop();
        print('❌ NEW METHOD failed: $e');
      }

      print('=' * 50);
    });

    test('Memory usage comparison', () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      print('🔥 Memory Usage Test');
      print('=' * 30);

      try {
        // Check memory before
        final processBefore =
            await Process.run('ps', ['-o', 'rss=', '-p', '$pid']);
        final memoryBefore =
            int.tryParse(processBefore.stdout.toString().trim()) ?? 0;

        final optimizedService = OptimizedDataService();
        await optimizedService.preloadAllData();

        // Check memory after
        final processAfter =
            await Process.run('ps', ['-o', 'rss=', '-p', '$pid']);
        final memoryAfter =
            int.tryParse(processAfter.stdout.toString().trim()) ?? 0;

        final memoryUsed = memoryAfter - memoryBefore;
        print('📊 Memory used for preloading all data: ${memoryUsed}KB');
      } catch (e) {
        print('❌ Memory test failed: $e');
      }

      print('=' * 30);
    });
  });
}
