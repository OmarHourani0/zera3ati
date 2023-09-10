// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// final formatter = DateFormat.yMd();

// class NewCrop extends StatefulWidget {
//   const NewCrop({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _NewCrop();
//   }
// }

// class _NewCrop extends State<NewCrop> {

//   final List<String> crops = [
//     'Tomato',
//     'Cucumber',
//     'Eggplant',
//     'Zucchini',
//     'Potato',
//     'Onion',
//     'Watermelon',
//     'Cantaloupe',
//     'Grapes',
//     'Pomegranate',
//     'Fig',
//     'Date Palm',
//   ];


//   void _dialog() {
//     if (Platform.isIOS) {
//       showCupertinoDialog(
//         context: context,
//         builder: (ctx) {
//           return CupertinoAlertDialog(
//             title: const Text(
//               "Invalid Input",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             content: const Text(
//               "The values you entered were invalid please try again.",
//               style: TextStyle(fontSize: 18),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(ctx);
//                 },
//                 child: const Text(
//                   "Okay sorry sir *whimpers* :(",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (ctx) {
//           return AlertDialog(
//             title: const Text(
//               "Invalid Input",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             content: const Text(
//               "The values you entered were invalid please try again.",
//               style: TextStyle(fontSize: 18),
//             ),
//             actions: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     shadowColor: const Color.fromARGB(255, 244, 181, 255)),
//                 onPressed: () {
//                   Navigator.pop(ctx);
//                 },
//                 child: const Text(
//                   "Okay sorry sir *whimpers* :(",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 130, 16, 25),
//       child: ;
//     );
//   }
// }
