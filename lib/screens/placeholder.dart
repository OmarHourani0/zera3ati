// Widget build(BuildContext context) {
//     String selectedCrop = 'Tomato';

//     final List<dynamic> crops = [
//       'Tomato',
//       'Cucumber',
//       'Eggplant',
//       'Zucchini',
//       'Potato',
//       'Onion',
//       'Watermelon',
//       'Cantaloupe',
//       'Grapes',
//       'Pomegranate',
//       'Fig',
//       'Date Palm',
//     ];

//     List<DropdownMenuEntry<dynamic>> dropdownEntries = crops
//         .map(
//           (item) => DropdownMenuEntry<dynamic>(
//             value: item,
//             label: '',
//           ),
//         )
//         .toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Disease Detection')),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 46,
//           ),
//           const Center(
//             child: SizedBox(
//               width: 280,
//               child: Text(
//                 'Please select the crop you want to check:',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 26,
//                 ),
//               ),
//             ),
//           ),
//           DropdownMenu(
//             dropdownMenuEntries: dropdownEntries,

//           ),
//         ],
//       ),
//     );
//   }