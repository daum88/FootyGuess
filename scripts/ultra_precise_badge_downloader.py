#!/usr/bin/env python3
"""
Ultra-Precise Club Badge Downloader - Using exact known file names
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
    parts = team_name.lower().split('_')
    club_name = parts[0]
    
    if len(parts) > 1 and not parts[1].isdigit():
        if parts[1] in ['madrid', 'milan', 'city', 'united', 'athletic', 'london']:
            club_name = f"{parts[0]}_{parts[1]}"
    
    return club_name.replace('_', ' ').title()

# Exact known SVG file names from Wikimedia Commons for major clubs
EXACT_FILE_NAMES = {
    'Barcelona': 'FC Barcelona (crest).svg',
    'Real Madrid': 'Real Madrid CF.svg', 
    'Bayern Munich': 'FC Bayern Munich logo (2017).svg',
    'Arsenal': 'Arsenal FC.svg',
    'Liverpool': 'Liverpool FC.svg',
    'Chelsea': 'Chelsea FC.svg',
    'Manchester United': 'Manchester United FC crest.svg',
    'Manchester City': 'Manchester City FC badge.svg',
    'Juventus': 'Juventus FC 2017 logo.svg',
    'Ajax': 'Ajax Amsterdam.svg',
    'Ac Milan': 'AC Milan.svg',
    'Inter Milan': 'Inter Milan.svg',
    'Atletico Madrid': 'Atletico Madrid.svg',
    'Borussia Dortmund': 'Borussia Dortmund logo.svg',
    'Paris Saint Germain': 'Paris Saint-Germain Logo.svg',
    'Tottenham': 'Tottenham Hotspur.svg',
    'Napoli': 'SSC Napoli.svg',
    'Roma': 'AS Roma logo.svg',
    'Lazio': 'SS Lazio.svg',
    'Valencia': 'Valencia CF logo.svg',
    'Sevilla': 'Sevilla FC logo.svg',
    'Villarreal': 'Villarreal CF logo.svg',
    'Athletic Bilbao': 'Athletic Bilbao.svg',
    'Real Sociedad': 'Real Sociedad logo.svg',
    'Benfica': 'SL Benfica logo.svg',
    'Porto': 'FC Porto.svg',
    'Sporting': 'Sporting CP logo.svg',
    'Lyon': 'Olympique Lyonnais.svg',
    'Marseille': 'Olympique de Marseille logo.svg',
    'Monaco': 'AS Monaco FC.svg',
    'Nice': 'OGC Nice logo.svg',
    'Lille': 'LOSC Lille logo.svg',
    'Atalanta': 'Atalanta BC logo.svg',
    'Fiorentina': 'ACF Fiorentina logo.svg',
    'Leicester': 'Leicester City crest.svg',
    'West Ham': 'West Ham United FC logo.svg',
    'Everton': 'Everton FC logo.svg',
    'Newcastle': 'Newcastle United Logo.svg',
    'Aston Villa': 'Aston Villa logo.svg',
    'Leeds': 'Leeds United AFC logo.svg',
    'Southampton': 'Southampton FC logo.svg',
    'Crystal Palace': 'Crystal Palace FC logo.svg',
    'Brighton': 'Brighton & Hove Albion logo.svg',
    'Burnley': 'Burnley FC logo.svg',
    'Norwich': 'Norwich City.svg',
    'Watford': 'Watford.svg',
    'Brentford': 'Brentford FC logo.svg',
    'Fulham': 'Fulham FC (shield).svg',
    'Wolves': 'Wolverhampton Wanderers.svg',
    'Sheffield United': 'Sheffield United FC logo.svg',
    'Afc Bournemouth': 'AFC Bournemouth (2013).svg',
}

def try_alternative_names(club_name):
    """Try alternative file name patterns if exact name doesn't work"""
    alternatives = []
    
    base_patterns = [
        f"{club_name}.svg",
        f"{club_name} logo.svg", 
        f"{club_name} FC.svg",
        f"{club_name} FC logo.svg",
        f"{club_name} crest.svg",
        f"{club_name} badge.svg",
        f"{club_name} emblem.svg",
    ]
    
    for pattern in base_patterns:
        alternatives.append(pattern)
    
    return alternatives

