import 'package:flutter/material.dart';
import 'package:zera3ati_app/screens/call_screen.dart';
import 'package:zera3ati_app/screens/farming_screen.dart';
import 'package:zera3ati_app/screens/market_screen.dart';
import 'package:zera3ati_app/screens/weather_screen.dart';
import 'package:zera3ati_app/widgets/main_drawer.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> {
  int _selectedIndex = 0;
  String selectedCrop = 'Tomato';
  String selectedLandType = 'Desert';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        Get.to(const FarmingScreen());
      }
      if (_selectedIndex == 2) {
        Get.to(WeatherScreen());
      }
      if (_selectedIndex == 3) {
        Get.to(const MarketScreen());
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

  void _saveCropInfo() {
    setState(() {
      // You can use the selectedCrop and selectedLandType here as needed
      Navigator.pop(context); // Close the ModalBottomSheet
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);

    final List<String> landType = [
      'Desert',
      'Muddy',
      'Mountainous',
      'Forest',
      'Tropical',
    ];
    final List<String> crops = [
      'Tomato',
      'Cucumber',
      'Eggplant',
      'Zucchini',
      'Potato',
      'Onion',
      'Watermelon',
      'Cantaloupe',
      'Grapes',
      'Pomegranate',
      'Fig',
      'Date Palm',
    ];

    Widget CropOut() {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$selectedCrop",
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    '$selectedLandType',
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.grass),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 25),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.35,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'What do you plant this season boss...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      DropdownButton(
                                        value: selectedCrop,
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (newValue == null) {
                                              return;
                                            }
                                            selectedCrop = newValue.toString();
                                          });
                                        },
                                        iconEnabledColor: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                        elevation: 10,
                                        dropdownColor: const Color.fromARGB(
                                            255, 61, 79, 88),
                                        enableFeedback: true,
                                        focusColor: Colors.grey,
                                        items: crops.map((crop) {
                                          return DropdownMenuItem<String>(
                                            value: crop,
                                            child: Text(
                                              crop,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      const Text(
                                        'Pick the crop',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 36),
                                  Column(
                                    children: [
                                      DropdownButton(
                                        value: selectedLandType,
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (newValue == null) {
                                              return;
                                            }
                                            selectedLandType =
                                                newValue.toString();
                                          });
                                        },
                                        iconEnabledColor: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                        elevation: 10,
                                        dropdownColor: Colors.brown,
                                        enableFeedback: true,
                                        focusColor: Colors.grey,
                                        items: landType.map((land) {
                                          return DropdownMenuItem<String>(
                                            value: land,
                                            child: Text(
                                              land,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      const Text(
                                        'Select land type',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    onPressed: _saveCropInfo,
                                    label: const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color.fromARGB(255, 76, 146, 79),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Color.fromARGB(255, 97, 27, 22),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      color: Color.fromARGB(255, 177, 46, 37),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    label: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 66,
        width: 66,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(CallScreen());
          },
          child: const Icon(Icons.call, size: 36),
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
                image: const AssetImage('assets/background_dark.jpg'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CropOut()],
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
