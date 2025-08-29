import '../../../data/models/player.dart';

enum ComparisonResult {
  correct,
  partial,
  incorrect,
}

class GuessComparison {
  final ComparisonResult nationality;
  final ComparisonResult position;
  final ComparisonResult age;
  final ComparisonResult club;
  final ComparisonResult league;

  const GuessComparison({
    required this.nationality,
    required this.position,
    required this.age,
    required this.club,
    required this.league,
  });
}

class GuessAnalyzer {
  static GuessComparison compareGuess(Player guess, Player target) {
    return GuessComparison(
      nationality: _compareNationality(guess, target),
      position: _comparePosition(guess, target),
      age: _compareAge(guess, target),
      club: _compareClub(guess, target),
      league: _compareLeague(guess, target),
    );
  }

  static ComparisonResult _compareNationality(Player guess, Player target) {
    return guess.nationality == target.nationality
        ? ComparisonResult.correct
        : ComparisonResult.incorrect;
  }

  static ComparisonResult _comparePosition(Player guess, Player target) {
    if (guess.primaryPosition == target.primaryPosition) {
      return ComparisonResult.correct;
    }

    // Check if they share any positions
    final sharedPositions =
        guess.positions.where((pos) => target.positions.contains(pos)).toList();

    return sharedPositions.isNotEmpty
        ? ComparisonResult.partial
        : ComparisonResult.incorrect;
  }

  static ComparisonResult _compareAge(Player guess, Player target) {
    final guesserAge = guess.age;
    final targetAge = target.age;

    if (guesserAge == targetAge) {
      return ComparisonResult.correct;
    } else if ((guesserAge - targetAge).abs() <= 2) {
      return ComparisonResult.partial;
    } else {
      return ComparisonResult.incorrect;
    }
  }

  static ComparisonResult _compareClub(Player guess, Player target) {
    final guessCurrentClub = guess.currentClub;
    final targetCurrentClub = target.currentClub;

    if (guessCurrentClub == targetCurrentClub) {
      return ComparisonResult.correct;
    }

    // Check if they've played for any of the same clubs
    final guessClubIds = guess.clubs.map((c) => c.clubId).toSet();
    final targetClubIds = target.clubs.map((c) => c.clubId).toSet();

    final sharedClubs = guessClubIds.intersection(targetClubIds);

    return sharedClubs.isNotEmpty
        ? ComparisonResult.partial
        : ComparisonResult.incorrect;
  }

  static ComparisonResult _compareLeague(Player guess, Player target) {
    final guessLeagues = guess.leagues.toSet();
    final targetLeagues = target.leagues.toSet();

    final sharedLeagues = guessLeagues.intersection(targetLeagues);

    if (sharedLeagues.isNotEmpty) {
      // Check if they're currently in the same league
      // This would need club-to-league mapping, for now assume partial
      return ComparisonResult.partial;
    }

    return ComparisonResult.incorrect;
  }

  static String getAgeHint(int guessAge, int targetAge) {
    if (guessAge == targetAge) return '✓';
    if (guessAge < targetAge) return '↑';
    return '↓';
  }
}
