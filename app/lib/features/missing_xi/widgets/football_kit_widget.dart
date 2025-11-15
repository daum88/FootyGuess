import 'package:flutter/material.dart';
import '../../../core/theme/retro_theme.dart';
import '../providers/missing_xi_provider.dart';

/// A compact football kit widget designed specifically for Missing XI game
/// Optimized to fit within tight screen constraints while displaying:
/// - Jersey number from CSV data
/// - Player surname from CSV data
/// - Position-appropriate styling
/// - Interactive states (empty, selected, filled)
class FootballKitWidget extends StatelessWidget {
  final FormationPosition position;
  final int index;
  final bool isSelected;
  final bool hasPlayer;
  final VoidCallback onTap;
  final int? csvJerseyNumber; // Jersey number from CSV data
  final String? csvPlayerName; // Player name from CSV data

  const FootballKitWidget({
    super.key,
    required this.position,
    required this.index,
    required this.isSelected,
    required this.hasPlayer,
    required this.onTap,
    this.csvJerseyNumber,
    this.csvPlayerName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40, // Optimized width to fit screen
        height: 48, // Optimized height to prevent overflow
        decoration: _buildKitDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Jersey number section
            Expanded(
              flex: 3,
              child: _buildNumberSection(),
            ),
            // Name section
            Expanded(
              flex: 1,
              child: _buildNameSection(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the main kit decoration
  BoxDecoration _buildKitDecoration() {
    final Color kitColor = _getKitColor();

    return BoxDecoration(
      color: kitColor,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: isSelected ? Colors.amber : Colors.white,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        if (isSelected)
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
      ],
    );
  }

  /// Build the jersey number section
  Widget _buildNumberSection() {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _getNumberBackgroundColor(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        border: Border.all(color: Colors.white70, width: 0.5),
      ),
      child: Center(
        child: hasPlayer ? _buildPlayerNumber() : _buildEmptyState(),
      ),
    );
  }

  /// Build the name section
  Widget _buildNameSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        border: Border.all(color: Colors.white70, width: 0.5),
      ),
      child: Center(
        child: hasPlayer ? _buildPlayerName() : _buildPositionLabel(),
      ),
    );
  }

  /// Build player number display
  Widget _buildPlayerNumber() {
    final number = csvJerseyNumber ?? _getDefaultKitNumber();

    return Text(
      '$number',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  /// Build player name display
  Widget _buildPlayerName() {
    final displayName = _getDisplayName();

    return Text(
      displayName,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 8,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build empty state (no player selected)
  Widget _buildEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isSelected ? Icons.add_circle_outline : Icons.sports_soccer,
          color: isSelected ? Colors.black : Colors.white70,
          size: 10,
        ),
        const SizedBox(height: 1),
        Text(
          '${_getDefaultKitNumber()}',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 6,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build position label for empty kit
  Widget _buildPositionLabel() {
    return Text(
      position.position,
      style: TextStyle(
        color: isSelected ? Colors.black : Colors.black54,
        fontSize: 6,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Get kit color based on state
  Color _getKitColor() {
    if (hasPlayer) {
      return const Color(0xFF1976D2); // Blue for filled positions
    } else if (isSelected) {
      return const Color(0xFFFFD700); // Gold for selected
    } else {
      return RetroTheme.cardPurple; // Dark for empty
    }
  }

  /// Get number section background color
  Color _getNumberBackgroundColor() {
    final kitColor = _getKitColor();
    return kitColor.withValues(alpha: 0.9);
  }

  /// Get display name from CSV or fallback
  String _getDisplayName() {
    if (csvPlayerName != null && csvPlayerName!.isNotEmpty) {
      // Use CSV player name - get surname
      final nameParts = csvPlayerName!.trim().split(' ');
      return nameParts.last.toUpperCase();
    } else if (position.player != null) {
      // Fallback to position player name
      final nameParts = position.player!.name.split(' ');
      return nameParts.last.toUpperCase();
    }
    return '';
  }

  /// Get default kit number based on position
  int _getDefaultKitNumber() {
    if (csvJerseyNumber != null && csvJerseyNumber! > 0) {
      return csvJerseyNumber!;
    }

    // Fallback to position-based numbers
    switch (position.position.toUpperCase()) {
      case 'GK':
        return 1;
      case 'RB':
        return 2;
      case 'LB':
        return 3;
      case 'CB':
        return [4, 5, 6][index % 3];
      case 'CDM':
        return 6;
      case 'CM':
        return [8, 10][index % 2];
      case 'CAM':
        return 10;
      case 'LM':
        return 11;
      case 'RM':
        return 7;
      case 'LW':
        return 11;
      case 'RW':
        return 7;
      case 'ST':
        return 9;
      case 'CF':
        return 9;
      default:
        return index + 1;
    }
  }
}

/// Extension to help with kit positioning and spacing
extension FootballKitSpacing on FootballKitWidget {
  /// Calculate optimal spacing for formation
  static double getOptimalSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth - 100) / 11; // Space for up to 11 players
  }

  /// Get position constraints for the field
  static BoxConstraints getKitConstraints() {
    return const BoxConstraints(
      minWidth: 35,
      maxWidth: 45,
      minHeight: 40,
      maxHeight: 50,
    );
  }
}
