import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:zflutter/zflutter.dart';

import 'Dice.dart';

class BoardGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BoardGame();
  }
}

class _BoardGame extends State<BoardGame> with SingleTickerProviderStateMixin {

  AnimationController animationController;
  SpringSimulation simulation;
  // dice's value
  int diceValue = 1;
  ZVector rotation = ZVector.zero;
  double zRotation = 0;

  @override
  void initState() {
    super.initState();

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

    animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
      ..addListener(() {
        // rotation = rotation + ZVector.all(0.1);
        setState(() {});
      });
  }

  // throw a random value for the dice and the animation
  void random() {
    zRotation = Random().nextDouble() * tau;
    diceValue = Random().nextInt(6) + 1;
  }

  @override
  Widget build(BuildContext context) {

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Plateau de jeux"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.threesixty,
        ),
        onPressed: () {
          if (animationController.isAnimating)
            animationController.reset();
          else {
            animationController.forward(from: 0);
            random();
          }
          print("valeur du dé : " + diceValue.toString());
        },
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: ZIllustration(
          // to adjust dice size
          zoom: 1.5,
          children: [
            ZPositioned(
              // to shift the dice in the screen
              //translate: ZVector.only(x: -100 * zoom),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

