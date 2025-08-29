import 'package:flutter/services.dart';
import '../models/player.dart';

class TenableCsvCategory {
  final String category;
  final String description;
  final List<String> answers;

  const TenableCsvCategory({
    required this.category,
    required this.description,
    required this.answers,
  });
}

class TenableDataService {
  static const String _csvPath =
      'assets/data/tenable_game_dataset_full_normalized_10only_clean.csv';

  Future<List<TenableCsvCategory>> loadTenableCategories() async {
    try {
      print('Loading tenable categories from $_csvPath');
      final csvString = await rootBundle.loadString(_csvPath);
      final categories = _parseCsv(csvString);
      print('Loaded ${categories.length} tenable categories');
      return categories;
    } catch (e) {
      print('Error loading tenable categories: $e');
      return [];
    }
  }

  List<TenableCsvCategory> _parseCsv(String csvContent) {
    final categories = <TenableCsvCategory>[];
    final lines = csvContent.split('\n');

    print('Processing ${lines.length} lines from CSV');

    // Skip header row
    final dataLines = lines.skip(1).where((line) => line.trim().isNotEmpty);

    // Group lines by Question_ID
    final Map<String, List<Map<String, String>>> questionGroups = {};

    for (final line in dataLines) {
      try {
        final parts = _parseCSVLine(line);
        if (parts.length >= 6) {
          final questionId = parts[0].trim();
          final question = parts[1].trim();
          final answerPosition = parts[3].trim();
          final answer = parts[4].trim();
          final value = parts[5].trim();

          if (!questionGroups.containsKey(questionId)) {
            questionGroups[questionId] = [];
          }

          questionGroups[questionId]!.add({
            'question': question,
            'position': answerPosition,
            'answer': answer,
            'value': value,
          });
        }
      } catch (e) {
        print('Error parsing line: $e');
        print('Line content: $line');
      }
    }

    // Convert grouped data to categories
    for (final entry in questionGroups.entries) {
      final questionData = entry.value;
      if (questionData.isNotEmpty) {
        // Sort by answer position
        questionData.sort((a, b) => int.parse(a['position'] ?? '0')
            .compareTo(int.parse(b['position'] ?? '0')));

        final category = questionData.first['question'] ?? '';
        final answers = questionData
            .map((data) => data['answer'] ?? '')
            .where((answer) => answer.isNotEmpty)
            .take(10) // Ensure we only take top 10
            .toList();

        if (category.isNotEmpty && answers.length >= 5) {
          categories.add(TenableCsvCategory(
            category: category,
            description: 'Name the top ${answers.length} in this category',
            answers: answers,
          ));
        }
      }
    }

    print('Successfully parsed ${categories.length} categories');
    return categories;
  }

  List<String> _parseCSVLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          // Escaped quote
          buffer.write('"');
          i++; // Skip next quote
        } else {
          // Toggle quote state
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        // Field separator
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    // Add the last field
    result.add(buffer.toString());

    return result;
  }

  Player? findPlayerByName(String playerName, List<Player> allPlayers) {
    // For club-based categories, we need to check if this is a club name
    // If so, find any player from that club
    final clubPlayer = _findPlayerFromClub(playerName, allPlayers);
    if (clubPlayer != null) {
      return clubPlayer;
    }

    // Otherwise, search for exact player name match
    for (final player in allPlayers) {
      if (player.name.toLowerCase() == playerName.toLowerCase()) {
        return player;
      }
    }

    // Fuzzy match for close names
    for (final player in allPlayers) {
      if (_isNameSimilar(player.name, playerName)) {
        return player;
      }
    }

    return null;
  }

  Player? _findPlayerFromClub(String clubName, List<Player> allPlayers) {
    // Clean up club name for matching
    final cleanClubName = clubName
        .toLowerCase()
        .replaceAll('fc', '')
        .replaceAll('cf', '')
        .replaceAll('ac', '')
        .replaceAll('sc', '')
        .trim();

    for (final player in allPlayers) {
      if (player.currentClub.toLowerCase().contains(cleanClubName) ||
          cleanClubName.contains(player.currentClub.toLowerCase())) {
        return player;
      }
    }

    return null;
  }

  bool _isNameSimilar(String playerName, String csvName) {
    final pName = playerName.toLowerCase().trim();
    final cName = csvName.toLowerCase().trim();

    // Check if one contains the other
    if (pName.contains(cName) || cName.contains(pName)) {
      return true;
    }

    // Check for common name variations
    final pParts = pName.split(' ');
    final cParts = cName.split(' ');

    // If both have multiple parts, check if key parts match
    if (pParts.length > 1 && cParts.length > 1) {
      // Check if last names match
      if (pParts.last == cParts.last) {
        return true;
      }

      // Check if first names match
      if (pParts.first == cParts.first) {
        return true;
      }
    }

    return false;
  }
}
