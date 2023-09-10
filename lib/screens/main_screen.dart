import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zera3ati_app/screens/call_option_screen.dart';
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

class CropInfo {
  final String crop;
  final String landType;
  CropInfo(this.crop, this.landType);
}

class _MainScreen extends State<MainScreen> {
  int _selectedIndex = 0;
  String selectedCrop = 'Tomato';
  String selectedLandType = 'Desert';
  final List<CropInfo> pickedCrops = [];

  double _getModalHeight(BuildContext context) {
    // Calculate height based on the screen height
    // For instance, use 80% of the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.8;
  }

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
      final newCropInfo = CropInfo(selectedCrop, selectedLandType);
      pickedCrops.add(newCropInfo);
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
      return SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: ListView.builder(
            itemCount: pickedCrops.length,
            itemBuilder: (context, index) {
              final cropInfo = pickedCrops[index];
              final itemKey = UniqueKey(); // Unique key for each item
              return Builder(builder: (BuildContext context) {
                return Dismissible(
                  key: itemKey,
                  onDismissed: (Direction) {
                    setState(() {
                      pickedCrops.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${cropInfo.crop} is removed"),
                          action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                setState(() {
                                  pickedCrops.insert(index, cropInfo);
                                });
                              }),
                        ),
                      );
                    });
                  },
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cropInfo.crop}",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Text(
                                '${cropInfo.landType}',
                                style: TextStyle(color: Colors.white),
                              ),
                              const Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.grass),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      );
    }

    // Widget CropOut() {
    //   return Expanded(
    //     child: ListView.builder(
    //       itemCount: pickedCrops.length,
    //       itemBuilder: (context, index) {
    //         final cropInfo = pickedCrops[index];
    //         final itemKey =
    //             Key('$cropInfo.crop_$index'); // Unique key for each item

    //         return Dismissible(
    //           //key: ValueKey(pickedCrops[index]),
    //           key: itemKey,
    //           onDismissed: (direction) {
    //             setState(() {
    //               pickedCrops.removeAt(index);
    //             });
    //           },
    //           background: Container(
    //             color: Colors.red, // You can customize the background color
    //             alignment: Alignment.centerLeft,
    //             child: Icon(
    //               Icons.delete,
    //               color: Colors.white,
    //             ),
    //           ),
    //           direction: DismissDirection.startToEnd,
    //         );
    //       },
    //       children: pickedCrops.map((cropInfo) {
    //         return Card(
    //           child: Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   "${cropInfo.crop}",
    //                   style: TextStyle(color: Colors.white),
    //                 ),
    //                 const SizedBox(
    //                   height: 4,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Text(
    //                       '${cropInfo.landType}',
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     const Spacer(),
    //                     Row(
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         const Icon(Icons.grass),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.account_circle),
        //   ),
        // ],
      ),
      floatingActionButton: SizedBox(
        height: 66,
        width: 66,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              //useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 30, 16, 25),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                      dropdownColor:
                                          const Color.fromARGB(255, 61, 79, 88),
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
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 76, 146, 79),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
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
          child: const Icon(Icons.add, size: 36),
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
          // child: Center(
          //   child: Column(
          //     //crossAxisAlignment: CrossAxisAlignment.start,
          //     //mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Column(children: [
          //         pickedCrops.isEmpty
          //     ? Text(
          //         'Your crop list is empty.', // Your message here
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //         ),
          //       )
          //     : Expanded(
          //         child: Container(
          //           constraints: BoxConstraints(
          //             minHeight: 200, // Adjust the minHeight as needed
          //           ),
          //           child: CropOut(),
          //         ),
          //       ),
          //       ],),
          //     ],
          //   ),
          // ),
          child: Center(
            child: pickedCrops.isEmpty
                ? Column(
                    children: [
                      Text(
                        'Your crop list is empty.', // Your message here
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Info Here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        'BRUH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      // SizedBox(
                      //   height: 280,
                      // ),
                      Expanded(child: CropOut()),
                      SizedBox(
                        height: 83,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: _getModalHeight(context),
                                    ),
                                    child: CallOption(),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: Colors.green[900],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.call,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
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