def check_file_exists(filename):
    """Check if a file exists on Wikimedia Commons"""
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
        
        # Check if page exists (no 'missing' key)
        if 'missing' not in page and 'imageinfo' in page and page['imageinfo']:
            imageinfo = page['imageinfo'][0]
            mime_type = imageinfo.get('mime', '')
            
            # Ensure it's an SVG
            if 'svg' in mime_type.lower():
                return imageinfo['url']
        
        return None
        
    except Exception as e:
        print(f"❌ Error checking {filename}: {e}")
        return None

def download_badge_from_url(download_url, club_name):
    """Download badge from direct URL"""
    headers = {
        'User-Agent': 'FootyGuess Badge Downloader 1.0 (contact@footyguess.com)'
    }
    
    try:
        response = requests.get(download_url, headers=headers, timeout=15)
        response.raise_for_status()
        
        # Create output directory
        output_dir = Path("app/assets/images/badges")
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Save with clean club name
        clean_name = club_name.lower().replace(' ', '_').replace('-', '_')
        output_path = output_dir / f"{clean_name}.svg"
        
        with open(output_path, 'wb') as f:
            f.write(response.content)
        
        print(f"✅ Downloaded: {output_path}")
        return True
        
    except Exception as e:
        print(f"❌ Error downloading from {download_url}: {e}")
        return False

def find_and_download_badge(club_name):
    """Try to find and download badge using exact file names and alternatives"""
    print(f"🔍 Searching for {club_name}")
    
    # First try exact known file name
    if club_name in EXACT_FILE_NAMES:
        exact_filename = EXACT_FILE_NAMES[club_name]
        print(f"   📋 Trying exact name: {exact_filename}")
        
        download_url = check_file_exists(exact_filename)
        if download_url:
            print(f"   ✅ Found exact file!")
            if download_badge_from_url(download_url, club_name):
                return exact_filename
    
    # Try alternative patterns
    print(f"   🔄 Trying alternative patterns...")
    alternatives = try_alternative_names(club_name)
    
    for alt_filename in alternatives:
        print(f"   📋 Trying: {alt_filename}")
        download_url = check_file_exists(alt_filename)
        if download_url:
            print(f"   ✅ Found alternative!")
            if download_badge_from_url(download_url, club_name):
                return alt_filename
        time.sleep(0.5)  # Small delay between requests
    
    print(f"   ❌ No valid file found for {club_name}")
    return None

def main():
    """Main function to download club badges"""
    print("🚀 Starting Ultra-Precise Club Badge Downloader")
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
    
    # Focus on clubs we have exact mappings for
    priority_clubs = [club for club in clubs if club in EXACT_FILE_NAMES]
    other_clubs = [club for club in clubs if club not in EXACT_FILE_NAMES]
    
    print(f"🎯 Priority clubs (exact file names): {len(priority_clubs)}")
    print(f"⚠️  Other clubs (will try alternatives): {len(other_clubs)}")
    
    successful_downloads = {}
    failed_downloads = []
    
    # Download priority clubs first
    print("\n🎯 Downloading priority clubs...")
    for i, club in enumerate(sorted(priority_clubs), 1):
        print(f"\n[{i}/{len(priority_clubs)}] Processing: {club}")
        
        filename = find_and_download_badge(club)
        if filename:
            successful_downloads[club] = filename
        else:
            failed_downloads.append(club)
        
        time.sleep(1)  # Be respectful to the API
    
    # Try a few other major clubs
    print(f"\n🔄 Trying some other major clubs...")
    other_major = ['Leeds United', 'West Bromwich', 'Cardiff', 'Swansea']
    other_to_try = [club for club in other_clubs if any(major in club for major in other_major)][:5]
    
    for i, club in enumerate(other_to_try, 1):
        print(f"\n[{i}/{len(other_to_try)}] Processing: {club}")
        
        filename = find_and_download_badge(club)
        if filename:
            successful_downloads[club] = filename
        else:
            failed_downloads.append(club)
        
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
