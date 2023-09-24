import pandas as pd
from datetime import date
from statsmodels.tsa.arima.model import ARIMA
import pickle
data = pd.read_csv('/content/f_u_cleaned_data.csv')

melted_data = data.melt(id_vars=['Crop', 'Month'],
                        value_vars=data.columns[2:],
                        var_name='Year',
                        value_name='Price')
melted_data['Year'] = melted_data['Year'].astype(str).str.split('.').str[0].astype(int)
melted_data = melted_data[melted_data['Month'] != 'Average']
melted_data['Date'] = pd.to_datetime(melted_data['Year'].astype(str) + '-' + melted_data['Month'] + '-01')
subset_crops = data['Crop'].unique()[:10]
arima_models_dict = {}


predictions_dict = {}
current_date = date.today()

for crop in subset_crops:
    crop_data = melted_data[melted_data['Crop'] == crop].copy()
    crop_data.set_index('Date', inplace=True)
    model = ARIMA(crop_data['Price'], order=(5,1,0))
    model_fit = model.fit()
    arima_models_dict[crop] = model_fit
    prediction = model_fit.predict(start=current_date, end=current_date).iloc[0]
    predictions_dict[crop] = prediction



combined_dict = {
    'models': arima_models_dict,
    'predictions': predictions_dict
}




all_models_predictions_pkl_path = "/content/FarmGatePrice_UpLand_all_arima_models_predictions.pkl"
with open(all_models_predictions_pkl_path, 'wb') as file:
    pickle.dump(combined_dict, file)