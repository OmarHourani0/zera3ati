import 'package:flutter/material.dart';
import 'package:zera3ati_app/screens/disease_screen.dart';
import 'package:zera3ati_app/screens/main_screen.dart';
import 'package:zera3ati_app/screens/market_screen.dart';
import 'package:zera3ati_app/screens/nutrient_screen.dart';
import 'package:zera3ati_app/screens/weather_screen.dart';
import 'package:zera3ati_app/widgets/farming_page_grid.dart';
import 'package:get/get.dart';

class FarmingScreen extends StatefulWidget {
  const FarmingScreen({super.key});

  @override
  State<FarmingScreen> createState() {
    return _FarmingScreen();
  }
}

class _FarmingScreen extends State<FarmingScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Get.to(const MainScreen());
        _selectedIndex = index;
      }
      if (_selectedIndex == 2) {
        Get.to(WeatherScreen());
        _selectedIndex = index;
      }
      if (_selectedIndex == 3) {
        Get.to(const MarketScreen());
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Farming Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black12, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_dark.jpg'),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const SizedBox(
                //width: 350,
                child: Text(
                  'How can we help?',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 65,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      final titles = [
                        "Nutrient Management",
                        "Disease Detection",
                      ];
                      final icons = [
                        Icons.forest_outlined,
                        Icons.bug_report,
                      ];
                      final List<VoidCallback> functionList = [
                        () {
                          Get.to(const NutrientScreen());
                        },
                        () {
                          Get.to(const DiseaseDetectionScreen());
                        },
                      ];
                      return FarmingGridItem(
                        title: titles[index],
                        icon: icons[index],
                        onPressed: functionList[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
