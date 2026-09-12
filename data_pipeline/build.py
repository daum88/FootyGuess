"""Build canonical FootyGuess data files from all sources.

Produces (into app/assets/data/):
  players.json  - unified player database
  matches.json  - historic matches with scorers (Who Scored)
  lineups.json  - real team lineups + formations (Missing XI)
  clubs.json    - club database
  tenable.json  - generated top-N categories (Tenable)

Run:  python3 build.py [--max-events N] [--max-careers N]
"""

from __future__ import annotations

import argparse
import csv
import datetime as _dt
import io
import json
import os
import sys
from collections import Counter, defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from common import log, slugify, clean_name  # noqa: E402
import statsbomb  # noqa: E402
import thesportsdb  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS = os.path.join(ROOT, "app", "assets", "data")

CSV_PATH = os.path.join(ASSETS, "football_players_enhanced.csv")
CAREER_PATH = os.path.join(ASSETS, "career_path_data.json")
WHOSCORED_PATH = os.path.join(ASSETS, "who_scored_data.json")


def now_iso() -> str:
    return _dt.datetime.now().isoformat(timespec="seconds")


# ---------------------------------------------------------------------------
# Source loaders
# ---------------------------------------------------------------------------

def load_csv_players() -> list[dict]:
    out = []
    with open(CSV_PATH, encoding="utf-8") as fh:
        for row in csv.DictReader(fh):
            name = clean_name(row.get("name", ""))
            if not name:
                continue
            age = None
            try:
                age = int(float(row.get("age", "0")))
            except (TypeError, ValueError):
                age = None
            out.append({
                "name": name,
                "nationality": row.get("nationality", ""),
                "club": clean_name(row.get("club", "")),
                "league": row.get("league", ""),
                "position": row.get("position", ""),
                "age": age,
            })
    return out


def load_career_players() -> dict[str, list[dict]]:
    if not os.path.exists(CAREER_PATH):
        return {}
    with open(CAREER_PATH, encoding="utf-8") as fh:
        data = json.load(fh)
    careers: dict[str, list[dict]] = {}
    for p in data.get("players", []):
        name = clean_name(p.get("name", ""))
        if not name:
            continue
        parsed = []
        for c in p.get("career", []):
            sy, ey = parse_years(c.get("years", ""))
            parsed.append({
                "club": clean_name(c.get("club", "")),
                "league": c.get("league", ""),
                "startYear": sy,
                "endYear": ey,
                "isLoan": False,
            })
        if parsed:
            careers[slugify(name)] = parsed
    return careers


def load_whoscored_matches() -> list[dict]:
    if not os.path.exists(WHOSCORED_PATH):
        return []
    with open(WHOSCORED_PATH, encoding="utf-8") as fh:
        data = json.load(fh)
    out = []
    for m in data.get("matches", []):
        teams = (m.get("teams") or "").split(" vs ")
        if len(teams) != 2:
            continue
        home, away = teams[0].strip(), teams[1].strip()
        hs, as_ = parse_score(m.get("score", ""))
        scorers = []
        for s in m.get("scorers", []) or []:
            name, goals = parse_scorer(s)
            scorers.append({"player": name, "team": None, "minute": None, "goals": goals})
        out.append({
            "id": slugify(m.get("match", "") or f"{home}-{away}-{m.get('date','')}"),
            "competition": m.get("match", ""),
            "season": None,
            "date": m.get("date", ""),
            "homeTeam": home,
            "awayTeam": away,
            "homeScore": hs,
            "awayScore": as_,
            "scorers": scorers,
        })
    return out


def parse_years(s: str) -> tuple[int | None, int | None]:
    s = (s or "").strip()
    if not s:
        return None, None
    a, sep, b = s.partition("-")
    a, b = a.strip(), b.strip()
    sy = int(a) if a.isdigit() else None
    if b.lower().startswith("present") or b.lower().startswith("current"):
        return sy, None
    ey = int(b) if b.isdigit() else None
    return sy, ey


