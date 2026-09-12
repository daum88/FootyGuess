"""TheSportsDB source (free API key).

Provides player attributes (date of birth, position, nationality, photo) and,
for a capped set of players, career history via lookupformerteams.

Free tier etiquette: ~1 request per second.
"""

from __future__ import annotations

import time
from typing import Any

from common import http_get_json, log, clean_name, tsp_position, slugify, is_cached

API = "https://www.thesportsdb.com/api/v1/json/3"

LEAGUES = [
    "English Premier League",
    "Spanish La Liga",
    "German Bundesliga",
    "Italian Serie A",
    "French Ligue 1",
    "Dutch Eredivisie",
    "Portuguese Primeira Liga",
    "American Major League Soccer",
    "Saudi Pro League",
    "English League Championship",
]

_RATE = 2.2  # seconds between requests (free key is aggressive with 429s)


def _get(url: str) -> Any:
    if not is_cached(url):
        time.sleep(_RATE)
    return http_get_json(url, ttl=60 * 60 * 24 * 7, max_retries=5)  # cache 7 days


def collect(*, max_careers: int = 250) -> dict:
    players: dict[str, dict] = {}   # slug -> player
    careers: dict[str, list] = {}   # slug -> [career entry]
    clubs: dict[str, dict] = {}     # slug -> club

    for league in LEAGUES:
        log(f"  TheSportsDB: teams in {league}")
        try:
            teams_resp = _get(f"{API}/search_all_teams.php?l={league.replace(' ', '%20')}")
        except RuntimeError as e:
            log(f"    ⚠ league {league} failed: {e}")
            continue
        teams = teams_resp.get("teams") or []
        for t in teams:
            tid = t.get("idTeam")
            tname = clean_name(t.get("strTeam", ""))
            if not tid or not tname:
                continue
            clubs[slugify(tname)] = {
                "id": slugify(tname),
                "name": tname,
                "league": league,
                "country": t.get("strCountry", ""),
                "stadium": t.get("strStadium", ""),
                "founded": _int(t.get("intFormedYear")),
                "badge": t.get("strBadge", ""),
            }
            try:
                squad = _get(f"{API}/lookup_all_players.php?id={tid}")
            except RuntimeError as e:
                log(f"    ⚠ squad for {tname} failed: {e}")
                continue
            for p in squad.get("player") or []:
                name = clean_name(p.get("strPlayer", ""))
                if not name or len(name) < 3:
                    continue
                key = slugify(name)
                if key in players:
                    # keep first / most complete record
                    continue
                players[key] = {
                    "id": key,
                    "tspId": p.get("idPlayer"),
                    "name": name,
                    "nationality": p.get("strNationality", ""),
                    "dateOfBirth": p.get("dateBorn", "") or None,
                    "position": tsp_position(p.get("strPosition", "")),
                    "positions": [tsp_position(p.get("strPosition", ""))],
                    "currentClub": tname,
                    "currentLeague": league,
                    "photo": p.get("strCutout") or p.get("strThumb") or "",
                    "source": "thesportsdb",
                }

    log(f"  TheSportsDB: {len(players)} players, {len(clubs)} clubs collected")

    # Careers for the most valuable players (sorted by id for determinism; the
    # merge step can re-prioritise).  Capped because each costs one request.
    if max_careers > 0:
        ordered = sorted(players.values(), key=lambda p: p["name"])
        # Prefer players we already know are famous (best-effort heuristic):
        ordered = ordered[:max_careers]
        for i, p in enumerate(ordered):
            pid = p.get("tspId")
            if not pid:
                continue
            try:
                resp = _get(f"{API}/lookupformerteams.php?id={pid}")
                for ft in resp.get("formerteams") or []:
                    club = clean_name(ft.get("strFormerTeam", ""))
                    if not club:
                        continue
                    entry = {
                        "club": club,
                        "startYear": _year(ft.get("strJoined")),
                        "endYear": _year(ft.get("strDeparted")),
                        "isLoan": False,
                    }
                    careers.setdefault(slugify(p["name"]), []).append(entry)
            except RuntimeError as e:
                log(f"    ⚠ career for {p['name']} failed: {e}")
            if (i + 1) % 50 == 0:
                log(f"    careers: {i + 1}/{len(ordered)}")

    return {"players": players, "careers": careers, "clubs": clubs}


def _year(s: str | None) -> int | None:
    if not s:
        return None
    try:
        return int(str(s).strip()[:4])
    except ValueError:
        return None


def _int(s: str | None) -> int | None:
    try:
        return int(s)
    except (TypeError, ValueError):
        return None


if __name__ == "__main__":
    import sys, json
    mc = int(sys.argv[1]) if len(sys.argv) > 1 else 250
    data = collect(max_careers=mc)
    with open("tsdb_raw.json", "w", encoding="utf-8") as fh:
        json.dump(data, fh)
    log(f"players={len(data['players'])} careers={len(data['careers'])} clubs={len(data['clubs'])}")
