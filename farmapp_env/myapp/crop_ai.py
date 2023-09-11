import argparse
import pandas as pd
from sklearn.tree import DecisionTreeClassifier
import joblib
from sklearn.exceptions import DataConversionWarning

# Load the trained model from a file
clf = joblib.load('C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\crop_model.joblib')

# Accept input values from the user and the weather feature
parser = argparse.ArgumentParser()
parser.add_argument("N", type=float, help="Enter the N value")
parser.add_argument("P", type=float, help="Enter the P value")
parser.add_argument("K", type=float, help="Enter the K value")
parser.add_argument("temperature", type=float, help="Enter the temperature in degrees Celsius")
parser.add_argument("humidity", type=float, help="Enter the relative humidity in %")
parser.add_argument("ph", type=float, help="Enter the pH value")
parser.add_argument("rainfall", type=float, help="Enter the rainfall in mm")
args = parser.parse_args()

# Make a prediction using the loaded model
crop = clf.predict([[args.N, args.P, args.K, args.temperature, args.humidity, args.ph, args.rainfall]])
warnings.simplefilter(action='ignore', category=DataConversionWarning)

# Print the predicted crop
print('Recommended crop:', crop[0])