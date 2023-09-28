from joblib import load
from datetime import datetime
import pandas as pd
from statsmodels.tsa.arima.model import ARIMA
import warnings
warnings.filterwarnings("ignore")





# Load the data
data_path = r"C:\Users\jacks\Downloads\c_k_cleaned_data.csv"
data = pd.read_csv(data_path)

# Melt the data
melted_data = data.melt(id_vars=['Crop', 'Month'],
                        value_vars=data.columns[2:],
                        var_name='Year',
                        value_name='Price')
melted_data['Year'] = melted_data['Year'].astype(str).str.split('.').str[0].astype(int)
melted_data = melted_data[melted_data['Month'] != 'Average']
melted_data['Date'] = pd.to_datetime(melted_data['Year'].astype(str) + '-' + melted_data['Month'] + '-01')

# Prepare ARIMA models (this part remains unchanged from your provided code)
subset_crops = data['Crop'].unique()
arima_order = (2, 1, 0)
arima_models_dict = {}
for crop in subset_crops:
    crop_data = melted_data[melted_data['Crop'] == crop].copy()
    crop_data.set_index('Date', inplace=True)
    if crop_data.shape[0] > 5:
        try:
            model = ARIMA(crop_data['Price'], order=arima_order)
            model_fit = model.fit()
            arima_models_dict[crop] = model_fit
        except:
            continue

# Define the function to predict prices for the next month
def predict_for_next_month(month=None):
    current_year = datetime.now().year
    current_month = datetime.now().month
    if current_month == 12:
        next_month = 1
        current_year += 1
    else:
        next_month = current_month + 1
    if month is not None:
        month_str_to_num = {
            'January': 1, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6,
            'July': 7, 'August': 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12
        }
        next_month = month_str_to_num[month]
    target_date = pd.to_datetime(f"{current_year}-{next_month}-01")
    predictions_for_month = {}
    for crop, model in arima_models_dict.items():
        crop_data = melted_data[(melted_data['Crop'] == crop) & (melted_data['Date'] <= target_date)].copy()
        crop_data.set_index('Date', inplace=True)
        if crop_data.shape[0] > 5:
            try:
                prediction = model.forecast(steps=1)[0]
                predictions_for_month[crop] = prediction
            except:
                continue
    return predictions_for_month



