import 'dart:math';

import 'package:appli_pour_soiree/config.dart';
import 'package:flutter/material.dart';

class Piccolo extends StatefulWidget {
  // attributs
  List<String> players;

  // constructor
  Piccolo(List<String> players) {
    this.players = players;
    if (players.isEmpty) {
      players.add('Personne');
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _Piccolo(players);
  }
}

class _Piccolo extends State<Piccolo> {
  // attributs
  List<String> players;
  int turnEvent = Random(null).nextInt(8);
  String currentTile = 'appuie sur l\'écran pour continuer';
  Color bckgColor, textColor;
  // constructor
  _Piccolo(List<String> players) {
    this.players = players;
    bckgColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    textColor =
        (((bckgColor.blue + bckgColor.green + bckgColor.red) / 3) <= 127)
            ? textColor = Colors.white
            : textColor = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Piccolo',
      //   ),
      // ),
      body: Container(
        color: bckgColor,
        child: FlatButton(
          onPressed: () {
            setState(() {
              currentTile = cards.elementAt(Random(null).nextInt(cards.length));
              bckgColor = Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0);
              textColor =
                  (((bckgColor.blue + bckgColor.green + bckgColor.red) / 3) <=
                          127)
                      ? textColor = Colors.white
                      : textColor = Colors.black;
            });
          },
          child: Text(
            currentTile,
            style: TextStyle(color: textColor),
          ),
          height: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_back,
        ),
        elevation: 0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
