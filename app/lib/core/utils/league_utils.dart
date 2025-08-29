class LeagueUtils {
  // Map of league names to their display abbreviations
  static const Map<String, String> leagueAbbreviations = {
    'Premier League': 'PL',
    'La Liga': 'LL',
    'Serie A': 'SA',
    'Bundesliga': 'BL',
    'Ligue 1': 'L1',
    'Saudi Pro League': 'SPL',
    'MLS': 'MLS',
    'Eredivisie': 'ED',
    'Liga Portugal': 'LP',
    'Primeira Liga': 'PL',
  };

  // Map of league names to their emoji flags
  static const Map<String, String> leagueFlags = {
    'Premier League': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    'La Liga': '🇪🇸',
    'Serie A': '🇮🇹',
    'Bundesliga': '🇩🇪',
    'Ligue 1': '🇫🇷',
    'Saudi Pro League': '🇸🇦',
    'MLS': '🇺🇸',
    'Eredivisie': '🇳🇱',
    'Liga Portugal': '🇵🇹',
    'Primeira Liga': '🇵🇹',
  };

  // Map of country names to their flag emojis
  static const Map<String, String> countryFlags = {
    'Argentina': '🇦🇷',
    'Portugal': '🇵🇹',
    'Brazil': '🇧🇷',
    'France': '🇫🇷',
    'Norway': '🇳🇴',
    'Belgium': '🇧🇪',
    'Croatia': '🇭🇷',
    'Netherlands': '🇳🇱',
    'Egypt': '🇪🇬',
    'Poland': '🇵🇱',
    'Senegal': '🇸🇳',
    'Spain': '🇪🇸',
    'England': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    'Germany': '🇩🇪',
    'Nigeria': '🇳🇬',
    'Georgia': '🇬🇪',
    'Scotland': '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
    'Morocco': '🇲🇦',
    'Italy': '🇮🇹',
    'Slovenia': '🇸🇮',
    'Costa Rica': '🇨🇷',
    'Wales': '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
    'Denmark': '🇩🇰',
    'Sweden': '🇸🇪',
    'Finland': '🇫🇮',
    'Ukraine': '🇺🇦',
    'Czech Republic': '🇨🇿',
    'Austria': '🇦🇹',
    'Switzerland': '🇨🇭',
    'Turkey': '🇹🇷',
    'Serbia': '🇷🇸',
    'Colombia': '🇨🇴',
    'Uruguay': '🇺🇾',
    'Chile': '🇨🇱',
    'Mexico': '🇲🇽',
    'USA': '🇺🇸',
    'Canada': '🇨🇦',
    'Japan': '🇯🇵',
    'South Korea': '🇰🇷',
    'Australia': '🇦🇺',
    'Algeria': '🇩🇿',
    'Tunisia': '🇹🇳',
    'Ghana': '🇬🇭',
    'Cameroon': '🇨🇲',
    'Ivory Coast': '🇨🇮',
    'Mali': '🇲🇱',
    'Burkina Faso': '🇧🇫',
  };

  /// Get the flag emoji for a country
  static String getCountryFlag(String countryName) {
    return countryFlags[countryName] ?? countryName;
  }

  /// Get the flag emoji for a league
  static String getLeagueFlag(String leagueName) {
    return leagueFlags[leagueName] ?? leagueName;
  }

  /// Get the abbreviation for a league
  static String getLeagueAbbreviation(String leagueName) {
    return leagueAbbreviations[leagueName] ?? leagueName;
  }

  /// Get a compact display for league (flag + abbreviation)
  static String getLeagueDisplay(String leagueName) {
    final flag = getLeagueFlag(leagueName);
    final abbrev = getLeagueAbbreviation(leagueName);
    return '$flag $abbrev';
  }
}