def parse_score(s: str) -> tuple[int, int]:
    s = (s or "").split("(")[0].strip()  # drop " (4-2 pens)"
    parts = s.split("-")
    try:
        return int(parts[0]), int(parts[1])
    except (ValueError, IndexError):
        return 0, 0


def parse_scorer(s: str) -> tuple[str, int]:
    """'Lionel Messi (2)' -> ('Lionel Messi', 2)."""
    s = (s or "").strip()
    goals = 1
    if s.endswith(")") and "(" in s:
        head, _, tail = s.rpartition("(")
        try:
            goals = int(tail.rstrip(")"))
            s = head.strip()
        except ValueError:
            pass
    return clean_name(s), goals


# ---------------------------------------------------------------------------
# Merge logic
# ---------------------------------------------------------------------------

def merge_players(csv_players, career_map, sb_players, tsdb) -> list[dict]:
    """Merge all player sources into one canonical list."""
    players: dict[str, dict] = {}

    def entry(key: str) -> dict:
        if key not in players:
            players[key] = {
                "id": key,
                "name": "",
                "alternateNames": [],
                "nationality": "",
                "dateOfBirth": None,
                "positions": [],
                "primaryPosition": "CM",
                "currentClub": "",
                "currentLeague": "",
                "career": [],
                "appearances": 0,
                "source": set(),
            }
        return players[key]

    # 1) CSV base (has league + age + club).
    for p in csv_players:
        key = slugify(p["name"])
        e = entry(key)
        e["name"] = p["name"]
        if p["nationality"]:
            e["nationality"] = p["nationality"]
        if p["club"]:
            e["currentClub"] = p["club"]
        if p["league"]:
            e["currentLeague"] = p["league"]
        if p["position"]:
            e["positions"] = _uniq([p["position"]] + e["positions"])
        if p["age"] and not e["dateOfBirth"]:
            e["dateOfBirth"] = f"{_dt.date.today().year - p['age']}-01-01"
        e["source"].add("csv")

    # 2) Career history (primary career source).
    for key, career in career_map.items():
        e = entry(key)
        if not e["name"]:
            e["name"] = career[0].get("club", key)  # placeholder, fixed below
        e["career"] = career
        e["source"].add("career")
        if not e["currentClub"] and career:
            last = career[-1]
            e["currentClub"] = last["club"]
            if last["league"]:
                e["currentLeague"] = last["league"]

    # 3) StatsBomb lineups -> breadth + real clubs + positions + nationality.
    for key, info in sb_players.items():
        e = entry(key)
        if info.get("name"):
            e["name"] = info["name"]
        if info["nationality"]:
            e["nationality"] = info["nationality"]
        if info.get("positions"):
            e["positions"] = _uniq(e["positions"] + info["positions"])
        if info["club"] and not e["currentClub"]:
            e["currentClub"] = info["club"]
        e["appearances"] = e.get("appearances", 0) + info.get("appearances", 0)
        e["source"].add("statsbomb")

    # 4) TheSportsDB enrichment (DOB, photo, better positions, careers).
    for key, p in tsdb["players"].items():
        e = entry(key)
        if not e["name"]:
            e["name"] = p["name"]
        if p.get("nationality"):
            e["nationality"] = p["nationality"]
        if p.get("dateOfBirth"):
            e["dateOfBirth"] = p["dateOfBirth"]
        if p.get("positions"):
            e["positions"] = _uniq(e["positions"] + p["positions"])
        if p.get("currentClub"):
            e["currentClub"] = p["currentClub"]
        if p.get("currentLeague"):
            e["currentLeague"] = p["currentLeague"]
        if p.get("photo"):
            e["photo"] = p["photo"]
        e["source"].add("thesportsdb")
        if not e["career"]:
            e["career"] = tsdb["careers"].get(key, [])

    # Finalise.
    result = []
    for key, e in players.items():
        if not e["name"]:
            continue
        e["id"] = key
        e["source"] = sorted(e["source"])
        e["positions"] = e["positions"] or ["CM"]
        e["primaryPosition"] = e["positions"][0]
        e["alternateNames"] = e.get("alternateNames", [])
        result.append(e)

    log(f"  Merge: {len(result)} unique players")
    return result


