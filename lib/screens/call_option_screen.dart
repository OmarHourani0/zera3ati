// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:zera3ati_app/screens/call_screen.dart';

// class CallOption extends StatefulWidget {
//   const CallOption({super.key});

//   @override
//   State<CallOption> createState() => _CallOptionState();
// }

// class _CallOptionState extends State<CallOption> {
//   final List<Map<String, String>> data = [
//     {"name": "John", "specialization": "Crop Farming"},
//     {"name": "Alice", "specialization": "Livestock Farming"},
//     {"name": "Bob", "specialization": "Organic Farming"},
//     {"name": "John", "specialization": "Crop Farming"},
//     {"name": "Alice", "specialization": "Livestock Farming"},
//     {"name": "Bob", "specialization": "Organic Farming"},

//     // Add more data items as needed
//   ];

//   @override
//   Widget build(BuildContext context) {

//     double _getModalHeight(BuildContext context) {
//     // Calculate height based on the screen height
//     // For instance, use 80% of the screen height
//     double screenHeight = MediaQuery.of(context).size.height;
//     return screenHeight * 0.8;
//   }

//     double listViewHeight = _getModalHeight(context);

//     return Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             'Here are the people you can call',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           ListTile(
//             title: Text(
//               'Agricultural Specialists:',
//               style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
//             ),
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.7,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: data.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final item = data[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Get.to(CallScreen());
//                   },
//                   child: Card(
//                     child: ListTile(
//                       title: Text(item['name'] ?? ''),
//                       subtitle: Text(item['specialization'] ?? ''),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zera3ati_app/screens/call_screen.dart';

class CallOption extends StatefulWidget {
  const CallOption({super.key});

  @override
  State<CallOption> createState() => _CallOptionState();
}

class _CallOptionState extends State<CallOption> {
  final List<Map<String, String>> data = [
    {"name": "John", "specialization": "Crop Farming"},
    {"name": "Alice", "specialization": "Livestock Farming"},
    {"name": "Bob", "specialization": "Organic Farming"},
    {"name": "John", "specialization": "Crop Farming"},
    {"name": "Alice", "specialization": "Livestock Farming"},
    {"name": "Bob", "specialization": "Organic Farming"},

    // Add more data items as needed
  ];

  double _getModalHeight(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.45;
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
                      onTap: () {
                        Get.to(CallScreen());
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
