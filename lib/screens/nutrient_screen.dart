import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zera3ati_app/data/weather_data.dart';
import 'package:zera3ati_app/screens/disease_screen.dart';
import 'package:zera3ati_app/widgets/nutrients_input.dart';
import 'package:http/http.dart' as http;

class NutrientScreen extends StatefulWidget {
  const NutrientScreen({Key? key, required this.id, required this.token})
      : super(key: key);

  final String id;
  final String token;

  @override
  State<StatefulWidget> createState() {
    return _NutrientScreen();
  }
}

// String TokenGetter() {
//   return token.value;
// }

// String IdGetter() {
//   return id.value;
// }

class _NutrientScreen extends State<NutrientScreen> {
  String selectedCrop = 'Tomato';
  String newValuee = 'boo';
  String selectedLandType = 'Desert';
  double temperature = 0.0;
  double humidity = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    selectedCrop = 'Tomato';
  }

  Future<void> _fetchWeatherData() async {
    WeatherController weatherController = WeatherController();
    await weatherController.fetchWeatherData();
    setState(() {
      temperature = weatherController.weatherData.value?.temperature ?? 0.0;
      humidity =
          weatherController.weatherData.value?.humidity.toDouble() ?? 0.0;
    });
  }

  String prediction = '';

  Future<void> _submitData() async {
    final url = 'http://127.0.0.1:8000/submit_crop/';
    final headers = {
      "Authorization": "Token ${widget.token}",
      "Content-Type": "application/json"
    };
    final body = json.encode({
      "N": nitrogenLevel,
      "P": phosphorusLevel,
      "K": potassiumLevel,
      "temperature": temperature,
      "humidity": humidity,
      "ph": phLevel,
      "rainfall": 120,
      // Add other parameters if needed
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("API Response: $jsonResponse"); // Debug print
      setState(() {
        prediction = jsonResponse['prediction'];
      });
      print("Updated Prediction: $prediction"); // Debug print
    } else {
      // Handle error
      print("API Request Failed"); // Debug print
    }
  }

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

  double sulfurLevel = 0.0;
  double calciumLevel = 0.0;
  double magnesiumLevel = 0.0;
  double nitrogenLevel = 0.0;
  double phosphorusLevel = 0.0;
  double potassiumLevel = 0.0;
  double phLevel = 0.0;

  String RatioCalculator(
      double potassiumLevel, double phosphorusLevel, double nitrogenLevel) {
    double npkRatioN = nitrogenLevel / 10;
    double npkRatioP = phosphorusLevel / 10;
    double npkRatioK = potassiumLevel / 10;

    // Format the NPK ratio as a string
    String npkRatioString =
        '${npkRatioN.toStringAsFixed(2)} : ${npkRatioP.toStringAsFixed(2)} : ${npkRatioK.toStringAsFixed(2)}';

    return npkRatioString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrient Managment')),
      body: SingleChildScrollView(
        child: Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 330,
                child: Text(
                  'Please choose your type of land and the levels of nutrients in your soil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(
                height: 34,
              ),
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
                            newValuee = newValue.toString();
                          });
                        },
                        autofocus: false,
                        hint: Text('data'),
                        iconEnabledColor: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 10,
                        dropdownColor: Color.fromARGB(255, 61, 79, 88),
                        enableFeedback: true,
                        focusColor: Colors.grey,
                        items: crops.map((crop) {
                          return DropdownMenuItem<String>(
                            value: crop,
                            child: Text(
                              crop,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                      Text(
                        'Pick the crop',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 36),
                  Column(
                    children: [
                      DropdownButton(
                        value: selectedLandType,
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == null) {
                              return;
                            }
                            selectedLandType = newValue.toString();
                            newValuee = newValue.toString();
                          });
                        },
                        autofocus: false,
                        hint: Text('data'),
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
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                      Text(
                        'Select land type',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // buildNutrientInputRow('Sulfur (S)', sulfurLevel, (value) {
                    //   setState(() {
                    //     sulfurLevel = double.tryParse(value) ?? 0.0;
                    //   });
                    // }),
                    // SizedBox(height: 6),
                    // buildNutrientInputRow('Calcium (Ca)', calciumLevel, (value) {
                    //   setState(() {
                    //     calciumLevel = double.tryParse(value) ?? 0.0;
                    //   });
                    // }),
                    // SizedBox(height: 6),
                    // buildNutrientInputRow('Magnesium (Mg)', magnesiumLevel,
                    //     (value) {
                    //   setState(() {
                    //     magnesiumLevel = double.tryParse(value) ?? 0.0;
                    //   });
                    // }),
                    SizedBox(height: 6),
                    buildNutrientInputRow('Nitrogen (N)', nitrogenLevel,
                        (value) {
                      setState(() {
                        nitrogenLevel = double.tryParse(value) ?? 0.0;
                      });
                    }),
                    SizedBox(height: 6),
                    buildNutrientInputRow('Phosphorus (P)', phosphorusLevel,
                        (value) {
                      setState(() {
                        phosphorusLevel = double.tryParse(value) ?? 0.0;
                      });
                    }),
                    SizedBox(height: 6),
                    buildNutrientInputRow(
                      'Potassium (K)',
                      potassiumLevel,
                      (value) {
                        setState(
                          () {
                            potassiumLevel = double.tryParse(value) ?? 0.0;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'pH Value',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(
                                () {
                                  phLevel = double.tryParse(value) ?? 0.0;
                                },
                              );
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Value',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixText: 'pH',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      _submitData();
                    },
                    label: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                      ),
                    ),
                    icon: const Icon(Icons.check),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 117, 170, 114),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 63, 0, 157).withOpacity(0.55),
                          const Color.fromARGB(255, 63, 0, 157)
                              .withOpacity(0.9),
                        ],
                      ), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //SizedBox(height: 10),
                          Text(
                            'Your NPK ratio:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            RatioCalculator(
                              potassiumLevel,
                              phosphorusLevel,
                              nitrogenLevel,
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  //height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 0, 145, 212)
                            .withOpacity(0.55),
                        const Color.fromARGB(255, 0, 145, 212).withOpacity(0.9),
                      ],
                    ), // Set the background color
                    borderRadius:
                        BorderRadius.circular(10), // Add rounded corners
                  ),
                  padding:
                      const EdgeInsets.all(16), // Add padding inside the box
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What you should grow this season',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "You should grow $prediction",
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
              SizedBox(height: 26),
            ],
          );
        }),
      ),
    );
  }
}
