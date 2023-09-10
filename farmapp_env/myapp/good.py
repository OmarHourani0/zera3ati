import cv2
import numpy as np
from keras.models import load_model
from sklearn.preprocessing import LabelBinarizer
from keras.preprocessing.image import img_to_array
import argparse
import io

# Argument parser setup
parser = argparse.ArgumentParser(description='Predict class of the input image blob.')
parser.add_argument('image_blob', type=str, help='Path to the image blob.')
args = parser.parse_args()

# Load the saved model
model = load_model("cnn_model.h5")

# Load the classes for the label binarizer
classes_ = np.load("label_binarizer.npy")

# Read the image blob
with open(args.image_blob, "rb") as f:
    image_blob = f.read()

# Convert the image blob to a NumPy array
np_image = np.frombuffer(image_blob, dtype=np.uint8)

# Decode the image using OpenCV
image = cv2.imdecode(np_image, cv2.IMREAD_COLOR)

default_image_size = (256, 256)

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

# Print the predicted class
print(f"Predicted class: {predicted_class}")
