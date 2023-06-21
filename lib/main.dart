import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Provider/view_class.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'Provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var isDarkTheme = prefs.getBool("darkTheme") ?? false;
    var switchView = prefs.getBool("switchView") ?? false;
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((value) => runApp(EasyLocalization(
          supportedLocales: const [
            Locale("en"),
            Locale("tr"),
          ],
          path: "assets/language",
          fallbackLocale: const Locale("en"),
          child: MultiProvider(providers: [
            ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider(isDarkTheme)),
            ChangeNotifierProvider<viewClass>(
              create: (context) => viewClass(switchView),
            ),
          ], child: const MyApp()),
        )));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: value.getTheme(),
        home: const HomePage(),
      );
    });
  }
}
