import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 370,
        //height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 42, 132, 0).withOpacity(0.45),
              const Color.fromARGB(255, 42, 132, 0).withOpacity(0.75),
              const Color.fromARGB(255, 42, 132, 0).withOpacity(0.95),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ), // Set the background color
          borderRadius: BorderRadius.circular(10), // Add rounded corners
        ),
        padding: const EdgeInsets.all(16),
        child: const Row(
          children: [
            SingleChildScrollView(
              child: Text(
                "IDEK WHAT WE WILL ADD HERE\n\n\n\n\n\n\n\n\nAND HERE",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
