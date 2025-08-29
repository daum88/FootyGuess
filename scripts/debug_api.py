import requests
import json

# Test getting file info for a specific file
title = "File:Fc barcelona 1st badge 1899.png"
file_api = f"https://commons.wikimedia.org/w/api.php?action=query&format=json&prop=imageinfo&iiprop=url&titles={title}"

print(f"API URL: {file_api}")
r = requests.get(file_api)
print(f"Status: {r.status_code}")

if r.status_code == 200:
    data = r.json()
    print("Response:")
    print(json.dumps(data, indent=2))
else:
    print(f"Error: {r.text}")
