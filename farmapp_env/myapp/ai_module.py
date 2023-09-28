import cv2
import numpy as np
from keras.models import load_model
from sklearn.preprocessing import LabelBinarizer
from keras.preprocessing.image import img_to_array
import argparse
import pandas as pd
from sklearn.tree import DecisionTreeClassifier
import joblib
from sklearn.exceptions import DataConversionWarning
import warnings
import json
import requests
from joblib import load
from datetime import datetime
import pandas as pd
from statsmodels.tsa.arima.model import ARIMA
import warnings
import subprocess
import sys
import time
import wexpect as pexpect
# Load the bundled data
# Ensure the melted_data is available. If not, load it:

# Load the saved model
model = load_model(r"C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\cnn_model.h5")
clf = joblib.load(r'C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\crop_model.joblib')
# Load the classes for the label binarizer
classes_ = np.load(r"C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\label_binarizer.npy")

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


default_image_size = (256, 256)

def predict_class(image_path):
    # Load the image
    image = cv2.imread(image_path)
    
    # Resize the image to the default image size
    image = cv2.resize(image, default_image_size)

    # Convert the image to a NumPy array
    image = img_to_array(image)

    # Normalize the image
    image = image.astype("float") / 255.0

    # Make a prediction on the image
    prediction = model.predict(np.array([image]))

    # Decode the prediction manually
    predicted_class = classes_[np.argmax(prediction)]
    
    return predicted_class

def predict_crop(N, P, K, temperature, humidity, ph, rainfall):
    # Make a prediction using the loaded model
    crop = clf.predict([[N, P, K, temperature, humidity, ph, rainfall]])
    warnings.simplefilter(action='ignore', category=DataConversionWarning)
    
    # Print the predicted crop
    
    return crop[0]


####################################################################################################################################################################


def deep_translate_and_save(data, target_language, file_path):
    """Recursively translate all strings in the given data."""

    # Load translations from file
    with open(file_path, 'r', encoding='utf-8') as file:
        translations = json.load(file)

    if isinstance(data, dict):
        return {k: deep_translate_and_save(v, target_language, file_path) for k, v in data.items()}
    elif isinstance(data, list):
        return [deep_translate_and_save(item, target_language, file_path) for item in data]
    elif isinstance(data, str):
        if data in translations:
            return translations[data]
        else:
            translated_data = translate_with_google(data, target_language)
            
            # Add to translations and save back to the file
            translations[data] = translated_data
            with open(file_path, 'w', encoding='utf-8') as file:
                json.dump(translations, file, ensure_ascii=False, indent=4)
            
            return translated_data
    else:
        return data

def translate_response_data(response_data, target_language, file_path=r'C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\dictionary.json'):
    return deep_translate_and_save(response_data, target_language, file_path=r'C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\dictionary.json')


class MarketPrice:
    def __init__(self):
        self.start_process()

    def start_process(self):
        self.process = subprocess.Popen(
            ["powershell", "& python newai.py"], 
            stdin=subprocess.PIPE, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True
        )

    def ensure_process_alive(self):
        if self.process.poll() is not None:  # if subprocess has ended
            self.start_process()
            print("Process was terminated, started a new one.")

    def get_prices(self, language, crops_list=None, specified_month=None):
        n_value = len(crops_list) if crops_list else 5
        cmd_input = f"--n {n_value}"
        if crops_list:
            crops_input = " ".join(crops_list)
            cmd_input += f" --crops {crops_input}"
        if specified_month:
            cmd_input += f" --month {specified_month}"

        self.process.stdin.write(cmd_input + "\r\n")
        self.process.stdin.flush()

        # Read output in a loop until timeout
        timeout = 10  # set a reasonable timeout, e.g., 10 seconds
        start_time = time.time()
        output_lines = []
        while time.time() - start_time < timeout:
            line = self.process.stdout.readline().strip()
            if not line:
                break  # stop if no more output
            output_lines.append(line)

        output = "\n".join(output_lines)

        # Check for errors
        error_output = self.process.stderr.readline().strip()
        if error_output:
            raise Exception(f"Error from subprocess: {error_output}")

        # After reading the output, ensure the subprocess is alive for the next call
        self.ensure_process_alive()

        # Parse the output
        output_json = json.loads(output)
        
        if language == "ar":
            translated_json = translate_response_data(output_json, "ar")
            return translated_json
        else:
            return output_json
