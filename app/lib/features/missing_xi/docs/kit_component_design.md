# Football Kit Component Design for Missing XI

## 🎯 **Design Requirements**

Based on your screen constraints and CSV data, here's the optimal kit component specification:

### **Dimensions & Constraints**
```dart
Width: 40px  // Fits 11 players across screen with spacing
Height: 48px // Prevents layout overflow issues
Border: 1-2px // Selection indicator
Padding: 2px internal // Content spacing
```

### **Data Integration from CSV**
The component uses these CSV fields:
- `jersey_number` - Real shirt numbers (1-99)
- `player_name` - Full player name (surname displayed)
- `position` - Field position (GK, CB, CM, ST, etc.)
- `x_position` - Horizontal field position (0.0-1.0)
- `y_position` - Vertical field position (0.0-1.0)

## 🎨 **Visual Structure**

```
┌─────────────────────────────────────┐ ← 40px width
│ ┌─────────────────────────────────┐ │
│ │         Jersey Number           │ │ ← 36px height (75%)
│ │            "10"                 │ │   Number section
│ │                                 │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │       Player Surname            │ │ ← 12px height (25%)
│ │        "MESSI"                  │ │   Name section
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘ ← 48px total height
```

## 🔧 **Component States**

### **1. Empty State (No Player)**
- **Kit Color**: Dark purple (`RetroTheme.cardPurple`)
- **Number Section**: 
  - Small soccer ball icon (10px)
  - Position-based default number (6px font)
- **Name Section**: Position abbreviation (6px font)

### **2. Selected State (Position Clicked)**
- **Kit Color**: Gold (`Color(0xFFFFD700)`)
- **Border**: Amber, 2px thick with glow effect
- **Number Section**: "+" icon with position number
- **Name Section**: Position abbreviation in bold

### **3. Filled State (Player Assigned)**
- **Kit Color**: Blue (`Color(0xFF1976D2)`)
- **Number Section**: 
  - CSV jersey number (12px, bold, white)
  - Drop shadow for readability
- **Name Section**: Player surname (8px, black, uppercase)

## 📱 **Screen Optimization**

### **Formation Layout**
```dart
Field Width: Screen width - 32px margins
Field Height: 400px fixed
Kit Spacing: Auto-calculated to fit formation
Minimum Gap: 8px between kits
Maximum Kits: 11 players per team
```

### **Responsive Calculations**
```dart
// Position calculation
final fieldWidth = MediaQuery.of(context).size.width - 32;
final left = position.x * (fieldWidth - 45);
final top = position.y * 368; // Field height - kit height

// Spacing optimization
final optimalSpacing = fieldWidth / 11; // For 11 players
```

## 💾 **CSV Data Integration**

### **Data Extraction Pattern**
```dart
// From your CSV service
final csvPlayerData = {
  'jersey_number': row[10], // Real shirt number
  'player_name': row[8],    // Full player name
  'position': row[9],       // Field position
  'x_position': row[19],    // Horizontal (0.0-1.0)
  'y_position': row[20],    // Vertical (0.0-1.0)
};

// Usage in kit widget
FootballKitWidget(
  csvJerseyNumber: csvPlayerData['jersey_number'],
  csvPlayerName: csvPlayerData['player_name'],
  // ... other properties
)
```

### **Jersey Number Logic**
```dart
int getDisplayNumber() {
  // Priority 1: CSV jersey number
  if (csvJerseyNumber != null && csvJerseyNumber! > 0) {
    return csvJerseyNumber!;
  }
  
  // Priority 2: Position-based defaults
  switch (position) {
    case 'GK': return 1;
    case 'RB': return 2;
    case 'CB': return [4, 5, 6][index % 3];
    case 'CM': return [8, 10][index % 2];
    case 'ST': return 9;
    default: return index + 1;
  }
}
```

### **Name Display Logic**
```dart
String getDisplayName() {
  // Use CSV player name (surname only)
  if (csvPlayerName?.isNotEmpty == true) {
    final parts = csvPlayerName!.split(' ');
    return parts.last.toUpperCase();
  }
  
  // Fallback to position
  return position;
}
```

## 🎯 **Performance Considerations**

### **Memory Optimization**
- Use `const` constructors where possible
- Cache kit decorations for reuse
- Minimize widget rebuilds with proper state management

### **Animation Efficiency**
- `AnimatedContainer` for state transitions (200ms)
- Shadow effects only for selected state
- Avoid continuous animations during gameplay

### **Screen Density Support**
- Font sizes scale with device density
- Icon sizes adapt to available space
- Minimum touch target: 44px (iOS) / 48px (Android)

## 🔍 **Usage Example**

```dart
// In your Missing XI page
Widget buildKitPosition(int index) {
  final position = gameState.playerPositions[index];
  final csvData = teamCsvData[index]; // Your CSV player data
  
  return FootballKitWidget(
    position: position,
    index: index,
    isSelected: gameState.selectedPositionIndex == index,
    hasPlayer: position.player != null,
    onTap: () => notifier.selectPosition(index),
    csvJerseyNumber: csvData?['jersey_number'],
    csvPlayerName: csvData?['player_name'],
  );
}
```

## 🏆 **Benefits of This Design**

1. **Fits Screen**: 40x48px ensures 11 players fit on mobile screens
2. **CSV Integration**: Uses real jersey numbers and player names
3. **Clear States**: Visual feedback for empty/selected/filled states
4. **Performance**: Optimized for smooth scrolling and interaction
5. **Accessibility**: Proper contrast ratios and touch targets
6. **Responsive**: Adapts to different screen sizes automatically

## 🔧 **Customization Options**

- **Team Colors**: Modify kit colors based on team in CSV
- **Formation Styles**: Adjust spacing for different formations
- **Typography**: Customize fonts for different leagues/eras
- **Animations**: Add kit-specific entrance animations
- **Nationality Flags**: Small flag icons using CSV nationality data

This design ensures your Missing XI game displays real historic teams with authentic jersey numbers and player names while maintaining excellent performance and user experience across all device sizes.
