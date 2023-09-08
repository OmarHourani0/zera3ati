import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zera3ati_app/screens/farming_screen.dart';
import 'package:zera3ati_app/screens/main_screen.dart';
import 'package:zera3ati_app/screens/weather_screen.dart';
import 'package:zera3ati_app/widgets/market_page_widget.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

//   @override
//   State<MarketScreen> createState(){
//     return _MarketScreen();
// }
  @override
  _MarketScreen createState() {
    return _MarketScreen();
  }
}

class _MarketScreen extends State<MarketScreen> {
  int _selectedIndex = 3;

//   List<Widget> destinations = [
//   MainScreen(),
//   FarmingScreen(),
//   WeatherScreen(),
//   MarketScreen(),
// ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
      if (_selectedIndex == 0) {
        Get.to(const MainScreen());
        _selectedIndex = index;
      }
      if (_selectedIndex == 1) {
        Get.to(const FarmingScreen());
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
        title: const Text("Market"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_dark.jpg'),
                fit: BoxFit.cover),
          ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.fromLTRB(40,30,20,60),
                child: SizedBox(
                  //width: 350,
                  child: Text(
                    'Market data for today...',
                    style: GoogleFonts.lato(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                width: 340,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daily Market Prices',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
              const WeatherWidget(),
              const SizedBox(height: 40),
              SizedBox(
                height: 40,
                width: 340,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Market Trends',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
              const WeatherWidget(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: navigationBar(page: 3),
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
