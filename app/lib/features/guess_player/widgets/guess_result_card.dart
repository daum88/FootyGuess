import 'package:flutter/material.dart';
import '../../../data/models/player.dart';
import '../utils/guess_analyzer.dart';

class GuessResultCard extends StatelessWidget {
  final Player player;
  final GuessComparison? comparison;
  final bool isCorrect;

  const GuessResultCard({
    super.key,
    required this.player,
    this.comparison,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // Player name
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    player.currentClub,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Nationality
            Expanded(
              child: _buildComparisonCell(
                player.nationality,
                comparison?.nationality ?? ComparisonResult.incorrect,
              ),
            ),

            // Position
            Expanded(
              child: _buildComparisonCell(
                player.position,
                comparison?.position ?? ComparisonResult.incorrect,
              ),
            ),

            // Age
            Expanded(
              child: _buildComparisonCell(
                '${player.age}',
                comparison?.age ?? ComparisonResult.incorrect,
              ),
            ),

            // Club
            Expanded(
              child: _buildComparisonCell(
                player.currentClub,
                comparison?.club ?? ComparisonResult.incorrect,
              ),
            ),

            // League
            Expanded(
              child: _buildComparisonCell(
                player.leagues.isNotEmpty ? player.leagues.first : 'Unknown',
                comparison?.league ?? ComparisonResult.incorrect,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCell(String text, ComparisonResult result) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (result) {
      case ComparisonResult.correct:
        backgroundColor = Colors.green;
        break;
      case ComparisonResult.partial:
        backgroundColor = Colors.orange;
        break;
      case ComparisonResult.incorrect:
        backgroundColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
