import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/modern_theme.dart';
import 'core/environment.dart';
import 'core/providers/game_data_providers.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment
  Environment.setCurrent(AppEnvironment.development);

  // Set system UI overlay style for light theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: FootyGuessApp(),
    ),
  );
}

class FootyGuessApp extends ConsumerWidget {
  const FootyGuessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Preload canonical game data in the background for instant game loading.
    ref.watch(gameDataProvider);

    return MaterialApp.router(
      title: 'FootyGuess',
      debugShowCheckedModeBanner: Environment.showDebugBanner,
      theme: ModernTheme.lightTheme,
      routerConfig: router,
    );
  }
}
