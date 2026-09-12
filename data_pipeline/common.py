"""Shared utilities for the FootyGuess data pipeline.

- Resilient HTTP GET with retries, timeouts and a disk cache so re-runs are fast.
- Name/position normalisation helpers.
"""

from __future__ import annotations

import hashlib
import json
import os
import sys
import time
import urllib.request
import urllib.error

CACHE_DIR = os.path.join(os.path.dirname(__file__), ".cache")
USER_AGENT = "FootyGuessDataPipeline/1.0 (football quiz data collection)"

# ---------------------------------------------------------------------------
# HTTP
# ---------------------------------------------------------------------------

def _cache_path(url: str) -> str:
    digest = hashlib.sha1(url.encode("utf-8")).hexdigest()
    return os.path.join(CACHE_DIR, digest + ".json")


def is_cached(url: str) -> bool:
    return os.path.exists(_cache_path(url))


def http_get_json(url: str, *, ttl: int = 0, max_retries: int = 3, timeout: int = 45) -> object:
    """GET ``url`` and parse it as JSON, with a disk cache.

    ``ttl`` in seconds.  0 means cache forever (data is historic / immutable).
    """
    path = _cache_path(url)
    os.makedirs(CACHE_DIR, exist_ok=True)

    if os.path.exists(path):
        age = time.time() - os.path.getmtime(path)
        if ttl == 0 or age < ttl:
            with open(path, "r", encoding="utf-8") as fh:
                return json.load(fh)

    last_err: Exception | None = None
    for attempt in range(1, max_retries + 1):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                raw = resp.read()
            data = json.loads(raw.decode("utf-8"))
            tmp = path + ".tmp"
            with open(tmp, "w", encoding="utf-8") as fh:
                json.dump(data, fh)
            os.replace(tmp, path)
            return data
        except urllib.error.HTTPError as e:
            last_err = e
            if e.code == 429:
                wait = 5 * attempt + 5
                print(f"    ⚠ rate limited (429) for {url} (retry in {wait}s)")
            else:
                wait = 2 ** attempt
                print(f"    ⚠ HTTP {e.code} attempt {attempt}/{max_retries} for {url} (retry in {wait}s)")
            time.sleep(wait)
        except (urllib.error.URLError, TimeoutError, json.JSONDecodeError) as e:
            last_err = e
            wait = 2 ** attempt
            print(f"    ⚠ attempt {attempt}/{max_retries} failed for {url}: {e} (retry in {wait}s)")
            time.sleep(wait)

    raise RuntimeError(f"Could not fetch {url}: {last_err}")


def log(msg: str) -> None:
    print(msg, flush=True)


# ---------------------------------------------------------------------------
# Position normalisation
# ---------------------------------------------------------------------------

# StatsBomb position names -> short codes used by the app.
SB_POSITION_MAP = {
    "goalkeeper": "GK",
    "right back": "RB",
    "left back": "LB",
    "center back": "CB",
    "centre back": "CB",
    "right center back": "RCB",
    "left center back": "LCB",
    "right centre back": "RCB",
    "left centre back": "LCB",
    "right wing back": "RWB",
    "left wing back": "LWB",
    "right defensive midfield": "RDM",
    "left defensive midfield": "LDM",
    "center defensive midfield": "CDM",
    "centre defensive midfield": "CDM",
    "defensive midfield": "CDM",
    "right midfield": "RM",
    "left midfield": "LM",
    "center midfield": "CM",
    "centre midfield": "CM",
    "right center midfield": "RCM",
    "left center midfield": "LCM",
    "right centre midfield": "RCM",
    "left centre midfield": "LCM",
    "right attacking midfield": "RAM",
    "left attacking midfield": "LAM",
    "center attacking midfield": "CAM",
    "centre attacking midfield": "CAM",
    "attacking midfield": "CAM",
    "right wing": "RW",
    "left wing": "LW",
    "center forward": "ST",
    "centre forward": "ST",
    "right center forward": "RST",
    "left center forward": "LST",
    "striker": "ST",
    "secondary striker": "SS",
}

# TheSportsDB position names -> short codes.
TSP_POSITION_MAP = {
    "goalkeeper": "GK",
    "right back": "RB",
    "left back": "LB",
    "center back": "CB",
    "centre back": "CB",
    "centre-back": "CB",
    "center-back": "CB",
    "right wing-back": "RWB",
    "left wing-back": "LWB",
    "defensive midfield": "CDM",
    "right midfield": "RM",
    "left midfield": "LM",
    "central midfield": "CM",
    "centre midfield": "CM",
    "midfield": "CM",
    "attacking midfield": "CAM",
    "right winger": "RW",
    "left winger": "LW",
    "right wing": "RW",
    "left wing": "LW",
    "centre-forward": "ST",
    "center-forward": "ST",
    "centre forward": "ST",
    "center forward": "ST",
    "striker": "ST",
    "forward": "ST",
    "second striker": "SS",
}


def sb_position(code: str) -> str:
    return SB_POSITION_MAP.get((code or "").strip().lower(), "CM")


def tsp_position(code: str) -> str:
    return TSP_POSITION_MAP.get((code or "").strip().lower(), "CM")


