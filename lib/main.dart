import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/default_color_scheme.dart';
import 'package:fedco_mbc/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: AppConstants.appTitle,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDefaultColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkDefaultColorScheme,
          ),
          themeMode: currentMode,
          //set debug banner OFF:
          debugShowCheckedModeBanner: false,

          //show the splash screen
          home: const SplashScreen(),
        );
      },
    );
  }
}
