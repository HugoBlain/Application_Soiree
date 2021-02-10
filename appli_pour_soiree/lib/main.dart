import 'package:flutter/material.dart';
import './SelectionJoueurPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(253, 87, 57, .1),
      100: Color.fromRGBO(253, 87, 57, .2),
      200: Color.fromRGBO(253, 87, 57, .3),
      300: Color.fromRGBO(253, 87, 57, .4),
      400: Color.fromRGBO(253, 87, 57, .5),
      500: Color.fromRGBO(253, 87, 57, .6),
      600: Color.fromRGBO(253, 87, 57, .7),
      700: Color.fromRGBO(253, 87, 57, .8),
      800: Color.fromRGBO(253, 87, 57, .9),
      900: Color.fromRGBO(253, 87, 57, 1),
    };
    // dark = factory ThemeData.dark => ThemeData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: MaterialColor(0xfffd5739, color),

        primaryColor: Color.fromARGB(255, 247, 108, 0),
        accentColor: Color.fromARGB(127, 247, 108, 0),

        backgroundColor: Colors.black,

        cardColor: Color.fromARGB(255, 247, 108, 0),
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectionJoueurPage(),
    );
  }
}
