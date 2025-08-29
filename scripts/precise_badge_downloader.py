#!/usr/bin/env python3
"""
Precise Club Badge Downloader - Ultra-specific searches for correct football club badges
"""

import requests
import json
import csv
import os
import time
from pathlib import Path
from urllib.parse import quote

def extract_club_name(team_name):
    """Extract clean club name from CSV format like 'barcelona_2012_13_milan4_0'"""
    # Remove underscores and numbers, take first part before season info
    parts = team_name.lower().split('_')
    
    # Find the main club name (before season years)
    club_name = parts[0]
    
    # Handle special cases where club name might be in first two parts
    if len(parts) > 1 and not parts[1].isdigit():
        # Check if second part is part of club name (like "real_madrid")
        if parts[1] in ['madrid', 'milan', 'city', 'united', 'athletic', 'london']:
            club_name = f"{parts[0]}_{parts[1]}"
    
    return club_name.replace('_', ' ').title()

# Ultra-specific club name mappings with official names
PRECISE_CLUB_MAPPING = {
    # Top European clubs with exact official names
    'Barcelona': 'FC Barcelona official logo',
    'Real Madrid': 'Real Madrid CF official logo',
    'Bayern Munich': 'FC Bayern München official logo',
    'Arsenal': 'Arsenal FC official logo', 
    'Liverpool': 'Liverpool FC official logo',
    'Chelsea': 'Chelsea FC official logo',
    'Manchester United': 'Manchester United FC official logo',
    'Manchester City': 'Manchester City FC official logo',
    'Juventus': 'Juventus FC official logo',
    'Ajax': 'AFC Ajax official logo',
    'Ac Milan': 'AC Milan official logo',
    'Inter Milan': 'FC Internazionale Milano official logo',
    'Atletico Madrid': 'Atlético Madrid official logo',
    'Borussia Dortmund': 'Borussia Dortmund official logo',
    'Paris Saint Germain': 'Paris Saint-Germain FC official logo',
    'Tottenham': 'Tottenham Hotspur FC official logo',
    'Napoli': 'SSC Napoli official logo',
    'Roma': 'AS Roma official logo',
    'Lazio': 'SS Lazio official logo',
    'Valencia': 'Valencia CF official logo',
    'Sevilla': 'Sevilla FC official logo',
    'Villarreal': 'Villarreal CF official logo',
    'Athletic Bilbao': 'Athletic Club official logo',
    'Real Sociedad': 'Real Sociedad official logo',
    'Benfica': 'SL Benfica official logo',
    'Porto': 'FC Porto official logo',
    'Sporting': 'Sporting CP official logo',
    'Lyon': 'Olympique Lyonnais official logo',
    'Marseille': 'Olympique de Marseille official logo',
    'Monaco': 'AS Monaco FC official logo',
    'Nice': 'OGC Nice official logo',
    'Lille': 'LOSC Lille official logo',
    'Atalanta': 'Atalanta BC official logo',
    'Fiorentina': 'ACF Fiorentina official logo',
    'Leicester': 'Leicester City FC official logo',
    'West Ham': 'West Ham United FC official logo',
    'Everton': 'Everton FC official logo',
    'Newcastle': 'Newcastle United FC official logo',
    'Aston Villa': 'Aston Villa FC official logo',
    'Leeds': 'Leeds United FC official logo',
    'Southampton': 'Southampton FC official logo',
    'Crystal Palace': 'Crystal Palace FC official logo',
    'Brighton': 'Brighton & Hove Albion FC official logo',
    'Burnley': 'Burnley FC official logo',
    'Norwich': 'Norwich City FC official logo',
    'Watford': 'Watford FC official logo',
    'Brentford': 'Brentford FC official logo',
    'Fulham': 'Fulham FC official logo',
    'Wolves': 'Wolverhampton Wanderers FC official logo',
    'Sheffield United': 'Sheffield United FC official logo',
    'Leeds United': 'Leeds United FC official logo',
    'Afc Bournemouth': 'AFC Bournemouth official logo',
}

def is_valid_football_badge(title, description):
    """Ultra-strict validation for football club badges"""
    title_lower = title.lower()
    desc_lower = description.lower() if description else ""
    
    # Must contain football-specific terms
    football_terms = ['football', 'fc', 'club', 'soccer', 'logo', 'badge', 'crest', 'emblem']
    has_football_term = any(term in title_lower or term in desc_lower for term in football_terms)
    
    # Reject non-football content
    reject_terms = [
        'basketball', 'baseball', 'hockey', 'tennis', 'volleyball',
        'company', 'corporation', 'business', 'brand', 'restaurant',
        'university', 'college', 'school', 'academic', 'education',
        'government', 'political', 'election', 'campaign',
        'music', 'band', 'album', 'song', 'entertainment',
        'movie', 'film', 'tv', 'television', 'show',
        'product', 'store', 'shop', 'retail', 'commercial',
        'flag', 'country', 'nation', 'state', 'city coat',
        'military', 'army', 'navy', 'police', 'badge police'
    ]
    
    has_reject_term = any(term in title_lower or term in desc_lower for term in reject_terms)
    
    # File must be SVG
    is_svg = title_lower.endswith('.svg')
    
    return has_football_term and not has_reject_term and is_svg

