/// App-wide constants and configuration
class AppConstants {
  // App Info
  static const String appName = 'FootyGuess';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String dailyCollection = 'daily';
  static const String scoresCollection = 'scores';
  static const String leaderboardsCollection = 'leaderboards';
  static const String endlessSeedsCollection = 'endlessSeeds';
  static const String hintsCollection = 'hints';
  static const String adminCollection = 'admin';

  // Game Modes
  static const String guessPlayerMode = 'guess_player';
  static const String careerPathMode = 'career_path';
  static const String whoScoredMode = 'who_scored';
  static const String tenableMode = 'tenable';
  static const String missingXiMode = 'missing_xi';

  // Scoring
  static const List<int> baseScoreByAttempt = [10, 6, 3, 1, 1, 1];
  static const int maxStreakBonus = 10;
  static const int streakBonusPerDay = 2;

  // Limits
  static const int maxAttemptsPerGame = 6;
  static const int maxGuesses = 6;
  static const int maxDailyCacheSize = 50;
  static const int whoScoredTimerSeconds = 20;
  static const int maxStrikesTenable = 3;

  // Hint Costs (default, overridden by Remote Config)
  static const List<int> defaultHintCosts = [5, 10, 20, 30];

  // Rate Limiting
  static const int maxAttemptsPerMinute = 10;
  static const int minReactionTimeMs = 500;

  // Time Zones
  static const String utcTimeZone = 'UTC';

  // Analytics Events
  static const String appOpenEvent = 'app_open';
  static const String loginCompleteEvent = 'login_complete';
  static const String modeStartEvent = 'mode_start';
  static const String attemptEvent = 'attempt';
  static const String hintUsedEvent = 'hint_used';
  static const String modeCompleteEvent = 'mode_complete';
  static const String streakUpdatedEvent = 'streak_updated';
  static const String shareClickedEvent = 'share_clicked';
}
