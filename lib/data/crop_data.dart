import 'package:flutter/material.dart';

class CropData extends StatelessWidget {
  CropData();

  List<String> jordanCrops = [
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
    // Add more crops as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: jordanCrops
          .map(
            (crop) => Text(
              crop,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
          .toList(),
    );
  }
}
