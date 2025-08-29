
import os
import re
import requests
from cairosvg import svg2png
import csv
import json

BADGE_DIR = 'app/assets/images/badges'
MAPPING_FILE = 'app/assets/images/badges/badge_mapping.json'
CSV_FILE = 'app/assets/data/combined_all_lineups.csv'

# Headers for requests to avoid 403 errors
HEADERS = {
    'User-Agent': 'FootyGuess Badge Downloader/1.0 (https://github.com/user/footyguess) Python/3.x'
}

def normalize_name(name):
    name = name.lower()
    name = re.sub(r'[^a-z0-9]+', '-', name)
    name = name.strip('-')
    return name

# Search Wikimedia Commons for SVG logo
def fetch_badge_url(club_name):
    # Try different search variations
    search_terms = [
        f"FC {club_name} badge",
        f"FC {club_name} logo", 
        f"FC {club_name} crest",
        f"{club_name} FC badge",
        f"{club_name} FC logo",
        f"{club_name} FC crest",
        f"{club_name} football club logo",
        f"{club_name} badge",
        f"{club_name} logo",
        f"{club_name} crest"
    ]
    
    for search_term in search_terms:
        print(f"  Searching: {search_term}")
        # Search in File namespace (namespace 6) for actual file uploads
        url = f"https://commons.wikimedia.org/w/api.php?action=query&format=json&list=search&srnamespace=6&srsearch={search_term}"
        try:
            r = requests.get(url, headers=HEADERS)
            if r.status_code == 200:
                data = r.json()
                if 'search' in data['query'] and data['query']['search']:
                    for result in data['query']['search']:
                        title = result['title']
                        # Look for SVG files first, then PNG as fallback
                        if (title.lower().endswith('.svg') or title.lower().endswith('.png')) and \
                           ('badge' in title.lower() or 'logo' in title.lower() or 'crest' in title.lower()):
                            print(f"  Found potential match: {title}")
                            # Get file URL
                            file_api = f"https://commons.wikimedia.org/w/api.php?action=query&format=json&prop=imageinfo&iiprop=url&titles={title}"
                            fr = requests.get(file_api, headers=HEADERS)
                            if fr.status_code == 200:
                                file_data = fr.json()
                                pages = file_data['query']['pages']
                                for page in pages.values():
                                    if 'imageinfo' in page and page['imageinfo']:
                                        file_url = page['imageinfo'][0]['url']
                                        print(f"  Found URL: {file_url}")
                                        return file_url
        except Exception as e:
            print(f"  Error searching {search_term}: {e}")
    
    print(f"  No badge found for {club_name}")
    return None

def download_badge(club_name, url):
    """Download badge file (SVG or PNG)"""
    # Determine file extension from URL
    if url.lower().endswith('.svg'):
        filename = f"{normalize_name(club_name)}.svg"
    elif url.lower().endswith('.png'):
        filename = f"{normalize_name(club_name)}.png"
    else:
        # Default to SVG if unknown
        filename = f"{normalize_name(club_name)}.svg"
    
    filepath = os.path.join(BADGE_DIR, filename)
    try:
        r = requests.get(url, headers=HEADERS)
        if r.status_code == 200:
            with open(filepath, 'wb') as f:
                f.write(r.content)
            return filepath
    except Exception as e:
        print(f"Error downloading {club_name}: {e}")
    return None

def convert_svg_to_png(svg_path):
    """Convert SVG to PNG using cairosvg"""
    if not svg_path.endswith('.svg'):
        return None  # Already PNG or other format
        
    png_path = svg_path.replace('.svg', '.png')
    try:
        svg2png(url=svg_path, write_to=png_path)
        return png_path
    except Exception as e:
        print(f"Error converting {svg_path}: {e}")
    return None

def extract_club_name(team_name):
    """Extract club name from formatted team name like 'barcelona_2012_13_milan4_0'"""
    if not team_name or team_name == 'team_name':
        return None
    # Split by underscore and take the first part (club name)
    parts = team_name.split('_')
    if parts:
        club_name = parts[0]
        # Capitalize first letter for better search results
        return club_name.capitalize()
    return None

def main():
    if not os.path.exists(BADGE_DIR):
        os.makedirs(BADGE_DIR)
    mapping = {}
    clubs = set()
    
    # Read CSV and extract club names
    with open(CSV_FILE, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            team_name = row.get('team_name')
            if team_name:
                club_name = extract_club_name(team_name)
                if club_name:
                    clubs.add(club_name)
    
    print(f"Found {len(clubs)} unique clubs: {sorted(clubs)}")
    
    for club in clubs:
        print(f"Processing: {club}")
        badge_url = fetch_badge_url(club)
        if not badge_url:
            print(f"No badge found for {club}")
            continue
        
        badge_path = download_badge(club, badge_url)
        if badge_path:
            png_path = convert_svg_to_png(badge_path)
            mapping[club] = {
                'svg': os.path.basename(badge_path) if badge_path.endswith('.svg') else None,
                'png': os.path.basename(png_path) if png_path else (os.path.basename(badge_path) if badge_path.endswith('.png') else None)
            }
            print(f"✓ Downloaded badge for {club}")
    
    with open(MAPPING_FILE, 'w', encoding='utf-8') as f:
        json.dump(mapping, f, indent=2)
    print(f"Badge mapping saved to {MAPPING_FILE}")
    print(f"Successfully downloaded {len(mapping)} badges")

if __name__ == '__main__':
    main()