_POS_GROUP = {
    "GK": "GK",
    "RB": "DF", "LB": "DF", "CB": "DF", "RCB": "DF", "LCB": "DF",
    "RWB": "DF", "LWB": "DF", "SW": "DF",
    "CDM": "MF", "RDM": "MF", "LDM": "MF", "CM": "MF", "RCM": "MF", "LCM": "MF",
    "RM": "MF", "LM": "MF", "CAM": "MF", "RAM": "MF", "LAM": "MF",
    "RW": "FW", "LW": "FW", "ST": "FW", "RST": "FW", "LST": "FW",
    "CF": "FW", "SS": "FW",
}


def pos_group(code: str) -> str:
    return _POS_GROUP.get(code, "MF")


# ---------------------------------------------------------------------------
# Name / id helpers
# ---------------------------------------------------------------------------

def slugify(name: str) -> str:
    """Stable ASCII slug used as an entity id."""
    out = []
    for ch in name.lower().strip():
        if "a" <= ch <= "z" or "0" <= ch <= "9":
            out.append(ch)
        elif ch in " \t":
            out.append("-")
        # accented chars are transliterated conservatively
        else:
            table = {
                "á": "a", "à": "a", "â": "a", "ä": "a", "ã": "a", "å": "a",
                "é": "e", "è": "e", "ê": "e", "ë": "e",
                "í": "i", "ì": "i", "î": "i", "ï": "i",
                "ó": "o", "ò": "o", "ô": "o", "ö": "o", "õ": "o",
                "ú": "u", "ù": "u", "û": "u", "ü": "u",
                "ñ": "n", "ç": "c", "ß": "ss", "ø": "o", "æ": "ae",
                "č": "c", "š": "s", "ž": "z", "ć": "c", "đ": "d",
            }
            out.append(table.get(ch, ""))
    slug = "-".join([p for p in "".join(out).split("-") if p])
    return slug or "unknown"


def clean_name(name: str) -> str:
    return " ".join((name or "").split())


# Common full -> familiar name overrides for the most famous players (keys are
# ASCII-normalised for accent-insensitive matching).
NAME_OVERRIDES = {
    "lionel andres messi cuccittini": "Lionel Messi",
    "lionel messi": "Lionel Messi",
    "cristiano ronaldo dos santos aveiro": "Cristiano Ronaldo",
    "cristiano ronaldo": "Cristiano Ronaldo",
    "kylian mbappe lottin": "Kylian Mbappe",
    "kylian mbappe": "Kylian Mbappe",
    "neymar da silva santos junior": "Neymar",
    "neymar": "Neymar",
    "erling braut haaland": "Erling Haaland",
    "erling haaland": "Erling Haaland",
    "mohamed salah ghaly": "Mohamed Salah",
    "mohamed salah": "Mohamed Salah",
    "kevin de bruyne": "Kevin De Bruyne",
    "virgil van dijk": "Virgil van Dijk",
    "luka modric": "Luka Modric",
    "sergio ramos garcia": "Sergio Ramos",
    "gerard pique bernabeu": "Gerard Pique",
    "karim benzema": "Karim Benzema",
    "antoine griezmann": "Antoine Griezmann",
    "harry kane": "Harry Kane",
    "jude bellingham": "Jude Bellingham",
    "jude victor william bellingham": "Jude Bellingham",
    "vinicius jose paixao de oliveira junior": "Vinicius Junior",
    "vinicius junior": "Vinicius Junior",
    "rodri hernandez": "Rodri",
    "rodrigo hernandez cascante": "Rodri",
    "rodri": "Rodri",
    "kylian mbappé lottin": "Kylian Mbappe",
    "lionel andrés messi cuccittini": "Lionel Messi",
    "luka modrić": "Luka Modric",
    "sergio ramos garcía": "Sergio Ramos",
    "gerard piqué bernabéu": "Gerard Pique",
    "vinícius júnior": "Vinicius Junior",
}

# ASCII fold table for accent-insensitive lookups.
_ASCII = {
    "á": "a", "à": "a", "â": "a", "ä": "a", "ã": "a", "å": "a",
    "é": "e", "è": "e", "ê": "e", "ë": "e",
    "í": "i", "ì": "i", "î": "i", "ï": "i",
    "ó": "o", "ò": "o", "ô": "o", "ö": "o", "õ": "o",
    "ú": "u", "ù": "u", "û": "u", "ü": "u",
    "ñ": "n", "ç": "c", "ß": "ss", "ø": "o", "æ": "ae",
    "č": "c", "š": "s", "ž": "z", "ć": "c", "đ": "d",
}


def ascii_fold(s: str) -> str:
    return "".join(_ASCII.get(ch, ch) for ch in (s or "").lower())


def familiar_name(full_name: str, nickname: str | None = None) -> str:
    """Pick the most familiar display name for a player."""
    full = clean_name(full_name or "")
    key = ascii_fold(full)
    if key in NAME_OVERRIDES:
        return NAME_OVERRIDES[key]
    if nickname and clean_name(nickname) and len(clean_name(nickname)) >= 3:
        return clean_name(nickname)
    # Keep the full name; truncating legal names is unreliable.
    return full
