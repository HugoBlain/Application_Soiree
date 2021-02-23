import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:zflutter/zflutter.dart';

import 'Dice.dart';

class MyDialog extends StatefulWidget {

  int diceValue;

  MyDialog(int diceValue){
    this.diceValue = diceValue;
  }

  @override
  _MyDialogState createState() => new _MyDialogState(this.diceValue);
}

class _MyDialogState extends State<MyDialog> with SingleTickerProviderStateMixin {

  // value for the animation
  int diceValue;

  // for dice's animation
  AnimationController animationController;
  SpringSimulation simulation;
  ZVector rotation = ZVector.zero;
  double zRotation = 0;

  // constructor
  _MyDialogState(int diceValue) {
    this.diceValue = diceValue;
  }

  @override
  void initState() {
    super.initState();
    // for dice's animation
    simulation = SpringSimulation(
      SpringDescription(
        mass: 1,
        stiffness: 20,
        damping: 2,
      ),
      1, // starting point
      0, // ending point
      1, // velocity
    );
    // animation controller
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
      ..addListener(() {
        // rotation = rotation + ZVector.all(0.1);
        setState(() {});
      });
    // lanch the anime
    animationController.forward(from: 0);
  }

  // throw a random value for the animation
  void random() {
    zRotation = Random().nextDouble() * tau;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // attributs
    double hauteur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    final curvedValue = CurvedAnimation(
      curve: Curves.ease,
      parent: animationController,
    );
    final firstHalf = CurvedAnimation(
      curve: Interval(0, 1),
      parent: animationController,
    );
    final secondHalf = CurvedAnimation(
      curve: Interval(0, 0.3),
      parent: animationController,
    );

    final zoom = (simulation.x(animationController.value)).abs() / 2 + 0.5;

    // "body"
    return SimpleDialog(
      // to have dialog with round border
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      children: [
        Container(
          height: hauteur*0.4,
          width: hauteur*0.4,
          child: ZIllustration(
            // to adjust dice size
            zoom: 1.5,
            children: [
              ZPositioned(
                // to shift the dice in the screen
                //translate: ZVector.only(y: -50 * zoom),
                child: ZGroup(
                  children: [
                    ZPositioned(
                      scale: ZVector.all(zoom),
                      rotate: getRotation(diceValue).multiplyScalar(curvedValue.value) -
                          ZVector.all((tau / 2) * (firstHalf.value)) -
                          ZVector.all((tau / 2) * (secondHalf.value)),
                      child: ZPositioned(
                          rotate: ZVector.only(
                              z: -zRotation * 2.1 * (animationController.value)),
                          child: Dice(
                            zoom: zoom,
                            color: Theme.of(context).primaryColor,
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),        ),
      ],
    );
  }
}

class BoardGame extends StatefulWidget {

  // attributes
  List<String> players;

  // constructor
  BoardGame(List<String> players) {
    this.players = players;
  }

  @override
  State<StatefulWidget> createState() {
    return _BoardGame(this.players);
  }
}

class _BoardGame extends State<BoardGame> with SingleTickerProviderStateMixin {

  // attributes
  List<String> players;

  // constructor
  _BoardGame(List<String> players) {
    this.players = players;
  }
  // dice's value
  int diceValue = 1;

  @override
  Widget build(BuildContext context) {

    double hauteur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Plateau de jeux"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.threesixty,
          ),
          onPressed: () {
            diceValue = Random().nextInt(6) + 1;
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (_) {
                  return MyDialog(this.diceValue);
                });
            print("valeur du dé : " + diceValue.toString());
          },
        ),
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Container(
                height: hauteur*0.4,
                width: largeur*0.8,
                child: Center(
                  child: Text(
                    "Voici le résultat",
                  )
                ),
              )
            ),
          ),
        )
    );
  }

} // boardGame state

ZVector getRotation(int num) {
  switch (num) {
    case 1:
      return ZVector.zero;
    case 2:
      return ZVector.only(x: tau / 4);
    case 3:
      return ZVector.only(y: tau / 4);
    case 4:
      return ZVector.only(y: 3 * tau / 4);
    case 5:
      return ZVector.only(x: 3 * tau / 4);
    case 6:
      return ZVector.only(y: tau / 2);
  }
  throw ('num $num is not in the dice');
}

