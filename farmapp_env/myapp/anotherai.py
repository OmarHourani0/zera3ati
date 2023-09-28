import pandas as pd
import datetime
from joblib import load

# Define the predict_for_next_month function before loading the .joblib file
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
current_year = datetime.datetime.now().year
current_month = datetime.datetime.now().month

# Calculate the month two months from now
if current_month >= 11:
    two_months_ahead = (current_month + 2) % 12
    if two_months_ahead == 1:
        current_year += 1
else:
    two_months_ahead = current_month + 2

# Convert the month number to month name
month_name_two_months_ahead = datetime.date(current_year, two_months_ahead, 1).strftime('%B')

# Example usage
print("Top 10 Descending for {0}:".format(month_name_two_months_ahead))
print(get_top_n_predictions(10))
print("\nTop 10 Ascending for {0}:".format(month_name_two_months_ahead))
print(get_top_n_predictions(10, ascending=True))

crops_of_interest = ["Tomatoes", "Mushroom", "Basil", "Peas, green", "Broad beans, green"]
user_input = int(input("\nEnter a count for top N predictions from the specified list of crops: "))
print(f"\nTop {user_input} Predictions for Specified Crops for {month_name_two_months_ahead}:")
print(get_top_n_predictions(user_input, crops_of_interest))

specified_month = "February"
print(f"\nTop 10 Descending for {specified_month}:".format(specified_month))
print(get_top_n_predictions(10, month=specified_month))
print(f"\nTop 10 Ascending for {specified_month}:".format(specified_month))
print(get_top_n_predictions(10, month=specified_month, ascending=True))