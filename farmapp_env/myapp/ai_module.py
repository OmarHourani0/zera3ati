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
import statsmodels


#print joblib version
print(joblib.__version__)

# Load the saved model
model = load_model(r"C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\cnn_model.h5")
clf = joblib.load(r'C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\crop_model.joblib')
# Load the classes for the label binarizer
classes_ = np.load(r"C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\label_binarizer.npy")

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