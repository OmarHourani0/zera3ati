import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
              child: Column(
                children: [
                  Container(
                    //height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.55),
                          Colors.grey.withOpacity(0.9),
                        ],
                      ), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                    padding:
                        const EdgeInsets.all(16), // Add padding inside the box
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to use Disease Detection',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          //SizedBox(height: 14),
                          Text(
                            '\n1) Upload a photo of the leaf of the plant that has an issue\n\n2) The box will contain the possible problem and it solution',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    //height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey.withOpacity(0.55),
                          Colors.blueGrey.withOpacity(0.9),
                        ],
                      ), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                    padding:
                        const EdgeInsets.all(16), // Add padding inside the box
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to use Nutrient Managment',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          //SizedBox(height: 14),
                          Text(
                            '\n1) Pick the type of soil you have\n\n2) Pick the type of crop you want to grow\n\n3) Fill in the values of Nitrogen, Phosphorus, and Potassium in ppm\n\n4) The text box at the bottom will give you instructions on what to add to your soil to grow your desired produce effeciently',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    //height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 89, 119, 97).withOpacity(0.55),
                          const Color.fromARGB(255, 89, 119, 97).withOpacity(0.9),
                        ],
                      ), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                    padding:
                        const EdgeInsets.all(16), // Add padding inside the box
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to use the Weather screen',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          //SizedBox(height: 14),
                          Text(
                            '\nThe weather screen is there to show you details about the weather that will be enable you to take appropriate actions for the day',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    //height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                           Colors.grey.withOpacity(0.55),
                           Colors.grey.withOpacity(0.9),
                        ],
                      ), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                    padding:
                        const EdgeInsets.all(16), // Add padding inside the box
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to use the Market screen',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          //SizedBox(height: 14),
                          Text(
                            '\nThe Market screen is there to help you know where the market is going. This will minimise your loss because you can plant something that is predicted to have a high return on investment',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
