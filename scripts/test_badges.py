import os
import re
import requests
from cairosvg import svg2png
import json

BADGE_DIR = 'app/assets/images/badges'
MAPPING_FILE = 'app/assets/images/badges/badge_mapping.json'

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
            r = requests.get(url)
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
                            fr = requests.get(file_api)
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
        r = requests.get(url)
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

def main():
    if not os.path.exists(BADGE_DIR):
        os.makedirs(BADGE_DIR)
    
    mapping = {}
    
    # Test with just a few clubs
    test_clubs = ['Barcelona', 'Real', 'Liverpool', 'Arsenal', 'Bayern']
    
    for club in test_clubs:
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
