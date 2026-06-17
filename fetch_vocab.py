import urllib.request
import json
import os

url = 'https://jlpt-vocab-api.vercel.app/api/words?level=5&limit=1000'

def fetch_data():
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode('utf-8'))

def generate_dart_file(words):
    file_content = """import '../models/lesson_models.dart';

/// Massive N5 Vocabulary expansion auto-generated from API.
class MassiveN5Vocabulary {
  MassiveN5Vocabulary._();

  static const words = <VocabularyItem>[
"""
    # Categories we can roughly guess
    # Usually the API returns 'meaning' and 'word' and 'furigana' or 'romaji'.
    # Let's inspect the first word to see keys.
    count = 0
    for w in words:
        # Expected keys: word, meaning, furigana, romaji, level
        japanese = w.get('word', '').replace("'", "\\'")
        romaji = w.get('romaji', '').replace("'", "\\'")
        english = w.get('meaning', '').replace("'", "\\'")
        furigana = w.get('furigana', '')
        
        # Determine kanji. If word == furigana, no kanji.
        kanji_str = f", kanji: '{japanese}'" if japanese != furigana and furigana != '' else ""
        if not kanji_str and not furigana:
            # Maybe it only has 'word' which is kana.
            japanese = w.get('word', '').replace("'", "\\'")
        elif furigana and japanese != furigana:
            japanese = furigana # Use furigana as the reading (japanese) if kanji exists
            kanji_str = f", kanji: '{w.get('word', '').replace('\'', '\\\'')}'"
            
        # Very rough categorization
        category = 'general'
        lower_en = english.lower()
        if 'to ' in lower_en:
            category = 'verbs'
        elif 'adj' in lower_en or 'is ' in lower_en:
            category = 'adjectives'
        elif 'day' in lower_en or 'month' in lower_en or 'year' in lower_en or 'time' in lower_en:
            category = 'time'
        elif 'one' in lower_en or 'two' in lower_en or 'three' in lower_en or 'number' in lower_en:
            category = 'numbers'
            
        file_content += f"    VocabularyItem(japanese: '{japanese}', romaji: '{romaji}', english: '{english}', category: '{category}'{kanji_str}),\n"
        count += 1

    file_content += """  ];
    
  static const extraCategories = [
    ('general', 'General Vocab', '📝'),
    ('verbs', 'Verbs', '🏃'),
    ('adjectives', 'Adjectives', '✨'),
    ('time', 'Time & Dates', '📅'),
    ('numbers', 'Numbers', '123'),
  ];
}
"""
    return file_content, count

def main():
    print("Fetching from API...")
    data = fetch_data()
    words = data.get('words', [])
    if not words:
        print("No words found in API response.")
        return
        
    print(f"Fetched {len(words)} words.")
    dart_content, count = generate_dart_file(words)
    
    out_path = os.path.join('lib', 'data', 'massive_n5_vocabulary.dart')
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(dart_content)
        
    print(f"Generated {out_path} with {count} words.")

if __name__ == '__main__':
    main()
