import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData selectedTheme;
  late SharedPreferences prefs;

  ThemeData dark = ThemeData.dark(useMaterial3: true).copyWith();
  ThemeData light = ThemeData.light().copyWith();

  ThemeProvider(bool darkThemeOn) {
    selectedTheme = darkThemeOn ? dark : light;
  }

  Future<void> swapTheme() async {
    prefs = await SharedPreferences.getInstance();

    if (selectedTheme == dark) {
      selectedTheme = light;
      await prefs.setBool("darkTheme", false);
    } else {
      selectedTheme = dark;
      await prefs.setBool("darkTheme", true);
    }

    notifyListeners();
  }

  ThemeData getTheme() => selectedTheme;
}
