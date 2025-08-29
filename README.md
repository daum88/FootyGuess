# FootyGuess 

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)

A production-ready Flutter app featuring 6 football guessing games with daily and endless modes, Firebase backend, anti-cheat systems, and global leaderboards.

## 🎮 Game Modes

### Daily Challenges
- **Guess the Player** - Wordle-style guessing with nationality, position, age, and club clues
- **Career Path Challenge** - Progressive club timeline reveals  
- **Who Scored?** - Timed multiple choice on match moments
- **Football Tenable** - Category-based list challenges
- **Missing XI** - Formation grid completion puzzles
- **Football Tic-Tac-Toe** - Strategic player placement grid

### Endless Mode
Each game mode offers unlimited practice with dynamically generated puzzles.

## 🏗️ Architecture

### Frontend (Flutter)
```
app/
├── lib/
│   ├── core/           # Constants, theme, environment, error types
│   ├── data/           # Repositories, API clients, models
│   ├── domain/         # Entities, use-cases  
│   ├── features/       # Feature modules (daily, endless, games)
│   ├── routing/        # GoRouter configuration
│   └── widgets/        # Reusable UI components
├── assets/
│   ├── data/           # Curated player/club datasets (JSON)
│   ├── images/         # App icons and graphics
│   └── animations/     # Lottie/Rive animations
└── test/               # Unit, widget, integration tests
```

### Backend (Firebase)
```
backend/
├── functions/          # Cloud Functions (Node.js)
│   ├── src/api/        # HTTP callable endpoints
│   ├── src/security/   # Anti-cheat & verification
│   ├── src/jobs/       # Scheduled daily generators
│   └── src/util/       # Shared utilities
├── firestore.rules     # Security rules
└── firestore.indexes.json
```

## 🔒 Security & Anti-Cheat

- **Server-side scoring** - All game validation happens on Firebase
- **Signed receipts** - HMAC verification for score submissions  
- **Rate limiting** - IP and user-based request throttling
- **App Check** - Device attestation and bot protection
- **Heuristic analysis** - Anomaly detection for suspicious play patterns

## 📊 Data Model

### Firestore Collections
- `users/{uid}` - Player profiles and preferences
- `daily/{yyyyMMdd}` - Daily puzzles per game mode
- `scores/{yyyyMMdd}_{mode}_{uid}` - Player submissions
- `leaderboards/{yyyyMMdd}_{mode}` - Aggregated rankings
- `hints/{yyyyMMdd}_{mode}_{uid}` - Hint usage tracking

### Scoring System
- Base points: `[10, 6, 3, 1, 1, 1]` by attempt number
- Streak bonus: `+2 per consecutive day` (max +10)
- Perfect game bonus: Configurable via Remote Config
- Hint penalties: Deducted from final score

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.4.3+
- Firebase CLI
- Node.js 20+ (for Cloud Functions)

### Development Setup
```bash
# Clone and setup
git clone <repo-url>
cd FootyGuess/app

# Install dependencies
flutter pub get
dart run build_runner build

# Run with emulators
cd ../backend/functions
npm install
firebase emulators:start --import=../.data

# Launch app
cd ../../app  
flutter run
```

### Environment Configuration
Set your environment in `lib/core/environment.dart`:
```dart
Environment.setCurrent(AppEnvironment.development); // or staging/production
```

## 🧪 Testing Strategy

### Test Coverage
- **Unit tests** - Game logic, scoring, anti-cheat heuristics
- **Widget tests** - UI components and user flows  
- **Integration tests** - Firebase integration via emulators
- **Golden tests** - Visual regression testing
- **Load tests** - Backend performance under stress

### Running Tests
```bash
# Unit & Widget tests
flutter test

# Integration tests  
flutter test integration_test/

# Backend tests
cd backend/functions
npm test

# Golden tests (update)
flutter test --update-goldens
```

## 📱 Features

### ✅ Implemented (MVP)
- [x] App shell with navigation (GoRouter)
- [x] Firebase Authentication & Security
- [x] Data models and repositories  
- [x] Glassmorphic UI theme
- [x] Home page with game mode cards
- [x] Basic page structure for all modes

### 🚧 In Progress (Milestone 2)
- [ ] Guess the Player game implementation
- [ ] Hint system with point economy
- [ ] Daily puzzle generation
- [ ] Scoring and leaderboards
- [ ] Offline caching

### 📋 Planned Features
- [ ] All 6 game modes fully implemented
- [ ] Push notifications for daily resets
- [ ] Social features (friend challenges)
- [ ] Achievement system
- [ ] Premium hints and power-ups
- [ ] Live tournament modes

## 🛠️ Development Commands

```bash
# Code generation
dart run build_runner build --delete-conflicting-outputs

# Analyze code quality
flutter analyze --no-fatal-infos

# Format code  
dart format lib/

# Update dependencies
flutter pub upgrade --major-versions

# Build for production
flutter build appbundle  # Android
flutter build ipa        # iOS
```

## 🔧 Configuration

### Remote Config Parameters
```json
{
  "perfectBonus.guess_player": 5,
  "hints.costs": "[5, 10, 20, 30]", 
  "who_scored.timerSeconds": 20,
  "featureFlags": {
    "guess_player": true,
    "career_path": true
  },
  "economy.multiplier.global": 1.0
}
```

### Environment Variables
- `FIREBASE_PROJECT_ID` - Firebase project identifier
- `FOOTBALL_API_KEY` - External API key for live data
- `HMAC_SECRET` - Score receipt signing key

## 📈 Analytics & Monitoring

### Key Events Tracked
- `app_open` - App launch
- `mode_start` - Game session begin
- `attempt` - User guess submission  
- `hint_used` - Hint consumption
- `mode_complete` - Game completion
- `streak_updated` - Daily streak changes

### Performance Metrics
- 60fps on mid-range Android
- <1% jank over 5-minute sessions
- 99.5%+ crash-free users
- <250ms p95 Cloud Function latency

## 🌍 Privacy & GDPR

- Minimal PII collection (UID, display name only)
- EU region hosting for European users
- Data export API for user requests
- Automated deletion workflows
- Privacy policy integration

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the coding standards (run `flutter analyze`)
4. Add tests for new functionality
5. Commit changes (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use Riverpod for state management
- Implement proper error handling
- Write comprehensive tests

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Football data sourced from multiple public APIs
- UI inspiration from modern sports apps
- Community feedback and testing

---

**Built with ❤️ for football fans worldwide** ⚽
