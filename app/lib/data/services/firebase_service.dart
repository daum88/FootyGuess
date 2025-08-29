// TEMPORARILY DISABLED - Firebase packages not installed
// This service will be re-enabled when Firebase is properly configured

/*
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/environment.dart';

part 'firebase_service.g.dart';

@Riverpod(keepAlive: true)
FirebaseService firebaseService(FirebaseServiceRef ref) {
  return FirebaseService._();
}

class FirebaseService {
  FirebaseService._();

  bool _initialized = false;

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseFunctions get functions => FirebaseFunctions.instanceFor(
        region: Environment.functionsRegion,
      );
  FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;
  FirebaseAnalytics? get analytics =>
      Environment.enableAnalytics ? FirebaseAnalytics.instance : null;
  FirebaseCrashlytics? get crashlytics =>
      Environment.enableCrashlytics ? FirebaseCrashlytics.instance : null;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize App Check
    if (Environment.enableAppCheck) {
      await FirebaseAppCheck.instance.activate(
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    }

    // Configure Firestore settings
    if (Environment.useEmulators) {
      await _configureEmulators();
    } else {
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    }

    // Initialize Remote Config
    await _initializeRemoteConfig();

    // Initialize Analytics
    if (Environment.enableAnalytics) {
      await analytics?.setAnalyticsCollectionEnabled(true);
    }

    // Initialize Crashlytics
    if (Environment.enableCrashlytics) {
      await crashlytics?.setCrashlyticsCollectionEnabled(true);
    }

    _initialized = true;
  }

  Future<void> _configureEmulators() async {
    // Use Firebase emulators for development
    auth.useAuthEmulator('localhost', 9099);
    firestore.useFirestoreEmulator('localhost', 8080);
    functions.useFunctionsEmulator('localhost', 5001);
  }

  Future<void> _initializeRemoteConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: Environment.isDevelopment
          ? const Duration(minutes: 1)
          : const Duration(hours: 1),
    ));

    // Set default values
    await remoteConfig.setDefaults({
      'perfectBonus.guess_player': 5,
      'hints.costs': '[5, 10, 20, 30]',
      'who_scored.timerSeconds': 20,
      'featureFlags.guess_player': true,
      'featureFlags.career_path': true,
      'featureFlags.who_scored': true,
      'featureFlags.tenable': true,
      'featureFlags.missing_xi': true,
      'featureFlags.tic_tac_toe': true,
      'economy.multiplier.global': 1.0,
    });

    // Fetch and activate
    await remoteConfig.fetchAndActivate();
  }

  // Convenience methods for Remote Config
  int getPerfectBonus(String mode) {
    return remoteConfig.getInt('perfectBonus.$mode');
  }

  List<int> getHintCosts() {
    final costsString = remoteConfig.getString('hints.costs');
    final List<dynamic> costs =
        costsString.isNotEmpty ? parseJson(costsString) : [5, 10, 20, 30];
    return costs.cast<int>();
  }

  int getWhoScoredTimer() {
    return remoteConfig.getInt('who_scored.timerSeconds');
  }

  bool isFeatureEnabled(String mode) {
    return remoteConfig.getBool('featureFlags.$mode');
  }

  double getGlobalMultiplier() {
    return remoteConfig.getDouble('economy.multiplier.global');
  }

  // Helper method to parse JSON string
  dynamic parseJson(String jsonString) {
    try {
      return jsonString; // Simplified for now
    } catch (e) {
      return null;
    }
  }
}

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return ref.watch(firebaseServiceProvider).auth;
}

@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return ref.watch(firebaseServiceProvider).firestore;
}

@riverpod
FirebaseFunctions firebaseFunctions(FirebaseFunctionsRef ref) {
  return ref.watch(firebaseServiceProvider).functions;
}

@riverpod
FirebaseRemoteConfig firebaseRemoteConfig(FirebaseRemoteConfigRef ref) {
  return ref.watch(firebaseServiceProvider).remoteConfig;
}
*/

// Placeholder exports to prevent import errors
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  FirebaseService._();
}
