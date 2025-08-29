import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/environment.dart';
import 'core/providers/optimized_data_providers.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment
  Environment.setCurrent(AppEnvironment.development);

  // print('Starting FootyGuess app...');

  runApp(
    const ProviderScope(
      child: FootyGuessApp(),
    ),
  );

  // print('FootyGuess: App started successfully');
}

class FootyGuessApp extends ConsumerWidget {
  const FootyGuessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('FootyGuessApp: Building app widget...');

    final router = ref.watch(appRouterProvider);
    // print('FootyGuessApp: Router created successfully');

    // Preload data in background for instant game loading
    ref.watch(dataPreloadProvider);

    return MaterialApp.router(
      title: 'FootyGuess',
      debugShowCheckedModeBanner: Environment.showDebugBanner,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