def _uniq(items: list[str]) -> list[str]:
    seen, out = set(), []
    for it in items:
        it = (it or "").strip()
        if it and it.lower() not in seen:
            seen.add(it.lower())
            out.append(it)
    return out


def build_matches(sb_matches, sb_scorers, ws_matches) -> list[dict]:
    matches = []
    seen = set()
    for m in sb_matches:
        mid = m["match_id"]
        scorers = sb_scorers.get(mid, [])
        home = m.get("home_team", {}).get("home_team_name", "")
        away = m.get("away_team", {}).get("away_team_name", "")
        rec = {
            "id": f"sb-{mid}",
            "competition": m.get("_competition_name", ""),
            "season": m.get("_season_name", ""),
            "date": m.get("match_date", ""),
            "homeTeam": home,
            "awayTeam": away,
            "homeScore": m.get("home_score", 0),
            "awayScore": m.get("away_score", 0),
            "scorers": scorers,
        }
        matches.append(rec)
        seen.add(rec["id"])
    for m in ws_matches:
        if m["id"] in seen:
            continue
        matches.append(m)
        seen.add(m["id"])
    return matches


def build_tenable(matches: list[dict], lineups: list[dict]) -> list[dict]:
    cats = []

    # a) Top scorers per competition+season.
    groups = defaultdict(lambda: Counter())
    for m in matches:
        if not m["scorers"]:
            continue
        gkey = f"{m['competition']} {m['season']}".strip()
        for s in m["scorers"]:
            name = clean_name(s["player"]).replace(" (OG)", "")
            if name and not name.lower().startswith("unknown"):
                groups[gkey][name] += s.get("goals", 1) or 1

    for gkey, counter in groups.items():
        top = counter.most_common(10)
        if len(top) < 5:
            continue
        cats.append({
            "id": f"top-scorers-{slugify(gkey)}",
            "question": f"Top {len(top)} goalscorers — {gkey}",
            "description": f"Most goals in {gkey}",
            "answers": [
                {"answer": name, "value": goals, "position": i + 1}
                for i, (name, goals) in enumerate(top)
            ],
        })

    # b) Most appearances across all lineups.
    apps = Counter()
    for t in lineups:
        for p in t["players"]:
            apps[p["name"]] += 1
    top_apps = apps.most_common(10)
    if len(top_apps) >= 5:
        cats.append({
            "id": "most-appearances",
            "question": "Top 10 players by appearances",
            "description": "Most appearances in the collected match data",
            "answers": [
                {"answer": name, "value": n, "position": i + 1}
                for i, (name, n) in enumerate(top_apps)
            ],
        })

    # c) Most featured clubs.
    club_counter = Counter()
    for t in lineups:
        club_counter[t["teamName"]] += 1
    top_clubs = club_counter.most_common(10)
    if len(top_clubs) >= 5:
        cats.append({
            "id": "most-featured-clubs",
            "question": "Top 10 clubs by matches played",
            "description": "Clubs that appear most in the collected match data",
            "answers": [
                {"answer": name, "value": n, "position": i + 1}
                for i, (name, n) in enumerate(top_clubs)
            ],
        })

    return cats


