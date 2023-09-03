import 'package:flutter/material.dart';

Widget buildNutrientInputRow(
    String nutrientName, double value, ValueChanged<String> onChanged) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(
          nutrientName,
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
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Value',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
            hintStyle: TextStyle(color: Colors.grey),
            suffixText: 'ppm',
          ),
        ),
      ),
    ],
  );
}
