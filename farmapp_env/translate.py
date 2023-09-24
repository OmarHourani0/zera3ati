import requests
import json

def translate_with_google(text, target_language):
    API_KEY = 'AIzaSyATDMOqTnKBJa7BiDpZ5F2vjOrrzjsVYjw'  # Replace with your Google API key
    API_ENDPOINT = f'https://translation.googleapis.com/language/translate/v2?key={API_KEY}'

    params = {
        'q': text,
        'target': target_language,
        'source': 'en'  # Assuming source language is English
    }

    response = requests.post(API_ENDPOINT, params=params)
    
    if response.status_code == 200:
        translated_text = json.loads(response.text)['data']['translations'][0]['translatedText']
        return translated_text
    else:
        print(f"Error with status code: {response.status_code}: {response.text}")
        return None

# Example usage
translated_text = translate_with_google("Hello, world!", "ar")
print(translated_text)
