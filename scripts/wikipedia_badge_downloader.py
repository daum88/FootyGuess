#!/usr/bin/env python3
"""
Wikipedia Badge Downloader - Extract official club badges from Wikipedia pages
"""

import requests
import json
import csv
import os
import re
import time
from pathlib import Path
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse

def extract_club_name(team_name):
    """Extract clean club name from CSV format like 'barcelona_2012_13_milan4_0'"""
    parts = team_name.lower().split('_')
    club_name = parts[0]
    
    if len(parts) > 1 and not parts[1].isdigit():
        if parts[1] in ['madrid', 'milan', 'city', 'united', 'athletic', 'london']:
            club_name = f"{parts[0]}_{parts[1]}"
    
    return club_name.replace('_', ' ').title()

# Wikipedia URLs for major football clubs
CLUB_WIKIPEDIA_URLS = {
    # Premier League
    'Arsenal': 'https://en.wikipedia.org/wiki/Arsenal_F.C.',
    'Aston Villa': 'https://en.wikipedia.org/wiki/Aston_Villa_F.C.',
    'Afc Bournemouth': 'https://en.wikipedia.org/wiki/AFC_Bournemouth',
    'Brentford': 'https://en.wikipedia.org/wiki/Brentford_F.C.',
    'Brighton': 'https://en.wikipedia.org/wiki/Brighton_%26_Hove_Albion_F.C.',
    'Chelsea': 'https://en.wikipedia.org/wiki/Chelsea_F.C.',
    'Crystal Palace': 'https://en.wikipedia.org/wiki/Crystal_Palace_F.C.',
    'Everton': 'https://en.wikipedia.org/wiki/Everton_F.C.',
    'Fulham': 'https://en.wikipedia.org/wiki/Fulham_F.C.',
    'Leicester': 'https://en.wikipedia.org/wiki/Leicester_City_F.C.',
    'Leicester City': 'https://en.wikipedia.org/wiki/Leicester_City_F.C.',
    'Liverpool': 'https://en.wikipedia.org/wiki/Liverpool_F.C.',
    'Manchester City': 'https://en.wikipedia.org/wiki/Manchester_City_F.C.',
    'Man City': 'https://en.wikipedia.org/wiki/Manchester_City_F.C.',
    'Manchester United': 'https://en.wikipedia.org/wiki/Manchester_United_F.C.',
    'Man United': 'https://en.wikipedia.org/wiki/Manchester_United_F.C.',
    'Newcastle': 'https://en.wikipedia.org/wiki/Newcastle_United_F.C.',
    'Newcastle United': 'https://en.wikipedia.org/wiki/Newcastle_United_F.C.',
    'Southampton': 'https://en.wikipedia.org/wiki/Southampton_F.C.',
    'Tottenham': 'https://en.wikipedia.org/wiki/Tottenham_Hotspur_F.C.',
    'Spurs': 'https://en.wikipedia.org/wiki/Tottenham_Hotspur_F.C.',
    'West Ham': 'https://en.wikipedia.org/wiki/West_Ham_United_F.C.',
    'Wolves': 'https://en.wikipedia.org/wiki/Wolverhampton_Wanderers_F.C.',
    
    # La Liga
    'Athletic Bilbao': 'https://en.wikipedia.org/wiki/Athletic_Bilbao',
    'Atletico Madrid': 'https://en.wikipedia.org/wiki/Atlético_Madrid',
    'Barcelona': 'https://en.wikipedia.org/wiki/FC_Barcelona',
    'Real Betis': 'https://en.wikipedia.org/wiki/Real_Betis',
    'Real Madrid': 'https://en.wikipedia.org/wiki/Real_Madrid_CF',
    'Real Sociedad': 'https://en.wikipedia.org/wiki/Real_Sociedad',
    'Sevilla': 'https://en.wikipedia.org/wiki/Sevilla_FC',
    'Valencia': 'https://en.wikipedia.org/wiki/Valencia_CF',
    'Villarreal': 'https://en.wikipedia.org/wiki/Villarreal_CF',
    
    # Bundesliga
    'Bayern Munich': 'https://en.wikipedia.org/wiki/FC_Bayern_Munich',
    'Bayern': 'https://en.wikipedia.org/wiki/FC_Bayern_Munich',
    'Borussia Dortmund': 'https://en.wikipedia.org/wiki/Borussia_Dortmund',
    'Dortmund': 'https://en.wikipedia.org/wiki/Borussia_Dortmund',
    'Borussia': 'https://en.wikipedia.org/wiki/Borussia_Dortmund',
    'Bayer': 'https://en.wikipedia.org/wiki/Bayer_04_Leverkusen',
    'Leverkusen': 'https://en.wikipedia.org/wiki/Bayer_04_Leverkusen',
    'Stuttgart': 'https://en.wikipedia.org/wiki/VfB_Stuttgart',
    'Werder': 'https://en.wikipedia.org/wiki/SV_Werder_Bremen',
    'Schalke': 'https://en.wikipedia.org/wiki/FC_Schalke_04',
    
    # Serie A
    'Ac Milan': 'https://en.wikipedia.org/wiki/A.C._Milan',
    'Inter Milan': 'https://en.wikipedia.org/wiki/Inter_Milan',
    'Inter': 'https://en.wikipedia.org/wiki/Inter_Milan',
    'Juventus': 'https://en.wikipedia.org/wiki/Juventus_F.C.',
    'Napoli': 'https://en.wikipedia.org/wiki/S.S.C._Napoli',
    'Roma': 'https://en.wikipedia.org/wiki/A.S._Roma',
    'Lazio': 'https://en.wikipedia.org/wiki/S.S._Lazio',
    'Atalanta': 'https://en.wikipedia.org/wiki/Atalanta_B.C.',
    'Fiorentina': 'https://en.wikipedia.org/wiki/ACF_Fiorentina',
    'Parma': 'https://en.wikipedia.org/wiki/Parma_Calcio_1913',
    
    # Ligue 1
    'Paris Saint Germain': 'https://en.wikipedia.org/wiki/Paris_Saint-Germain_F.C.',
    'Psg': 'https://en.wikipedia.org/wiki/Paris_Saint-Germain_F.C.',
    'Monaco': 'https://en.wikipedia.org/wiki/AS_Monaco_FC',
    'Marseille': 'https://en.wikipedia.org/wiki/Olympique_de_Marseille',
    'Lille': 'https://en.wikipedia.org/wiki/Lille_OSC',
    'Lyon': 'https://en.wikipedia.org/wiki/Olympique_Lyonnais',
    'Nice': 'https://en.wikipedia.org/wiki/OGC_Nice',
    
    # Eredivisie
    'Ajax': 'https://en.wikipedia.org/wiki/AFC_Ajax',
    'Psv': 'https://en.wikipedia.org/wiki/PSV_Eindhoven',
    'Feyenoord': 'https://en.wikipedia.org/wiki/Feyenoord',
    
    # Primeira Liga
    'Benfica': 'https://en.wikipedia.org/wiki/S.L._Benfica',
    'Porto': 'https://en.wikipedia.org/wiki/FC_Porto',
    'Sporting': 'https://en.wikipedia.org/wiki/Sporting_CP',
    
    # Other major clubs
    'Celtic': 'https://en.wikipedia.org/wiki/Celtic_F.C.',
    'Rangers': 'https://en.wikipedia.org/wiki/Rangers_F.C.',
    'Galatasaray': 'https://en.wikipedia.org/wiki/Galatasaray_S.K._(football)',
    'Fenerbahce': 'https://en.wikipedia.org/wiki/Fenerbahçe_S.K._(football)',
    'Olympiacos': 'https://en.wikipedia.org/wiki/Olympiacos_F.C.',
    'Anderlecht': 'https://en.wikipedia.org/wiki/R.S.C._Anderlecht',
    'Club': 'https://en.wikipedia.org/wiki/Club_Brugge_KV',
    'Basel': 'https://en.wikipedia.org/wiki/FC_Basel',
    'Dynamo': 'https://en.wikipedia.org/wiki/FC_Dynamo_Kyiv',
    'Shakhtar': 'https://en.wikipedia.org/wiki/FC_Shakhtar_Donetsk',
    'Zenit': 'https://en.wikipedia.org/wiki/FC_Zenit_Saint_Petersburg',
    'Cska': 'https://en.wikipedia.org/wiki/PFC_CSKA_Moscow',
    'Sparta': 'https://en.wikipedia.org/wiki/AC_Sparta_Prague',
    'Rosenborg': 'https://en.wikipedia.org/wiki/Rosenborg_BK',
    'Malmo': 'https://en.wikipedia.org/wiki/Malmö_FF',
    'Apoel': 'https://en.wikipedia.org/wiki/APOEL_FC',
    'Legia': 'https://en.wikipedia.org/wiki/Legia_Warsaw',
    
    # Additional Premier League/Championship
    'Leeds': 'https://en.wikipedia.org/wiki/Leeds_United_F.C.',
    'Leeds United': 'https://en.wikipedia.org/wiki/Leeds_United_F.C.',
    'Norwich': 'https://en.wikipedia.org/wiki/Norwich_City_F.C.',
    'Watford': 'https://en.wikipedia.org/wiki/Watford_F.C.',
    'Burnley': 'https://en.wikipedia.org/wiki/Burnley_F.C.',
    'Sheffield United': 'https://en.wikipedia.org/wiki/Sheffield_United_F.C.',
    'Blackburn': 'https://en.wikipedia.org/wiki/Blackburn_Rovers_F.C.',
    'Qpr': 'https://en.wikipedia.org/wiki/Queens_Park_Rangers_F.C.',
}

