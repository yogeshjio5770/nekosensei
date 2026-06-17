import urllib.request
import json

URL1 = "https://raw.githubusercontent.com/Bluskyo/JLPT_Vocabulary/master/N5.json"
URL2 = "https://raw.githubusercontent.com/9elt/jlpt-n5-word-list/master/data/n5.json"

try:
    print(f"Trying {URL1}")
    req = urllib.request.Request(URL1, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode('utf-8'))
        print(f"Success! Loaded {len(data)} items from URL1.")
        # Print sample
        print(data[0])
except Exception as e:
    print(f"Failed URL1: {e}")
    try:
        print(f"Trying {URL2}")
        req = urllib.request.Request(URL2, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode('utf-8'))
            print(f"Success! Loaded {len(data)} items from URL2.")
            print(data[0])
    except Exception as e:
        print(f"Failed URL2: {e}")
