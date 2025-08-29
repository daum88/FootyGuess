import os
import re
import requests
from cairosvg import svg2png
import csv
import json
import time

BADGE_DIR = 'app/assets/images/badges'
MAPPING_FILE = 'app/assets/images/badges/badge_mapping.json'
CSV_FILE = 'app/assets/data/combined_all_lineups.csv'

# Headers for requests to avoid 403 errors
HEADERS = {
    'User-Agent': 'FootyGuess Badge Downloader/1.0 (https://github.com/user/footyguess) Python/3.x'
}

# Map of shortened names to full club names for better searching
CLUB_NAME_MAPPING = {
    'Barcelona': 'FC Barcelona',
    'Real': 'Real Madrid CF',
    'Bayern': 'FC Bayern Munich',
    'Psg': 'Paris Saint-Germain FC',
    'Man': 'Manchester United FC',
    'Manchester': 'Manchester United FC',
    'Arsenal': 'Arsenal FC',
    'Liverpool': 'Liverpool FC',
    'Chelsea': 'Chelsea FC',
    'Tottenham': 'Tottenham Hotspur FC',
    'Spurs': 'Tottenham Hotspur FC',
    'Ajax': 'AFC Ajax',
    'Juventus': 'Juventus FC',
    'Inter': 'FC Internazionale Milano',
    'Ac': 'AC Milan',
    'Roma': 'AS Roma',
    'Lazio': 'SS Lazio',
    'Napoli': 'SSC Napoli',
    'Atletico': 'Atlético Madrid',
    'Valencia': 'Valencia CF',
    'Sevilla': 'Sevilla FC',
    'Villarreal': 'Villarreal CF',
    'Dortmund': 'Borussia Dortmund',
    'Borussia': 'Borussia Dortmund',
    'Schalke': 'FC Schalke 04',
    'Leverkusen': 'Bayer 04 Leverkusen',
    'Bayer': 'Bayer 04 Leverkusen',
    'Stuttgart': 'VfB Stuttgart',
    'Werder': 'SV Werder Bremen',
    'Lyon': 'Olympique Lyonnais',
    'Marseille': 'Olympique de Marseille',
    'Monaco': 'AS Monaco FC',
    'Porto': 'FC Porto',
    'Benfica': 'SL Benfica',
    'Sporting': 'Sporting CP',
    'Celtic': 'Celtic FC',
    'Rangers': 'Rangers FC',
    'Fenerbahce': 'Fenerbahçe SK',
    'Galatasaray': 'Galatasaray SK',
    'Cska': 'CSKA Moscow',
    'Zenit': 'FC Zenit Saint Petersburg',
    'Dynamo': 'FC Dynamo Kyiv',
    'Shakhtar': 'FC Shakhtar Donetsk',
    'Olympiacos': 'Olympiacos FC',
    'Apoel': 'APOEL FC',
    'Anderlecht': 'RSC Anderlecht',
    'Feyenoord': 'Feyenoord Rotterdam',
    'Psv': 'PSV Eindhoven',
    'Basel': 'FC Basel',
    'Malmo': 'Malmö FF',
    'Rosenborg': 'Rosenborg BK',
    'Leicester': 'Leicester City FC',
    'Newcastle': 'Newcastle United FC',
    'Leeds': 'Leeds United FC',
    'Blackburn': 'Blackburn Rovers FC',
    'Qpr': 'Queens Park Rangers FC',
    'Parma': 'Parma FC',
    'Atalanta': 'Atalanta BC',
    'Deportivo': 'Deportivo La Coruña',
    'Legia': 'Legia Warsaw'
}

def normalize_name(name):
    name = name.lower()
    name = re.sub(r'[^a-z0-9]+', '-', name)
    name = name.strip('-')
    return name

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

def get_full_club_name(short_name):
    """Get the full club name for better searching"""
    return CLUB_NAME_MAPPING.get(short_name, short_name)

def is_football_club_badge(title, club_name):
    """Check if the file title looks like a real football club badge"""
    title_lower = title.lower()
    club_lower = club_name.lower()
    
    # Must contain the club name or a variation
    club_in_title = any(word in title_lower for word in club_lower.split())
    
    if not club_in_title:
        return False
    
    # Must contain football-related keywords
    football_keywords = ['fc', 'football', 'club', 'soccer', 'badge', 'logo', 'crest', 'emblem']
    has_football_keyword = any(keyword in title_lower for keyword in football_keywords)
    
    # Exclude non-football items
    exclude_keywords = [
        'metro', 'university', 'college', 'bank', 'basketball', 'hockey', 
        'baseball', 'tennis', 'rugby', 'cricket', 'volley', 'hand',
        'software', 'company', 'corporation', 'business', 'brand',
        'motors', 'car', 'auto', 'airline', 'airport', 'station',
        'restaurant', 'hotel', 'shop', 'store', 'mall', 'plaza'
    ]
    has_exclude = any(keyword in title_lower for keyword in exclude_keywords)
    
    return has_football_keyword and not has_exclude

