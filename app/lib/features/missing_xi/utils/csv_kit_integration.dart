import 'package:flutter/material.dart';
import '../widgets/football_kit_widget.dart';
import '../providers/missing_xi_provider.dart';

/// Example of how to integrate the FootballKitWidget with CSV data
/// This shows how to extract jersey numbers and names from your CSV lineup data
class MissingXiKitIntegration {
  /// Build a kit widget with CSV data integration
  static Widget buildCsvKitWidget({
    required FormationPosition position,
    required int index,
    required bool isSelected,
    required bool hasPlayer,
    required VoidCallback onTap,
    required Map<String, dynamic>? csvPlayerData, // Data from your CSV
  }) {
    // Extract CSV data
    final csvJerseyNumber = csvPlayerData?['jersey_number'] as int?;
    final csvPlayerName = csvPlayerData?['player_name'] as String?;

    return FootballKitWidget(
      position: position,
      index: index,
      isSelected: isSelected,
      hasPlayer: hasPlayer,
      onTap: onTap,
      csvJerseyNumber: csvJerseyNumber,
      csvPlayerName: csvPlayerName,
    );
  }

  /// Create a formation layout with proper spacing
  static Widget buildFormationLayout({
    required BuildContext context,
    required List<FormationPosition> positions,
    required Function(int) onPositionTap,
    required int? selectedIndex,
    required Map<int, Map<String, dynamic>>
        csvPlayerData, // CSV data by position index
  }) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: positions.asMap().entries.map((entry) {
          final index = entry.key;
          final position = entry.value;

          // Calculate position on field
          final fieldWidth = MediaQuery.of(context).size.width - 32;
          final fieldHeight = 368.0;

          final left =
              (position.x * (fieldWidth - 45)).clamp(0.0, fieldWidth - 45);
          final top =
              (position.y * (fieldHeight - 50)).clamp(0.0, fieldHeight - 50);

          return Positioned(
            left: left,
            top: top,
            child: buildCsvKitWidget(
              position: position,
              index: index,
              isSelected: selectedIndex == index,
              hasPlayer: position.player != null,
              onTap: () => onPositionTap(index),
              csvPlayerData: csvPlayerData[index],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Data structure for CSV integration
class CsvPlayerData {
  final int jerseyNumber;
  final String playerName;
  final String position;
  final String nationality;
  final double xPosition;
  final double yPosition;

  const CsvPlayerData({
    required this.jerseyNumber,
    required this.playerName,
    required this.position,
    required this.nationality,
    required this.xPosition,
    required this.yPosition,
  });

  /// Create from CSV row data
  factory CsvPlayerData.fromCsvRow(Map<String, dynamic> csvRow) {
    return CsvPlayerData(
      jerseyNumber: csvRow['jersey_number'] ?? 0,
      playerName: csvRow['player_name'] ?? '',
      position: csvRow['position'] ?? '',
      nationality: csvRow['nationality'] ?? '',
      xPosition: csvRow['x_position'] ?? 0.5,
      yPosition: csvRow['y_position'] ?? 0.5,
    );
  }

  /// Convert to map for easy usage
  Map<String, dynamic> toMap() {
    return {
      'jersey_number': jerseyNumber,
      'player_name': playerName,
      'position': position,
      'nationality': nationality,
      'x_position': xPosition,
      'y_position': yPosition,
    };
  }
}
