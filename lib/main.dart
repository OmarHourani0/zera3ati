// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zera3ati_app/screens/login_screen.dart';
import 'package:get/get.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets
// ignore: unused_import
import 'package:flex_color_scheme/flex_color_scheme.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 4, 111, 0),    
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);


//        CHATGPT CODES (they suck ass and we dont have a theme yet)...

// final theme = ThemeData.dark().copyWith(
//   primaryColor: Color.fromARGB(255, 4, 111, 0), // Set primary color
//   hintColor: Color.fromARGB(255, 4, 111, 0), // Set accent color
//   scaffoldBackgroundColor: Colors.grey[900], // Dark background color
//   appBarTheme: AppBarTheme(
//     color: const Color.fromARGB(255, 31, 31, 31), // Dark app bar color
//   ),
//   textTheme: TextTheme(
//     // Text styles
//     displayLarge: TextStyle(
//       fontSize: 24,
//       fontWeight: FontWeight.bold,
//       color: Colors.white, // Text color in dark theme
//     ),
//     bodyLarge: TextStyle(
//       fontSize: 16,
//       color: Colors.white, // Text color in dark theme
//     ),
//   ),
//   buttonTheme: ButtonThemeData(
//     // Button styles
//     buttonColor: Color.fromARGB(255, 4, 111, 0),
//     textTheme: ButtonTextTheme.primary,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8.0),
//     ),
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     // Floating action button style
//     backgroundColor: Color.fromARGB(255, 4, 111, 0),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     // Input field styles
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8.0),
//     ),
//   ),
// );
//.............................................................................................................
// final theme = ThemeData.dark().copyWith(
//   // Define your primary color here
//   primaryColor: Color.fromARGB(255, 4, 111, 0),
//   hintColor: Colors.white, // Customize accent color as needed
//   // Define custom shapes for buttons and text fields
//   buttonTheme: ButtonThemeData(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(30.0),
//       // Adjust the border radius as needed
//     ),
//     height: 40,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: const Color.fromARGB(255, 4, 111, 0),
//     ),
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Colors.black87,
//     elevation: 0,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     border: OutlineInputBorder(
//       borderRadius:
//           BorderRadius.circular(20.0), // Adjust the border radius as needed
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Color.fromARGB(255, 4, 111, 0)),
//       borderRadius:
//           BorderRadius.circular(20.0), // Adjust the border radius as needed
//     ),
//   ),
// );
//.............................................................................................................
// final theme = ThemeData(
//         textTheme: Theme.of(context).textTheme.apply(
//               bodyColor: Colors.white,
//               displayColor: Colors.white,
//             ),
//         colorScheme: ColorScheme.fromSeed(
//           brightness: Brightness.dark,
//           seedColor: const Color.fromARGB(255, 4, 111, 0),
//           //onBackground: const Color.fromARGB(255, 4, 111, 0),
//         ),
//         dropdownMenuTheme: DropdownMenuThemeData(
//           inputDecorationTheme: InputDecorationTheme(
//             alignLabelWithHint: true,
//             activeIndicatorBorder: BorderSide(
//               color: Colors.blueGrey,
//             ),
//           ),
//           menuStyle: MenuStyle(
//             elevation: MaterialStatePropertyAll(15),
//             shape: MaterialStatePropertyAll(
//               BeveledRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ButtonStyle(
//             backgroundColor: MaterialStatePropertyAll(
//               const Color.fromARGB(255, 47, 111, 49),
//             ),
//           ),
//         ));
//.............................................................................................................


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (fn) {
      runApp(
        const ProviderScope(
          child: App(),
        ),
      );
    },
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() {
    return _App();
  }
}

class _App extends State<App> {
  @override
  Widget build(BuildContext context) {
    //final isIOS = Platform.isIOS;
    return GetMaterialApp(
      theme: theme,      
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
    // return isIOS
    //     ? CupertinoApp( // Use CupertinoApp for iOS
    //         debugShowCheckedModeBanner: false,
    //         theme: CupertinoThemeData(
    //           primaryColor: CupertinoColors.activeBlue,
    //           // Customize the Cupertino theme as needed
    //         ),
    //         home: LoginPage(),
    //       )
    //     : GetMaterialApp( // Use GetMaterialApp for other platforms
    //         debugShowCheckedModeBanner: false,
    //         theme: theme,
    //         home: LoginPage(),
    //       );
    // return AdaptiveTheme(
    //   light: ThemeData(
    //     brightness: Brightness.light,
    //     primarySwatch: Colors.lightGreen,
    //     hintColor: Colors.amber,
    //   ),
    //   dark: ThemeData(
    //     brightness: Brightness.dark,
    //     primarySwatch: Colors.lightGreen,
    //     hintColor: Colors.green,
    //   ),
    //   initial: AdaptiveThemeMode.dark,
    //   builder: (theme, darkTheme) => MaterialApp(
    //     title: 'Adaptive Theme Demo',
    //     theme: theme,
    //     darkTheme: darkTheme,
    //     home: LoginPage(),
    //   ),
    // );
//   }
// }
