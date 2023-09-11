import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zera3ati_app/screens/farming_screen.dart';
import 'package:zera3ati_app/screens/main_screen.dart';
import 'package:zera3ati_app/screens/market_screen.dart';
import 'package:zera3ati_app/screens/weather_screen.dart';

class navigationBar extends StatefulWidget {
  final int page;

  const navigationBar(
      {Key? key,
      required this.id,
      required this.token,
      required this.assistantId,
      required this.page})
      : super(key: key);

  final String id;
  final String token;
  final int assistantId;

  // final int page;

  @override
  State<navigationBar> createState() {
    return _navigationBar();
  }
}

class _navigationBar extends State<navigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.page;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
      if (_selectedIndex == 0) {
        Get.to(MainScreen(
          id: widget.id,
          token: widget.token,
          assistantId: widget.assistantId,
        ));
        _selectedIndex = index;
      }
      if (_selectedIndex == 1) {
        Get.to(FarmingScreen(
          id: widget.id,
          token: widget.token,
          assistantId: widget.assistantId,
        ));
        _selectedIndex = index;
      }
      if (_selectedIndex == 2) {
        Get.to(WeatherScreen(
          id: widget.id,
          token: widget.token,
          assistantId: widget.assistantId,
        ));
        _selectedIndex = index;
      }
      if (_selectedIndex == 3) {
        Get.to(MarketScreen(
          id: widget.id,
          token: widget.token,
          assistantId: widget.assistantId,
        ));
        _selectedIndex = index;
      }
      //_selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
            Icons.grass,
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
      unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 16),
      selectedItemColor: Colors.white, // Color of selected item icon and label
      unselectedItemColor:
          Colors.grey, // Color of unselected item icons and labels
      type: BottomNavigationBarType.fixed, // This is important to make the
    );
  }
}
