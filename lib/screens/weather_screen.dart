import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zera3ati_app/data/weather_data.dart';
import 'package:zera3ati_app/screens/farming_screen.dart';
import 'package:zera3ati_app/screens/main_screen.dart';
import 'package:zera3ati_app/screens/market_screen.dart';
import 'package:zera3ati_app/widgets/bottom_bar.dart';

class WeatherScreen extends StatelessWidget {
  final weatherController = Get.put(WeatherController());

  WeatherScreen({super.key});

//    List<Widget> destinations = [
//   MainScreen(),
//   FarmingScreen(),
//   WeatherScreen(),
//   MarketScreen(),
// ];

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    _selectedIndex = index;
    if (_selectedIndex == 0) {
      Get.to(const MainScreen());
      _selectedIndex = index;
    }
    if (_selectedIndex == 1) {
      Get.to(const FarmingScreen());
      _selectedIndex = index;
    }
    if (_selectedIndex == 3) {
      Get.to(const MarketScreen());
      _selectedIndex = index;
    }
  }

  Future<void> autoRefresh() {
    return weatherController.fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    autoRefresh();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Weather Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
            child: Row(
              children: [
                Obx(() {
                  if (weatherController.weatherData.value == null) {
                    return const CircularProgressIndicator();
                  } else {
                    final weather = weatherController.weatherData.value!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${weather.temperature.toStringAsFixed(1)}°C'
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          weather.weatherDescription.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }
                }),
                const SizedBox(width: 130),
                const Icon(
                  Icons.cloud,
                  size: 105,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 24, 0, 0),
            child: Obx(
              () {
                if (weatherController.weatherData.value == null) {
                  return const CircularProgressIndicator();
                } else {
                  final weather = weatherController.weatherData.value!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Humidity: ${weather.humidity}%',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Wind Speed: ${(weather.windSpeed * 3.6).toStringAsFixed(0)} km/h',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 0, 145, 212).withOpacity(0.55),
                      const Color.fromARGB(255, 0, 145, 212).withOpacity(0.9),
                    ],
                  ), // Set the background color
                  borderRadius:
                      BorderRadius.circular(10), // Add rounded corners
                ),
                padding: const EdgeInsets.all(16), // Add padding inside the box
                child: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather Summary',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        //make Zaina or Hammad add
                        'You guys will add personalised text here based on today\'s forcast.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'More content...\nYall are gay.\n\n\n\n\n\n\n\n\n\n\nAnd text here too.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () => weatherController.fetchWeatherData(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 74, 134),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                    fixedSize: const Size(200, 70)),
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      //bottomNavigationBar: navigationBar(page: 2),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.agriculture,
            ),
            label: 'Farming',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud,
            ),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money,
            ),
            label: 'Market',
          ),
        ],
        selectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 16),
        unselectedLabelStyle:
            const TextStyle(color: Colors.white, fontSize: 16),
        selectedItemColor:
            Colors.white, // Color of selected item icon and label
        unselectedItemColor:
            Colors.grey, // Color of unselected item icons and labels
        type: BottomNavigationBarType.fixed, // This is important to make the
      ),
    );
  }
}