def find_club_logo_on_wikipedia(wikipedia_url, club_name):
    """Extract the official club logo from a Wikipedia page"""
    print(f"🔍 Searching {club_name} Wikipedia page: {wikipedia_url}")
    
    headers = {
        'User-Agent': 'FootyGuess Badge Downloader 1.0 (contact@footyguess.com)',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate',
        'Connection': 'keep-alive',
    }
    
    try:
        response = requests.get(wikipedia_url, headers=headers, timeout=15)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Look for the club logo in various places
        logo_candidates = []
        
        # 1. Look in the infobox for images
        infobox = soup.find('table', {'class': 'infobox'})
        if infobox:
            images = infobox.find_all('img')
            for img in images:
                src = img.get('src', '')
                alt = img.get('alt', '').lower()
                
                # Check if this looks like a club logo
                if any(keyword in alt for keyword in ['logo', 'badge', 'crest', 'emblem', club_name.lower()]):
                    if src.startswith('//'):
                        src = 'https:' + src
                    elif src.startswith('/'):
                        src = 'https://en.wikipedia.org' + src
                    
                    logo_candidates.append({
                        'url': src,
                        'alt': alt,
                        'source': 'infobox'
                    })
        
        # 2. Look for images with club-related names in the page
        all_images = soup.find_all('img')
        for img in all_images:
            src = img.get('src', '')
            alt = img.get('alt', '').lower()
            
            # Check for logo-like keywords and club name
            logo_keywords = ['logo', 'badge', 'crest', 'emblem']
            if any(keyword in alt for keyword in logo_keywords) and club_name.lower() in alt:
                if src.startswith('//'):
                    src = 'https:' + src
                elif src.startswith('/'):
                    src = 'https://en.wikipedia.org' + src
                
                logo_candidates.append({
                    'url': src,
                    'alt': alt,
                    'source': 'page_scan'
                })
        
        # Filter for SVG files (preferred) or high-quality images
        svg_candidates = [c for c in logo_candidates if '.svg' in c['url']]
        if svg_candidates:
            print(f"   ✅ Found {len(svg_candidates)} SVG logo(s)")
            return svg_candidates[0]  # Return the first SVG found
        
        # If no SVG, look for PNG with good resolution
        png_candidates = [c for c in logo_candidates if '.png' in c['url'] and ('200px' in c['url'] or '300px' in c['url'])]
        if png_candidates:
            print(f"   ✅ Found {len(png_candidates)} high-res PNG logo(s)")
            return png_candidates[0]
        
        # Fall back to any logo candidate
        if logo_candidates:
            print(f"   ⚠️  Found {len(logo_candidates)} logo candidate(s), using first one")
            return logo_candidates[0]
        
        print(f"   ❌ No logo found on Wikipedia page")
        return None
        
    except Exception as e:
        print(f"   ❌ Error fetching Wikipedia page: {e}")
        return None

