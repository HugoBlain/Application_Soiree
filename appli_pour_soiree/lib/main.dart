import 'package:appli_pour_soiree/config.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './SelectionJoueurPage.dart';

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('theme');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeDark = ThemeData(
      // primarySwatch: MaterialColor(0xfffd5739, color),
      primaryColor: Color.fromARGB(255, 189, 140, 250),
      accentColor: Color.fromARGB(127, 189, 140, 250),
      shadowColor: Colors.white,
      backgroundColor: Colors.black,
      cardColor: Color.fromARGB(255, 189, 140, 250),
      textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    var themeLigth = ThemeData(
      primaryColor: Color.fromARGB(255, 189, 140, 250),
      accentColor: Color.fromARGB(127, 189, 140, 250),
      backgroundColor: Colors.white,
      cardColor: Color.fromARGB(255, 189, 140, 250),
      textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeLigth,
      darkTheme: themeDark,
      themeMode: currentTheme.currentTheme(),
      home: SelectionJoueurPage(),
    );
  }
}