def search_club_badge(club_name):
    """Search for football club badge with improved filtering"""
    full_club_name = get_full_club_name(club_name)
    
    # Try different search variations
    search_terms = [
        f'"{full_club_name}" logo',
        f'"{full_club_name}" badge',
        f'"{full_club_name}" crest',
        f'{club_name} FC logo',
        f'{club_name} football club logo',
        f'{club_name} badge',
        f'{club_name} crest'
    ]
    
    for search_term in search_terms:
        print(f"  Searching: {search_term}")
        # Search in File namespace (namespace 6) for actual file uploads
        url = f"https://commons.wikimedia.org/w/api.php?action=query&format=json&list=search&srnamespace=6&srsearch={search_term}&srlimit=20"
        
        try:
            r = requests.get(url, headers=HEADERS)
            if r.status_code == 200:
                data = r.json()
                if 'search' in data['query'] and data['query']['search']:
                    for result in data['query']['search']:
                        title = result['title']
                        
                        # Check if it's a valid image file
                        if not (title.lower().endswith('.svg') or title.lower().endswith('.png') or title.lower().endswith('.jpg')):
                            continue
                        
                        # Check if it looks like a football club badge
                        if is_football_club_badge(title, full_club_name):
                            print(f"  ✓ Found potential match: {title}")
                            
                            # Get file URL
                            file_api = f"https://commons.wikimedia.org/w/api.php?action=query&format=json&prop=imageinfo&iiprop=url&titles={title}"
                            fr = requests.get(file_api, headers=HEADERS)
                            if fr.status_code == 200:
                                file_data = fr.json()
                                pages = file_data['query']['pages']
                                for page in pages.values():
                                    if 'imageinfo' in page and page['imageinfo']:
                                        file_url = page['imageinfo'][0]['url']
                                        print(f"  ✓ Found URL: {file_url}")
                                        return file_url
                        else:
                            print(f"  ✗ Rejected (not football): {title}")
                            
            time.sleep(0.5)  # Be nice to the API
        except Exception as e:
            print(f"  Error searching {search_term}: {e}")
    
    print(f"  No badge found for {club_name}")
    return None

def download_badge(club_name, url):
    """Download badge file (SVG, PNG, or JPG)"""
    # Determine file extension from URL
    if url.lower().endswith('.svg'):
        filename = f"{normalize_name(club_name)}.svg"
    elif url.lower().endswith('.png'):
        filename = f"{normalize_name(club_name)}.png"
    elif url.lower().endswith('.jpg') or url.lower().endswith('.jpeg'):
        filename = f"{normalize_name(club_name)}.jpg"
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
    if not svg_path or not svg_path.endswith('.svg'):
        return None  # Not an SVG file
        
    png_path = svg_path.replace('.svg', '.png')
    try:
        svg2png(url=svg_path, write_to=png_path)
        return png_path
    except Exception as e:
        print(f"Error converting {svg_path}: {e}")
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
    
    # Test with major clubs first
    priority_clubs = ['Barcelona', 'Real', 'Bayern', 'Arsenal', 'Liverpool', 'Chelsea', 'Juventus', 'Ajax']
    test_clubs = [club for club in priority_clubs if club in clubs] + [club for club in sorted(clubs) if club not in priority_clubs][:10]
    
    print(f"Processing {len(test_clubs)} clubs: {test_clubs}")
    
    for club in test_clubs:
        print(f"\nProcessing: {club} ({get_full_club_name(club)})")
        badge_url = search_club_badge(club)
        if not badge_url:
            print(f"❌ No badge found for {club}")
            continue
        
        badge_path = download_badge(club, badge_url)
        if badge_path:
            png_path = convert_svg_to_png(badge_path)
            mapping[club] = {
                'svg': os.path.basename(badge_path) if badge_path.endswith('.svg') else None,
                'png': os.path.basename(png_path) if png_path else (os.path.basename(badge_path) if badge_path.endswith('.png') or badge_path.endswith('.jpg') else None)
            }
            print(f"✅ Downloaded badge for {club}")
    
    with open(MAPPING_FILE, 'w', encoding='utf-8') as f:
        json.dump(mapping, f, indent=2)
    print(f"\nBadge mapping saved to {MAPPING_FILE}")
    print(f"Successfully downloaded {len(mapping)} badges")

if __name__ == '__main__':
    main()
