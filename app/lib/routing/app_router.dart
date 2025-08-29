import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/daily/pages/home_page.dart';
import '../features/guess_player/pages/guess_player_page.dart';
import '../features/career_path/pages/career_path_page.dart';
import '../features/who_scored/pages/who_scored_page.dart';
import '../features/tenable/pages/tenable_page_new.dart';
import '../features/missing_xi/pages/missing_xi_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/leaderboard/pages/leaderboard_page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/guess-player',
        name: 'guess-player',
        builder: (context, state) => const GuessPlayerPage(),
      ),
      GoRoute(
        path: '/career-path',
        name: 'career-path',
        builder: (context, state) => const CareerPathPage(),
      ),
      GoRoute(
        path: '/who-scored',
        name: 'who-scored',
        builder: (context, state) => const WhoScoredPage(),
      ),
      GoRoute(
        path: '/tenable',
        name: 'tenable',
        builder: (context, state) => const TenablePageNew(),
      ),
      GoRoute(
        path: '/missing-xi',
        name: 'missing-xi',
        builder: (context, state) => const MissingXiPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/leaderboard',
        name: 'leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.error}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ),
  );
}