def build_clubs(tsdb_clubs: dict, lineups: list[dict]) -> list[dict]:
    clubs = {k: dict(v) for k, v in tsdb_clubs.items()}
    for t in lineups:
        key = slugify(t["teamName"])
        if key not in clubs:
            clubs[key] = {"id": key, "name": t["teamName"], "league": "", "country": ""}
    return sorted(clubs.values(), key=lambda c: c["name"])


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--max-events", type=int, default=250, help="StatsBomb matches to pull scorer events for (0 = none)")
    ap.add_argument("--max-lineups", type=int, default=0, help="StatsBomb matches to pull lineups for (0 = all)")
    ap.add_argument("--max-careers", type=int, default=0, help="TheSportsDB player careers to fetch (0 = skip)")
    ap.add_argument("--skip-thesportsdb", action="store_true")
    args = ap.parse_args()

    t0 = _dt.datetime.now()
    log("=== FootyGuess data pipeline ===")

    # StatsBomb
    log("[1/4] StatsBomb: matches, lineups, scorers")
    sb = statsbomb.collect(max_events=args.max_events, max_lineups=args.max_lineups)

    # Build a player-frequency map from lineups.
    sb_players: dict[str, dict] = {}
    for t in sb["lineups"]:
        for p in t["players"]:
            key = slugify(p["name"])
            info = sb_players.setdefault(key, {
                "name": p["name"], "appearances": 0,
                "nationality": "", "positions": [], "club": "",
            })
            info["appearances"] += 1
            if p.get("nationality"):
                info["nationality"] = p["nationality"]
            if p.get("position") and p["position"] not in info["positions"]:
                info["positions"].append(p["position"])
            info["club"] = t["teamName"]
    sb_players = {k: v for k, v in sb_players.items()}

    # TheSportsDB
    tsdb = {"players": {}, "careers": {}, "clubs": {}}
    if not args.skip_thesportsdb:
        log("[2/4] TheSportsDB: players, clubs, careers")
        try:
            tsdb = thesportsdb.collect(max_careers=args.max_careers)
        except RuntimeError as e:
            log(f"    ⚠ TheSportsDB collection failed, continuing without it: {e}")
            tsdb = {"players": {}, "careers": {}, "clubs": {}}
    else:
        log("[2/4] TheSportsDB: skipped")

    # Merge
    log("[3/4] Merging sources")
    csv_players = load_csv_players()
    career_map = load_career_players()
    ws_matches = load_whoscored_matches()

    players = merge_players(csv_players, career_map, sb_players, tsdb)
    matches = build_matches(sb["matches"], sb["scorers_by_match"], ws_matches)
    lineups = sb["lineups"]
    tenable = build_tenable(matches, lineups)
    clubs = build_clubs(tsdb["clubs"], lineups)

    log(f"  players={len(players)} matches={len(matches)} lineups={len(lineups)} "
        f"clubs={len(clubs)} tenable_categories={len(tenable)}")

    # Write canonical files
    log("[4/4] Writing canonical JSON to app/assets/data/")
    os.makedirs(ASSETS, exist_ok=True)

    _write("players.json", {
        "metadata": _meta("Unified football player database", len(players), ["csv", "career_path", "statsbomb", "thesportsdb"]),
        "players": players,
    })
    _write("matches.json", {
        "metadata": _meta("Historic matches with scorers (Who Scored)", len(matches), ["statsbomb", "manual"]),
        "matches": matches,
    })
    _write("lineups.json", {
        "metadata": _meta("Real team lineups with formations (Missing XI)", len(lineups), ["statsbomb"]),
        "teams": lineups,
    })
    _write("clubs.json", {
        "metadata": _meta("Football clubs", len(clubs), ["thesportsdb", "statsbomb"]),
        "clubs": clubs,
    })
    _write("tenable.json", {
        "metadata": _meta("Top-N list categories (Tenable)", len(tenable), ["generated"]),
        "categories": tenable,
    })

    log(f"Done in {(_dt.datetime.now() - t0).total_seconds():.1f}s")


def _meta(desc: str, count: int, sources: list[str]) -> dict:
    return {
        "version": "3.0",
        "generatedAt": now_iso(),
        "description": desc,
        "total": count,
        "sources": sources,
    }


def _write(name: str, data: dict) -> None:
    path = os.path.join(ASSETS, name)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(data, fh, ensure_ascii=False)
    size = os.path.getsize(path)
    log(f"  ✓ {name} ({size/1024:.0f} KB)")


if __name__ == "__main__":
    main()
