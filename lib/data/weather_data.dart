import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zera3ati_app/models/weather_model.dart';

class WeatherController extends GetxController {
  final weatherData = Rx<WeatherModel?>(null);

  Future<void> fetchWeatherData() async {
    const apiKey = 'fad16f0a86346d833a1d6c6e3f714671';
    //const apiKey = '13789aceeae03804769384725d8f63bb';
    const city = 'Amman'; // Change to your desired city
    const apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    final weatherModel = WeatherModel(
      cityName: data['name'],
      temperature: data['main']['temp'],
      weatherDescription: data['weather'][0]['description'],
      humidity: data['main']['humidity'],
      windSpeed: data['wind']['speed'],
    );

    weatherData.value = weatherModel;
  }
}
