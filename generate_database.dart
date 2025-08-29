import 'dart:io';
import 'dart:convert';

// Script to generate centralized database from CSV
void main() async {
  print('Generating centralized football database from CSV...');

  final csvFile = File(
    '/Users/mattiasdaum/Desktop/FootyGuess/app/assets/data/tenable_game_dataset_full_normalized_10only_clean.csv',
  );

  if (!csvFile.existsSync()) {
    print('CSV file not found!');
    return;
  }

  final lines = await csvFile.readAsLines();
  print('Processing ${lines.length} lines...');

  // Skip header
  final dataLines = lines.skip(1);

  // Group by question ID
  final Map<String, List<Map<String, String>>> questionGroups = {};

  for (final line in dataLines) {
    if (line.trim().isEmpty) continue;

    final parts = _parseCSVLine(line);
    if (parts.length >= 5) {
      final questionId = parts[0].trim();
      final question = parts[1].trim();
      final answerPosition = parts[3].trim();
      final answer = parts[4].trim();

      if (!questionGroups.containsKey(questionId)) {
        questionGroups[questionId] = [];
      }

      questionGroups[questionId]!.add({
        'question': question,
        'position': answerPosition,
        'answer': answer,
      });
    }
  }

  print('Found ${questionGroups.length} unique questions');

  // Categorize entities
  final Set<String> allPlayers = {};
  final Set<String> allClubs = {};
  final Set<String> allCountries = {};
  final List<Map<String, dynamic>> tenableCategories = [];

  for (final entry in questionGroups.entries) {
    final questionData = entry.value;
    if (questionData.isEmpty) continue;

    // Sort by position
    questionData.sort(
      (a, b) => int.parse(
        a['position'] ?? '0',
      ).compareTo(int.parse(b['position'] ?? '0')),
    );

    final question = questionData.first['question'] ?? '';
    final answers = questionData
        .map((data) => data['answer'] ?? '')
        .where((answer) => answer.isNotEmpty)
        .take(10)
        .toList();

    if (question.isNotEmpty && answers.length >= 5) {
      // Determine category type
      String type = 'players'; // default

      if (question.toLowerCase().contains('clubs') ||
          question.toLowerCase().contains('teams')) {
        type = 'clubs';
        allClubs.addAll(answers);
      } else if (question.toLowerCase().contains('countries') ||
          question.toLowerCase().contains('nations')) {
        type = 'countries';
        allCountries.addAll(answers);
      } else {
        type = 'players';
        allPlayers.addAll(answers);
      }

      // Create tenable category
      final category = {
        'id': 'q_${entry.key}',
        'question': question,
        'description': 'Name the top ${answers.length} in this category',
        'type': type,
        'answers': answers
            .asMap()
            .entries
            .map(
              (e) => {
                'entityId': '${type}_${_sanitizeId(e.value)}',
                'value': answers.length - e.key,
                'position': e.key + 1,
              },
            )
            .toList(),
      };

      tenableCategories.add(category);
    }
  }

  print('Categorized:');
  print('- ${allPlayers.length} unique players');
  print('- ${allClubs.length} unique clubs');
  print('- ${allCountries.length} unique countries');
  print('- ${tenableCategories.length} tenable categories');

  // Generate database
  final database = {
    'metadata': {
      'version': '1.0',
      'lastUpdated': DateTime.now().toIso8601String(),
      'description': 'Auto-generated football database from CSV',
      'source': 'tenable_game_dataset_full_normalized_10only_clean.csv',
    },
    'players': allPlayers
        .map(
          (name) => {
            'id': 'players_${_sanitizeId(name)}',
            'name': name,
            'alternateNames': <String>[],
            'nationality': 'Unknown',
            'currentClub': null,
            'position': 'Unknown',
            'age': null,
            'isActive': null,
            'careerHistory': <Map<String, dynamic>>[],
            'achievements': <String>[],
            'tags': <String>[],
          },
        )
        .toList(),
    'clubs': allClubs
        .map(
          (name) => {
            'id': 'clubs_${_sanitizeId(name)}',
            'name': name,
            'alternateNames': <String>[],
            'country': 'Unknown',
            'league': 'Unknown',
            'founded': 1900,
            'stadium': 'Unknown',
            'achievements': <String>[],
            'isActive': true,
          },
        )
        .toList(),
    'countries': allCountries
        .map(
          (name) => {
            'id': 'countries_${_sanitizeId(name)}',
            'name': name,
            'alternateNames': <String>[],
            'continent': 'Unknown',
            'achievements': <String>[],
            'confederation': 'Unknown',
          },
        )
        .toList(),
    'achievements': <Map<String, dynamic>>[],
    'tenableCategories': tenableCategories,
  };

  // Write to file
  final outputFile = File(
    '/Users/mattiasdaum/Desktop/FootyGuess/app/assets/data/football_database_generated.json',
  );
  await outputFile.writeAsString(
    JsonEncoder.withIndent('  ').convert(database),
  );

  print('Generated database written to: ${outputFile.path}');
  print('✅ Database generation complete!');
}

List<String> _parseCSVLine(String line) {
  final result = <String>[];
  final buffer = StringBuffer();
  bool inQuotes = false;

  for (int i = 0; i < line.length; i++) {
    final char = line[i];

    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      result.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }

  result.add(buffer.toString());
  return result;
}

String _sanitizeId(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}