def download_logo_from_url(logo_info, club_name):
    """Download the logo from the extracted URL"""
    if not logo_info:
        return False
    
    logo_url = logo_info['url']
    print(f"   📥 Downloading from: {logo_url}")
    
    headers = {
        'User-Agent': 'FootyGuess Badge Downloader 1.0 (contact@footyguess.com)',
        'Referer': 'https://en.wikipedia.org/'
    }
    
    try:
        response = requests.get(logo_url, headers=headers, timeout=15)
        response.raise_for_status()
        
        # Determine file extension
        if '.svg' in logo_url:
            extension = '.svg'
        elif '.png' in logo_url:
            extension = '.png'
        elif '.jpg' in logo_url or '.jpeg' in logo_url:
            extension = '.jpg'
        else:
            extension = '.png'  # Default
        
        # Create output directory
        output_dir = Path("app/assets/images/badges")
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Save with clean club name
        clean_name = club_name.lower().replace(' ', '_').replace('-', '_')
        output_path = output_dir / f"{clean_name}{extension}"
        
        with open(output_path, 'wb') as f:
            f.write(response.content)
        
        print(f"   ✅ Downloaded: {output_path}")
        
        # Verify file size (should be reasonable for a logo)
        file_size = os.path.getsize(output_path)
        if file_size < 500:  # Too small, probably an error
            print(f"   ⚠️  File size suspicious: {file_size} bytes")
            os.remove(output_path)
            return False
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error downloading logo: {e}")
        return False

