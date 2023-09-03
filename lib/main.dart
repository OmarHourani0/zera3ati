import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zera3ati_app/screens/login_screen.dart';
import 'package:get/get.dart';
import 'dart:io'; // Import the dart:io package
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets
import 'package:adaptive_theme/adaptive_theme.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 4, 111, 0),
  ),
  //scaffoldBackgroundColor: Color.fromARGB(255, 2, 52, 0),

  textTheme: GoogleFonts.latoTextTheme(),
);


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

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //final isIOS = Platform.isIOS;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      //home: const MainScreen(),
      home: LoginPage(),
    );
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
  }
}
