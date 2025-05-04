import 'package:agrigo_kia/constants/colors.dart';
import 'package:agrigo_kia/views/auth_page.dart';
import 'package:agrigo_kia/views/home_page.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(userStatus: prefs.getBool('isLoggedIn') ?? false));
  doWhenWindowReady(() {
    var initialSize = Size(1440, 900);
    appWindow.size = initialSize;
    appWindow.minSize = initialSize;
    appWindow.title = "Agrigo";
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  final bool userStatus;

  MyApp({
    Key? key,
    required this.userStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.compact,
        fontFamily: 'GoogleSans',
        inputDecorationTheme: InputDecorationTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                textStyle:
                    MaterialStateProperty.resolveWith((states) => TextStyle(
                          color: Colors.white,
                        )),
                backgroundColor: MaterialStateProperty.resolveWith((states) =>
                    states.contains(MaterialState.disabled) == true
                        ? null
                        : kPrimaryColor),
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => Size(76, 36)))),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: kPrimaryColor,
          selectionColor: kPrimaryColor.withAlpha(50),
        ),
        tabBarTheme: TabBarTheme(
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: kPrimaryColor, width: 2),
              ),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: kPrimaryColor,
            labelPadding: EdgeInsets.all(12),
            unselectedLabelColor: kGreyColor),
      ),
      home: userStatus ? HomePage() : AuthPage(),
    );
  }
}