def main():
    """Main function to download club badges from Wikipedia"""
    print("🚀 Starting Wikipedia Club Badge Downloader")
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
    
    # Focus on clubs we have Wikipedia URLs for
    available_clubs = [club for club in clubs if club in CLUB_WIKIPEDIA_URLS]
    missing_clubs = [club for club in clubs if club not in CLUB_WIKIPEDIA_URLS]
    
    print(f"🎯 Clubs with Wikipedia URLs: {len(available_clubs)}")
    print(f"⚠️  Clubs without URLs: {len(missing_clubs)}")
    
    if missing_clubs:
        print("\n⚠️  Missing Wikipedia URLs for:")
        for club in sorted(missing_clubs):
            print(f"   • {club}")
    
    successful_downloads = {}
    failed_downloads = []
    
    # Download available clubs
    print(f"\n🎯 Downloading from Wikipedia pages...")
    for i, club in enumerate(sorted(available_clubs), 1):
        print(f"\n[{i}/{len(available_clubs)}] Processing: {club}")
        
        wikipedia_url = CLUB_WIKIPEDIA_URLS[club]
        logo_info = find_club_logo_on_wikipedia(wikipedia_url, club)
        
        if logo_info and download_logo_from_url(logo_info, club):
            successful_downloads[club] = {
                'wikipedia_url': wikipedia_url,
                'logo_url': logo_info['url'],
                'source': logo_info['source']
            }
        else:
            failed_downloads.append(club)
        
        # Be respectful to Wikipedia
        time.sleep(2)
    
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
