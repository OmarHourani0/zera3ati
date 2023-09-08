import 'package:flutter/material.dart';
import 'package:zera3ati_app/screens/call_screen.dart';
import 'package:zera3ati_app/screens/farming_screen.dart';
import 'package:zera3ati_app/screens/market_screen.dart';
import 'package:zera3ati_app/screens/weather_screen.dart';
import 'package:zera3ati_app/widgets/main_drawer.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

  void _showInfoMessage() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: Text(
            "LMAOOOO THIS MF NEEDS HELP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      floatingActionButton: SizedBox(
        height: 66,
        width: 66,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(CallScreen());
          },
          child: Icon(Icons.call, size: 36),
          highlightElevation: 20,
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
          isExtended: true,
          enableFeedback: true,
          
        ),
      ),
      drawer: const MainDrawer(),
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
          child: Center(
            child: Text(
              'Hello Farmers!!',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
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
            //label: 'BITCH',
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
      //bottomNavigationBar: navigationBar(page: 0),
    );
  }
}
