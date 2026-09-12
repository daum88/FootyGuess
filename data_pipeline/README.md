# FootyGuess Data Pipeline

Collects and merges football data from free public sources into a single set of
canonical JSON files consumed by the Flutter app (`app/assets/data/`).

## Sources

| Source | What it provides | Cost |
|---|---|---|
| **StatsBomb Open Data** (GitHub) | Real matches, starting-XI lineups + formations, and goal events (scorers + minutes) | Free, open license |
| **TheSportsDB API** (key `3`) | Player attributes (date of birth, position, nationality, photo) + career history | Free key, rate-limited |
| **football-data.co.uk / curated CSVs & JSON** | Extra player attributes (league, age) and career paths | Free |
| **Who Scored? manual dataset** | 120 curated historic matches with scorers | Bundled |

## Quick start

```bash
cd data_pipeline
python3 build.py                          # full build (all lineups + 250 scorer events + TheSportsDB)
python3 build.py --max-events 500         # more "Who Scored?" matches
python3 build.py --skip-thesportsdb       # skip the rate-limited API
```

All HTTP responses are cached in `data_pipeline/.cache/`, so re-runs are fast and
only fetch what changed. Delete `.cache/` to force a full refresh.

## Output

Writes 5 canonical files to `app/assets/data/`:

| File | Used by | Contents |
|---|---|---|
| `players.json` | Guess the Player, Career Path, Missing XI, Tenable, Who Scored | ~5,900 players |
| `matches.json` | Who Scored | ~2,300 matches (1,500 with scorers) |
| `lineups.json` | Missing XI | ~4,400 starting XIs with formations |
| `clubs.json` | Tenable, general search | ~270 clubs |
| `tenable.json` | Tenable | Top-N list categories (generated) |

## Schema

### players.json
```json
{
  "metadata": { "version": "3.0", "generatedAt": "...", "total": 5285, "sources": ["csv","career_path","statsbomb","thesportsdb"] },
  "players": [
    {
      "id": "lionel-messi",
      "name": "Lionel Messi",
      "alternateNames": [],
      "nationality": "Argentina",
      "dateOfBirth": "1987-06-24",
      "positions": ["RW", "CAM", "ST"],
      "primaryPosition": "RW",
      "currentClub": "Inter Miami",
      "currentLeague": "MLS",
      "career": [
        { "club": "Barcelona", "league": "La Liga", "startYear": 2004, "endYear": 2021, "isLoan": false }
      ],
      "appearances": 246,
      "photo": "https://...",
      "source": ["csv", "statsbomb"]
    }
  ]
}
```

### matches.json
```json
{
  "matches": [
    {
      "id": "sb-3857276",
      "competition": "FIFA World Cup",
      "season": "2022",
      "date": "2022-12-01",
      "homeTeam": "Canada", "awayTeam": "Morocco",
      "homeScore": 1, "awayScore": 2,
      "scorers": [
        { "player": "Hakim Ziyech", "team": "Morocco", "minute": 3, "goals": 1 }
      ]
    }
  ]
}
```

### lineups.json
```json
{
  "teams": [
    {
      "matchId": 3857276,
      "teamName": "Morocco",
      "opponent": "Canada",
      "competition": "FIFA World Cup",
      "season": "2022",
      "date": "2022-12-01",
      "formation": "4-3-3",
      "players": [
        { "name": "Yassine Bounou", "position": "GK", "number": 1, "nationality": "Morocco" }
      ]
    }
  ]
}
```

### clubs.json
```json
{ "clubs": [ { "id": "barcelona", "name": "Barcelona", "league": "La Liga", "country": "Spain", "stadium": "...", "founded": 1899, "badge": "https://..." } ] }
```

### tenable.json
```json
{
  "categories": [
    {
      "id": "top-scorers-fifa-world-cup-2022",
      "question": "Top 10 goalscorers — FIFA World Cup 2022",
      "description": "Most goals in FIFA World Cup 2022",
      "answers": [ { "answer": "Kylian Mbappe", "value": 9, "position": 1 } ]
    }
  ]
}
```

## Extending

- **More matches / scorers:** raise `--max-events` (each is one StatsBomb event download).
- **More competitions:** add entries to `COMPETITIONS` in `sources/statsbomb.py`.
- **More player attributes:** raise `--max-careers` in TheSportsDB (rate-limited).
- **More Tenable categories:** `build_tenable()` in `build.py` can aggregate any field.
