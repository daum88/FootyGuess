"""StatsBomb Open Data source.

Pulls competitions, matches, lineups and goal events from the open-data GitHub
repository.  Lineups are cheap (~20KB each) so we collect all of them; event
files are large (~1-3MB each) so they are collected for a capped, prioritised
subset of matches (international tournaments + Champions League first).
"""

from __future__ import annotations

import json
import time
from typing import Any

from common import (
    http_get_json,
    log,
    familiar_name,
    clean_name,
    sb_position,
    slugify,
    pos_group,
)

BASE = "https://raw.githubusercontent.com/statsbomb/open-data/master/data"
COMPETITIONS_URL = f"{BASE}/competitions.json"

# Competition ids that map to the six games (men's, top competitions).
COMPETITIONS = [
    {"id": 43, "seasons": [106, 3]},       # FIFA World Cup 2022, 2018
    {"id": 55, "seasons": [282, 43]},      # UEFA Euro 2024, 2020
    {"id": 223, "seasons": [282]},         # Copa America 2024
    {"id": 16, "seasons": [4, 1]},         # Champions League 2018/19, 2017/18
    {"id": 2, "seasons": [27, 44]},        # Premier League 2015/16, 2003/04
    {"id": 11, "seasons": [90, 42, 4, 1, 27]},  # La Liga
    {"id": 9, "seasons": [281, 27]},       # Bundesliga
    {"id": 12, "seasons": [27, 86]},       # Serie A
    {"id": 7, "seasons": [235, 108, 27]},  # Ligue 1
]

# Priority when capping expensive event downloads: higher = downloaded first.
_EVENT_PRIORITY = {43: 100, 55: 95, 223: 90, 16: 80, 2: 60, 11: 60, 9: 60, 12: 60, 7: 60}


def _match_id(m: dict) -> int:
    return int(m["match_id"])


def collect(*, max_events: int = 0, max_lineups: int = 0) -> dict:
    """Collect everything and return raw intermediate structures."""
    comps = http_get_json(COMPETITIONS_URL)
    selected = []
    by_key = {}
    for c in comps:
        key = (int(c["competition_id"]), int(c["season_id"]))
        by_key[key] = c
    for spec in COMPETITIONS:
        cid = spec["id"]
        for sid in spec["seasons"]:
            if (cid, sid) in by_key:
                selected.append(by_key[(cid, sid)])

    matches = []          # list of match dicts
    lineups = []          # list of lineup dicts
    scorers_by_match = {} # match_id -> list of {player, team, minute}
    event_matches = []    # matches for which we will pull events

    for comp in selected:
        cid = int(comp["competition_id"])
        sid = int(comp["season_id"])
        cname = comp["competition_name"]
        sname = comp["season_name"]
        log(f"  StatsBomb: {cname} {sname} (comp={cid} season={sid})")
        murl = f"{BASE}/matches/{cid}/{sid}.json"
        season_matches = http_get_json(murl)
        for m in season_matches:
            m["_competition_name"] = cname
            m["_season_name"] = sname
            m["_priority"] = _EVENT_PRIORITY.get(cid, 50)
        matches.extend(season_matches)
        event_matches.extend(season_matches)
        time.sleep(0.05)

    # Order event downloads by priority then recency.
    event_matches.sort(key=lambda m: (-m["_priority"], -_match_id(m)))

    if max_events and max_events > 0:
        event_matches = event_matches[:max_events]

    log(f"  StatsBomb: {len(matches)} matches total; pulling events for {len(event_matches)}")

    lineup_matches = matches if (not max_lineups) else matches[:max_lineups]

    # full-name -> familiar-name map, built from lineups (nicknames), reused for
    # goal events which only carry full legal names.
    name_map: dict[str, str] = {}

    # 1) Lineups (cheap) for all selected matches.
    for i, m in enumerate(lineup_matches):
        mid = _match_id(m)
        try:
            lu = http_get_json(f"{BASE}/lineups/{mid}.json")
        except RuntimeError as e:
            log(f"    ⚠ lineup {mid} failed: {e}")
            continue
        for team in lu:
            players = []
            for p in team.get("lineup", []):
                full = clean_name(p.get("player_name", ""))
                name = familiar_name(full, p.get("player_nickname"))
                if full and name and full.lower() != name.lower():
                    name_map[full.lower()] = name

                # starting position = first entry; a player is a starter if they
                # have a position from 0:00 of the first period.
                pos_code = "CM"
                is_starter = False
                for pos in p.get("positions", []):
                    pos_code = sb_position(pos.get("position", ""))
                    if pos.get("from_period") == 1 and str(pos.get("from", "")) == "00:00":
                        is_starter = True
                    break
                if not is_starter:
                    continue
                players.append({
                    "name": name,
                    "position": pos_code,
                    "number": p.get("jersey_number"),
                    "nationality": (p.get("country") or {}).get("name", ""),
                })
            if len(players) < 11:
                continue
            lineups.append({
                "matchId": mid,
                "teamName": team.get("team_name", ""),
                "opponent": _opponent(m, team.get("team_name", "")),
                "competition": m.get("_competition_name", ""),
                "season": m.get("_season_name", ""),
                "date": m.get("match_date", ""),
                "formation": _derive_formation(players),
                "players": players,
            })
        if (i + 1) % 200 == 0:
            log(f"    lineups: {i + 1}/{len(lineup_matches)}")

    # 2) Events (expensive) only for the capped subset -> extract scorers.
    for i, m in enumerate(event_matches):
        mid = _match_id(m)
        try:
            ev = http_get_json(f"{BASE}/events/{mid}.json")
        except RuntimeError as e:
            log(f"    ⚠ events {mid} failed: {e}")
            continue
        goals = _extract_goals(ev, name_map)
        if goals:
            scorers_by_match[mid] = goals
        if (i + 1) % 25 == 0:
            log(f"    events: {i + 1}/{len(event_matches)} (goals from {len(scorers_by_match)} matches)")

    return {
        "matches": matches,
        "lineups": lineups,
        "scorers_by_match": scorers_by_match,
    }