def search_precise_club_badge(club_name):
    """Search for club badge with ultra-precise terms"""
    if club_name not in PRECISE_CLUB_MAPPING:
        print(f"⚠️  No precise mapping for {club_name}")
        return None
    
    search_term = PRECISE_CLUB_MAPPING[club_name]
    print(f"🔍 Searching for: {search_term}")
    
    url = "https://commons.wikimedia.org/w/api.php"
    params = {
        'action': 'query',
        'format': 'json',
        'list': 'search',
        'srsearch': f'filetype:svg {search_term}',
        'srnamespace': 6,  # File namespace
        'srlimit': 10,
        'srprop': 'size|wordcount|timestamp|snippet'
    }
    
    headers = {
        'User-Agent': 'FootyGuess Badge Downloader 1.0 (contact@footyguess.com)'
    }
    
    try:
        response = requests.get(url, params=params, headers=headers, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        if 'query' in data and 'search' in data['query']:
            results = data['query']['search']
            print(f"📋 Found {len(results)} results for {club_name}")
            
            for result in results:
                title = result['title'].replace('File:', '')
                snippet = result.get('snippet', '')
                
                print(f"   📄 Checking: {title}")
                
                if is_valid_football_badge(title, snippet):
                    print(f"✅ Valid badge found: {title}")
                    return title
                else:
                    print(f"❌ Rejected: {title}")
            
            print(f"⚠️  No valid badges found for {club_name}")
            return None
        else:
            print(f"❌ No search results for {club_name}")
            return None
            
    except Exception as e:
        print(f"❌ Error searching for {club_name}: {e}")
        return None

def download_badge(filename, club_name):
    """Download SVG badge from Wikimedia Commons"""
    if not filename:
        return False
    
    # Get file info to find actual download URL
    url = "https://commons.wikimedia.org/w/api.php"
    params = {
        'action': 'query',
        'format': 'json',
        'titles': f'File:{filename}',
        'prop': 'imageinfo',
        'iiprop': 'url|size|mime'
    }
    
    headers = {
        'User-Agent': 'FootyGuess Badge Downloader 1.0 (contact@footyguess.com)'
    }
    
    try:
        response = requests.get(url, params=params, headers=headers, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        pages = data['query']['pages']
        page = next(iter(pages.values()))
        
        if 'imageinfo' in page and page['imageinfo']:
            download_url = page['imageinfo'][0]['url']
            mime_type = page['imageinfo'][0].get('mime', '')
            
            if 'svg' not in mime_type.lower():
                print(f"⚠️  Not an SVG file: {mime_type}")
                return False
            
            # Download the file
            badge_response = requests.get(download_url, headers=headers, timeout=15)
            badge_response.raise_for_status()
            
            # Create output directory
            output_dir = Path("app/assets/images/badges")
            output_dir.mkdir(parents=True, exist_ok=True)
            
            # Save with clean club name
            clean_name = club_name.lower().replace(' ', '_').replace('-', '_')
            output_path = output_dir / f"{clean_name}.svg"
            
            with open(output_path, 'wb') as f:
                f.write(badge_response.content)
            
            print(f"✅ Downloaded: {output_path}")
            return True
        else:
            print(f"❌ Could not get download URL for {filename}")
            return False
            
    except Exception as e:
        print(f"❌ Error downloading {filename}: {e}")
        return False

def main():
    """Main function to download club badges"""
    print("🚀 Starting Precise Club Badge Downloader")
    print("=" * 50)
    
    # Read clubs from CSV
    csv_path = "app/assets/data/combined_all_lineups.csv"
    if not os.path.exists(csv_path):
        print(f"❌ CSV file not found: {csv_path}")
        return
    
    clubs = set()
    with open(csv_path, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            team_name = row.get('team_name', '').strip()
            if team_name:
                club_name = extract_club_name(team_name)
                clubs.add(club_name)
    
    print(f"📊 Found {len(clubs)} unique clubs")
    
    # Focus on major clubs first (ones we have precise mappings for)
    priority_clubs = [club for club in clubs if club in PRECISE_CLUB_MAPPING]
    other_clubs = [club for club in clubs if club not in PRECISE_CLUB_MAPPING]
    
    print(f"🎯 Priority clubs (with precise mappings): {len(priority_clubs)}")
    print(f"⚠️  Other clubs (no precise mapping): {len(other_clubs)}")
    
    successful_downloads = {}
    failed_downloads = []
    
    # Download priority clubs first
    print("\n🎯 Downloading priority clubs...")
    for i, club in enumerate(sorted(priority_clubs), 1):
        print(f"\n[{i}/{len(priority_clubs)}] Processing: {club}")
        
        badge_filename = search_precise_club_badge(club)
        if badge_filename and download_badge(badge_filename, club):
            successful_downloads[club] = badge_filename
        else:
            failed_downloads.append(club)
        
        # Be respectful to the API
        time.sleep(1)
    
    # Create mapping file
    mapping_path = Path("app/assets/images/badges/badge_mapping.json")
    with open(mapping_path, 'w', encoding='utf-8') as f:
        json.dump(successful_downloads, f, indent=2, ensure_ascii=False)
    
    print(f"\n🎉 Download complete!")
    print(f"✅ Successfully downloaded: {len(successful_downloads)} badges")
    print(f"❌ Failed to download: {len(failed_downloads)} badges")
    
    if successful_downloads:
        print("\n✅ Successfully downloaded:")
        for club in sorted(successful_downloads.keys()):
            print(f"   • {club}")
    
    if failed_downloads:
        print("\n❌ Failed downloads:")
        for club in sorted(failed_downloads):
            print(f"   • {club}")

if __name__ == "__main__":
    main()
