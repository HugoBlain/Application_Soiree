import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;


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
          height: hauteur*0.6,
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

// to drawn pions on the board
class PionsPainter extends CustomPainter {

  // attributes
  List<String> players;
  List<int> playerPosition = [];
  List<ui.Image> playersImages;
  ui.Image board;
  int currentPlayer;
  //                       0      1      2      3    4     5      6     7      8     9     10    11    12
  List<double> xFactor =  [14   , 3.3 , 2.755, 2.4 , 2.1 , 1.865, 1.65, 1.49, 1.38, 1.26, 1.17, 1.125, 1.1 , 0, 0, 0];
  List<double> yFactor =  [1.158, 1.15, 1.15 , 1.15, 1.15, 1.14 , 1.14, 1.14, 1.15, 1.2 , 1.29, 1.42 , 1.59, 0, 0, 0];
  List<double> rotation = [0    , 0   , 0    , 0   , 0   , 0    , 0   , 0   , 18  , 33  , 45  , 55   , 65  , 0, 0, 0];


  // constructor
  PionsPainter(int curentPlayer, List<String> players, List<ui.Image> playersImages, ui.Image board, List<int> position) {
    this.currentPlayer = curentPlayer;
    this.players = players;
    this.playersImages = playersImages;
    this.board = board;
    this.playerPosition = position;
  }
  
  double inRadians(double degrees){
    return degrees*math.pi /180;
  }


  @override
  void paint(Canvas canvas, Size size) async {
    if(this.playersImages != null){
      print("paint !! ");

      // Define a paint object
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..color = Colors.indigo;

      // display board image
      canvas.drawImage(board, Offset.zero, Paint());

      // players
      for(int i = 0; i<this.players.length; i++){
        canvas.translate(size.width/this.xFactor[this.playerPosition[i]], size.height/this.yFactor[this.playerPosition[i]]);
        canvas.rotate(-inRadians(this.rotation[this.playerPosition[i]]));
        paintImage(
            canvas: canvas,
            rect: Rect.fromCenter(center: Offset(0.0, 0.0), height: 100, width: 100),
            //rect: Rect.fromLTWH(size.width/2, size.height/2, 100, 100),
            image: this.playersImages[i],
            fit: BoxFit.scaleDown,
            repeat: ImageRepeat.noRepeat,
            scale: 1.0,
            alignment: Alignment.center,
            flipHorizontally: false,
            filterQuality: FilterQuality.high
        );
        canvas.rotate(inRadians(this.rotation[this.playerPosition[i]]));
        canvas.translate(-size.width/this.xFactor[this.playerPosition[i]], -size.height/this.yFactor[this.playerPosition[i]]);
      }
    }
  }

  @override
  bool shouldRepaint(PionsPainter oldDelegate) =>
      playerPosition.toString() != oldDelegate.playerPosition.toString();
}





class BoardGame extends StatefulWidget {

  // attributes
  List<String> players;
  List<int> playerPosition = [];
  List<String> imagePaths = ["vodka.png", "jagermeinster.png", "gin-tonic.png", "whiskey.png"];

  // constructor
  BoardGame(List<String> players) {
    this.players = players;
    for(var player in players){
      this.playerPosition.add(0);
  }
  }

  @override
  State<StatefulWidget> createState() {
    return _BoardGame(this.players, this.playerPosition, this.imagePaths);
  }
}

class _BoardGame extends State<BoardGame> with SingleTickerProviderStateMixin {

  // attributes
  List<String> players;
  List<int> playerPosition;
  List<ui.Image> playersImages = [];
  ui.Image board;
  bool loadingCompleted = false;
  int currentPlayer = 0;
  int diceValue = 1;
  List<String> imagePaths;


  // constructor
  _BoardGame(List<String> players, List<int> position, List<String> paths) {
    this.players = players;
    this.playerPosition = position;
    this.imagePaths = paths;
  }

  @override
  void initState(){
    super.initState();
    // landscape view
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // hide system information
    SystemChrome.setEnabledSystemUIOverlays([]);
    // load image to ui.Image
    init();
  }

  // to load and convert image for the canvas
  Future<Null> init() async{
    ByteData data;
    Uint8List list;
    ui.Image img;
    // player's images
    for(int i = 0; i<this.imagePaths.length; i++){
      data = await rootBundle.load("images/"+this.imagePaths[i]);
      list = data.buffer.asUint8List();
      img = await loadImage(new Uint8List.view(data.buffer));
      this.playersImages.add(img);
    }
    // board's image
    data = await rootBundle.load("images/GameOfGooseBoard.png");
    img =  await loadImage(new Uint8List.view(data.buffer));
    this.board = img;
    setState(() {
      this.loadingCompleted = true;
    });
    print("Images ui chargées");
  }
  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }


  @override
  dispose(){
    // portrait view
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // system info
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double hauteur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
        /*
        appBar: AppBar(
          title: Text("Plateau de jeux"),
        ),
        */

        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.arrow_back_ios_outlined
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        body: !this.loadingCompleted ? new Center(child: new SizedBox(width: 100.0, height: 100.0, child: new CircularProgressIndicator(strokeWidth: 10.0,),)) : Container(
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // grid
                Container(
                  width: largeur*0.7,
                  child: FittedBox(
                    child: SizedBox(
                      width: this.board.width.toDouble(),
                      height: this.board.height.toDouble(),
                      child: CustomPaint(
                        painter: PionsPainter(this.currentPlayer, this.players, this.playersImages, this.board, this.playerPosition),
                      ),
                    ),
                  ),
                ),
                // button to play --> next player
                Container(
                  width: largeur*0.25,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        this.players[this.currentPlayer]+",\nà toi de jouer!",
                        textScaleFactor: 1.7,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        // trhow dice
                        diceValue = Random().nextInt(6) + 1;
                        // dice animation
                        showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (_) {
                              return MyDialog(this.diceValue);
                            });
                        print("valeur du dé : " + diceValue.toString());
                        //position ++
                        this.playerPosition[this.currentPlayer] += 1;
                        // next player
                        this.currentPlayer += 1;
                        if(this.currentPlayer == this.players.length){
                          this.currentPlayer = 0;
                        }
                      });
                    },
                  ),
                ),
              ],
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