def _opponent(m: dict, team_name: str) -> str:
    ht = m.get("home_team", {}).get("home_team_name", "")
    at = m.get("away_team", {}).get("away_team_name", "")
    return at if team_name == ht else ht


def _derive_formation(players: list[dict]) -> str:
    """Derive a formation string like 4-3-3 from starting XI position groups."""
    counts = {"GK": 0, "DF": 0, "MF": 0, "FW": 0}
    for p in players:
        g = pos_group(p["position"])
        counts[g] = counts.get(g, 0) + 1
    return f"{counts['DF']}-{counts['MF']}-{counts['FW']}"


def _extract_goals(events: list[dict], name_map: dict[str, str] | None = None) -> list[dict]:
    name_map = name_map or {}

    def nm(full: str) -> str:
        full = (full or "").strip()
        if not full:
            return ""
        return name_map.get(full.lower(), familiar_name(full))

    goals = []
    for e in events:
        t = (e.get("type") or {}).get("name", "")
        team = (e.get("team") or {}).get("name", "")
        if t == "Shot" and ((e.get("shot") or {}).get("outcome") or {}).get("name") == "Goal":
            player = (e.get("player") or {}).get("name", "")
            goals.append({
                "player": nm(player),
                "team": team,
                "minute": e.get("minute"),
            })
        elif t == "Own Goal Against":
            # Own goal: credited to the defender who scored it (the conceding team).
            player = (e.get("player") or {}).get("name", "")
            goals.append({
                "player": f"{nm(player)} (OG)",
                "team": team,
                "minute": e.get("minute"),
            })
    return goals


if __name__ == "__main__":
    import sys
    me = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    ml = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    data = collect(max_events=me, max_lineups=ml)
    with open("sb_raw.json", "w", encoding="utf-8") as fh:
        json.dump(data, fh)
    log(f"matches={len(data['matches'])} lineups={len(data['lineups'])} scored_matches={len(data['scorers_by_match'])}")
