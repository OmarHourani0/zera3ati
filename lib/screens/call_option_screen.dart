import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'call_screen.dart';

class CallOption extends StatefulWidget {
  const CallOption(
      {Key? key,
      required this.id,
      required this.token,
      required this.assistantId})
      : super(key: key);

  final String id;
  final String token;
  final int assistantId;

  @override
  State<CallOption> createState() => _CallOptionState();
}

// String TokenGetter() {
//   return token
//       .value; // Assuming token is a RxString or similar reactive variable
// }

// String IdGetter() {
//   return id.value;
// }

class _CallOptionState extends State<CallOption> {
  final List<Map<String, String>> data = [
    {"name": "John", "specialization": "Crop Farming"},
    {"name": "Alice", "specialization": "Livestock Farming"},
    {"name": "Bob", "specialization": "Organic Farming"},
    {"name": "John", "specialization": "Crop Farming"},
    {"name": "Alice", "specialization": "Livestock Farming"},
    {"name": "Bob", "specialization": "Organic Farming"},
  ];

  double _getModalHeight(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.45;
  }

  Future<Map<String, dynamic>> callAssistant(
      String userId, String assistantName) async {
    final url = 'http://127.0.0.1:8000/call_assistant/';
    final requestBody = {
      'user_id': userId,
      'assistant_name': assistantName,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ${widget.token}',
    };

    // Print the request body and headers before sending the request
    print('Request Headers: $headers');
    print('Request Body: ${json.encode(requestBody)}');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData; // <-- This returns the entire Map<String, dynamic>
    } else {
      throw Exception('Failed to load assistant');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Here are the people you can call',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text(
                'Agricultural Specialists:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              height: _getModalHeight(context),
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = data[index];
                    return GestureDetector(
                      onTap: () async {
                        try {
                          final result =
                              await callAssistant(widget.id, item['name']!);
                          print(result['assistant_id']);
                          Get.to(CallScreen(
                            id: widget.id,
                            token: widget.token,
                            assistantId: widget.assistantId,
                          ));
                        } catch (error) {
                          print(error);
                          // Handle the error appropriately
                        }
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(item['name'] ?? ''),
                          subtitle: Text(item['specialization'] ?? ''),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
