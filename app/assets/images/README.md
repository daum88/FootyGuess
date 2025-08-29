# Image Assets Guide

## Flag Images
Place country flag images in `assets/images/flags/` using the following naming convention:
- Filename: `{country_name}.png` (lowercase, spaces replaced with underscores)
- Examples:
  - `argentina.png` for Argentina
  - `spain.png` for Spain  
  - `england.png` for England
  - `united_states.png` for United States

## Club Badge Images
Place club badge images in `assets/images/clubs/` using the following naming convention:
- Filename: `{club_name}.png` (lowercase, spaces replaced with underscores, dots removed)
- Examples:
  - `fc_barcelona.png` for FC Barcelona
  - `real_madrid_cf.png` for Real Madrid CF
  - `manchester_united_fc.png` for Manchester United FC
  - `bayern_munich.png` for Bayern Munich

## Image Requirements
- Format: PNG with transparency support
- Recommended dimensions:
  - Flags: 24x16 pixels (3:2 aspect ratio)
  - Club badges: 20x20 pixels (1:1 aspect ratio)
- If images are not found, the app will fallback to text abbreviations:
  - Flags: First 3 letters of country name
  - Club badges: Initials of club name

## Adding New Images
1. Add the image file to the appropriate directory
2. Run `flutter pub get` to refresh assets
3. Images will be automatically loaded based on data from `players.json` and `clubs.json`

## Current Placeholder Images
The following placeholder files exist and should be replaced with actual images:
- `assets/images/flags/argentina.png`
- `assets/images/flags/spain.png`
- `assets/images/clubs/fc_barcelona.png`
- `assets/images/clubs/real_madrid_cf.png`

## Resources for Images
- Flags: Use royalty-free flag images from sources like Flagpedia or create simple SVG flags
- Club badges: Use official club badges with proper licensing or create simplified versions
- Ensure all images comply with licensing requirements for your app distribution
