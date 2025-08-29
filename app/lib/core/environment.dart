/// Environment configuration for different builds
enum AppEnvironment { development, staging, production }

class Environment {
  static AppEnvironment _current = AppEnvironment.development;

  static AppEnvironment get current => _current;

  static void setCurrent(AppEnvironment env) {
    _current = env;
  }

  static bool get isDevelopment => _current == AppEnvironment.development;
  static bool get isStaging => _current == AppEnvironment.staging;
  static bool get isProduction => _current == AppEnvironment.production;

  // Firebase Configuration
  static String get firebaseProjectId {
    switch (_current) {
      case AppEnvironment.development:
        return 'footyguess-dev';
      case AppEnvironment.staging:
        return 'footyguess-staging';
      case AppEnvironment.production:
        return 'footyguess-prod';
    }
  }

  // API Configuration
  static String get functionsRegion {
    switch (_current) {
      case AppEnvironment.development:
        return 'us-central1'; // Default for emulator
      case AppEnvironment.staging:
      case AppEnvironment.production:
        return 'europe-west1'; // EU region for GDPR
    }
  }

  // Feature Flags
  static bool get enableAnalytics => isStaging || isProduction;
  static bool get enableCrashlytics => isProduction;
  static bool get enableAppCheck => isStaging || isProduction;
  static bool get useEmulators => isDevelopment;

  // Debug Settings
  static bool get showDebugBanner => isDevelopment;
  static bool get enableDebugLogs => isDevelopment || isStaging;

  // External API Configuration
  static String get footballApiBaseUrl {
    switch (_current) {
      case AppEnvironment.development:
        return 'https://api.football-data.org/v4';
      case AppEnvironment.staging:
      case AppEnvironment.production:
        return 'https://api.football-data.org/v4';
    }
  }

  // Rate Limiting (per environment)
  static int get maxRequestsPerMinute {
    switch (_current) {
      case AppEnvironment.development:
        return 100; // Higher for testing
      case AppEnvironment.staging:
        return 60;
      case AppEnvironment.production:
        return 30; // Stricter for production
    }
  }
}
