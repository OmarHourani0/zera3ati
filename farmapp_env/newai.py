import argparse
from joblib import load
import datetime
import pandas as pd
from statsmodels.tsa.arima.model import ARIMA
import warnings
import json
import sys  
import os
sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 1)  # 1 for line-buffered stdout
sys.stdin = os.fdopen(sys.stdin.fileno(), 'r', 1)    # 1 for line-buffered stdin

def predict_for_two_months_ahead(month=None):
    current_year = datetime.datetime.now().year
    current_month = datetime.datetime.now().month
    if current_month >= 11: # Adjusting for two months ahead
        next_month = (current_month + 2) % 12
        if next_month == 1:
            current_year += 1
    else:
        next_month = current_month + 2
    if month is not None:
        month_str_to_num = {
            'January': 1, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6,
            'July': 7, 'August': 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12
        }
        next_month = (month_str_to_num[month] + 1) % 12
        if next_month == 1:
            current_year += 1
    target_date = pd.to_datetime(f"{current_year}-{next_month}-01")
    predictions_for_month = {}
    for crop, model in loaded_data['models'].items():
        crop_data = melted_data[(melted_data['Crop'] == crop) & (melted_data['Date'] <= target_date)].copy()
        crop_data.set_index('Date', inplace=True)
        if crop_data.shape[0] > 5:
            try:
                prediction = model.forecast(steps=2)[-1] # Forecast two steps and take the last one
                predictions_for_month[crop] = prediction
            except:
                continue
    return predictions_for_month

# Load the bundled data
loaded_data = load(r"C:\Users\jacks\Downloads\Central_Ghour_bundled_arima_models_two_months_ahead_function.joblib")

# Ensure the melted_data is available. If not, load it:
melted_data = pd.read_csv(r"C:\Users\jacks\Downloads\central_ghour_cleaned_melted_data.csv")
melted_data['Date'] = pd.to_datetime(melted_data['Date'])

def get_top_n_predictions(n, crops=None, month=None, ascending=False):
    if month is None:
        current_month = datetime.datetime.now().month
        month = {9: "October", 10: "November", 11: "December"}.get(current_month, "January")
    predictions = loaded_data['function'](month)
    if crops:
        predictions = {crop: predictions[crop] for crop in crops if crop in predictions}
    sorted_predictions = sorted(predictions.items(), key=lambda x: x[1], reverse=not ascending)[:n]
    return sorted_predictions

def main():
    specified_month = "February"
    
    parser = argparse.ArgumentParser(description='Get top N crop price predictions.')
    parser.add_argument('--n', type=int, help='Number of top predictions', default=5)
    parser.add_argument('--crops', nargs='+', help='List of crops of interest. E.g. --crops Tomato Mushroom', default=None)
    parser.add_argument('--month', type=str, help='Month for which predictions are needed. E.g. --month February', default=None)

    while True:
        try:
            args, unknown = parser.parse_known_args(input().split())

            output = {
                "top_n_ascending_next_month": get_top_n_predictions(args.n, ascending=True),
                "top_n_ascending_for_month": get_top_n_predictions(args.n, month=args.month) if args.month else [],
                "top_n_ascending_for_specified_crops": get_top_n_predictions(args.n, crops=args.crops)
            }

            print(json.dumps(output, indent=4))
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Get top N crop price predictions.')
    parser.add_argument('--n', type=int, default=5, help='Number of top predictions')
    parser.add_argument('--crops', nargs='+', help='List of crops of interest. E.g. --crops Tomato Mushroom')
    parser.add_argument('--month', type=str, help='Month for which predictions are needed. E.g. --month February')

    while True:
        try:
            args_str = sys.stdin.readline().strip()
            if not args_str:
                print("Received empty input. Waiting for new commands...")
                continue
            args = parser.parse_args(args_str.split())
            output = {
                "top_n_ascending_next_month": get_top_n_predictions(args.n, ascending=True),
                "top_n_ascending_for_month": get_top_n_predictions(args.n, month=args.month) if args.month else [],
                "top_n_ascending_for_specified_crops": get_top_n_predictions(args.n, crops=args.crops)
            }
            print(json.dumps(output, indent=4))
            sys.stdout.flush()
        except Exception as e:
            print(f"Error: {e}")
            sys.stdout.flush()
