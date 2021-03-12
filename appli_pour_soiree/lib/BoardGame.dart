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
import 'Rules.dart';
import 'config.dart';

class MyDialog extends StatefulWidget {

  int diceValue;
  List<int> playerPosition;
  int currentPlayer;

  MyDialog(int diceValue, List<int> position, int currentPlayer){
    this.diceValue = diceValue;
    this.playerPosition = position;
    this.currentPlayer = currentPlayer;
  }

  @override
  _MyDialogState createState() => new _MyDialogState(this.diceValue, this.playerPosition, this.currentPlayer);
}

class _MyDialogState extends State<MyDialog> with SingleTickerProviderStateMixin {

  // value for the animation
  int diceValue;
  List<int> playerPosition;
  int currentPlayer;

  // for dice's animation
  AnimationController animationController;
  SpringSimulation simulation;
  ZVector rotation = ZVector.zero;
  double zRotation = 0;

  // constructor
  _MyDialogState(int diceValue, List<int> position, int currentPlayer) {
    this.diceValue = diceValue;
    this.playerPosition = position;
    this.currentPlayer = currentPlayer;
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
  //                       0      1      2      3    4     5      6     7      8     9     10    11    12      13     14    15    16     17   18     19    20     21   22       23    24    25   26    27   28       29   30     31     32    33     34    35     36    37     38    39    40   41      42    43    44    45    46    47    48    49    50     51     52     53    54   55     56   57     58    59    60   61     62
  List<double> xFactor =  [14   , 3.3 , 2.755, 2.4 , 2.1 , 1.865, 1.65, 1.49, 1.38, 1.26, 1.17, 1.125, 1.1 , 1.082, 1.079, 1.09, 1.115, 1.16, 1.25, 1.39, 1.545, 1.7 , 1.875, 2.12 , 2.45, 2.84, 3.4 , 4.3, 5.4   ,  6.5, 7.8  , 8.5  , 8.5 , 7.5 ,  6.3, 5.1  ,  4.05,  3.32, 2.79, 2.4 , 2.1 , 1.86 , 1.65, 1.49, 1.37, 1.27, 1.21, 1.19, 1.2 , 1.22, 1.295,  1.408, 1.58, 1.83, 2.11, 2.45, 2.86, 3.4 , 4.3 , 4.8 , 4.5 , 3.9 , 3.25, 3                   ];
  List<double> yFactor =  [1.158, 1.15, 1.15 , 1.15, 1.15, 1.14 , 1.14, 1.14, 1.15, 1.2 , 1.29, 1.42 , 1.59, 1.82 , 2.2  , 2.75, 3.48 , 4.55, 6.9 , 10  ,  10.5, 10.5, 10.5 ,  10.5, 10.5, 10.5, 10.5, 8  , 5.7   ,  4.2,  3.27,  2.6 ,  2.1, 1.79,  1.6, 1.455,  1.37,  1.33, 1.33, 1.33, 1.33, 1.33 , 1.33, 1.33, 1.35, 1.47, 1.68, 1.93, 2.27, 2.75, 3.5  , 4.2   , 4.45, 4.45, 4.45, 4.45, 4.45, 4.25, 3.25, 2.33, 1.93, 1.74, 1.65, 2.5           ];
  List<double> rotation = [0    , 0   , 0    , 0   , 0   , 0    , 0   , 0   , 18  , 33  , 45  , 55   , 65  , 78   , 95   , 106 , 120  , 130 , 145 , 165 ,  180 , 180 , 180  ,  180 , 180 , 180 , 190 , 210,  222  ,  233,   245,  -100,  -77, -60 ,  -45, -35  ,  -23 ,  -10 , 0   , 0   , 0   , 0    , 0   , 5   , 20  , 45  , 65  , 80  , 100 , 115 , 140  , 160   , 180 , 180 , 180 , 180 , 180 , -160, -125, -90 , -55 , -37 , -15 , 0       ];


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

} // custom painter



class RuleDialog extends StatefulWidget {

  String gif;
  String title;
  String rule;

  RuleDialog (String gif, String title, String rule) {
    this.gif = gif;
    this.title = title;
    this.rule = rule;
  }

  @override
  State<StatefulWidget> createState() {
    return new _RuleDialog(this.gif, this.title, this.rule);
  }

}

class _RuleDialog extends State<RuleDialog> {

  String gif;
  String title;
  String rule;

  _RuleDialog (String gif, String title, String rule) {
    this.gif = gif;
    this.title = title;
    this.rule = rule;
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      children: [
        Container(
          height: height*0.5,
          width: width*0.5,
          child: Image.asset(
            this.gif,
          ),
        ),
        Container(
          height: 5,
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.title,
                textScaleFactor: 1.8,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 5,
              ),
              Container(
                width: width*0.5,
                child: Text(
                  this.rule,
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 5,
              ),
            ],
          ),
        )
      ],
    );
  }

}



class BoardGame extends StatefulWidget {

  // attributes
  List<String> players;
  List<int> playerPosition = [];
  // 7 players max
  List<String> imagePaths = ["vodka.png", "jagermeinster.png", "whiskey.png", "gin-tonic.png","champagne.png", "wine.png", "beer.png"];
  Rules ruleList = new Rules();
  int nbrTour = 0;
  int newRule = null;

  // constructor
  BoardGame(List<String> players) {
    this.players = players;
    for(var player in players){
      this.playerPosition.add(0);
    }
    print("BoardGame");
  }

  @override
  State<StatefulWidget> createState() {
    return _BoardGame(this.players, this.playerPosition, this.imagePaths, this.ruleList, this.nbrTour, this.newRule);
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
  List<String> gifPaths;
  Rules ruleList;
  int nbrTour;
  int newRule;


  // constructor
  _BoardGame(List<String> players, List<int> position, List<String> paths, Rules rules, int nbrTour, int newR ) {
    this.players = players;
    this.playerPosition = position;
    this.imagePaths = paths;
    this.ruleList = rules;
    this.nbrTour = nbrTour;
    this.newRule = newR;
    print("BoardGame state");
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
    bool isDark = currentTheme.getState();
    if(isDark){
      data = await rootBundle.load("images/GameOfGooseBoard-white.png");
    }
    else {
      data = await rootBundle.load("images/GameOfGooseBoard-black-colors.png");
    }
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

  // does an action according to the square on which the player has fallen
  void play(int index) {
    switch(index) {
      case 15 : { this.newRule = this.currentPlayer; } break;
      case 30 : { this.newRule = this.currentPlayer; } break;
      case 45 : { this.newRule = this.currentPlayer; } break;
      default : { print("Case pas importante"); } break;
    }
  }


  @override
  Widget build(BuildContext context) {

    double hauteur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 3,
          child: Icon(
            Icons.arrow_back_ios_outlined
          ),
          onPressed: () async {
            bool quit = await showDialog(
              context: this.context,
              builder: (_) =>  AlertDialog(
                title: Text("Voulez-vous vraiment quitter le jeux?"),
                actions: [
                  new TextButton(
                    child: new Text("Annuler", textScaleFactor: 1.4,),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  new TextButton(
                    child: new Text("Quitter", textScaleFactor: 1.4,),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            );
            print(quit);
            if(quit){
              Navigator.pop(context);
            }
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
                Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        // "onPressed" is async to wait the animation'end to move bottles
                        onPressed: () {
                          // trhow dice
                          this.diceValue = Random().nextInt(6) + 1;
                          print("valeur du dé : " + diceValue.toString());
                          // dice animation --> not work since the flutter MAJ of 03-03-2021
                          /*
                          await showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) {
                                return MyDialog(this.diceValue, this.playerPosition, this.currentPlayer);
                              }
                          );
                           */
                          // snack bar to display the dice value
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Votre lancé: "+this.diceValue.toString(), textAlign: TextAlign.center, textScaleFactor: 1.3,),
                              duration: Duration(milliseconds: 2500),
                              width: largeur*0.3, // Width of the SnackBar.
                              padding: EdgeInsets.symmetric(horizontal: 8.0), // Inner padding for SnackBar content.
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          );
                          int i = 0;
                          Timer.periodic(Duration(milliseconds: 400), (timer) {
                            i++;
                            setState(() {
                              this.playerPosition[this.currentPlayer] += 1;
                              if(this.playerPosition[this.currentPlayer] > 63){
                                this.playerPosition[this.currentPlayer] = 63;
                                timer.cancel();
                              }
                            });
                            if(i == this.diceValue){
                              timer.cancel();
                            }
                          });
                          Timer(Duration(milliseconds: this.diceValue*400+600), () async {
                            // display action
                            await showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) {
                                  String specialMessage = "";
                                  // its a new rule case
                                  if(this.playerPosition[this.currentPlayer] %15 == 0 && this.playerPosition[this.currentPlayer] != 60 ){
                                    // if a rule already exist
                                    if(this.newRule != null){
                                      specialMessage = "Attention "+this.players[this.newRule]+", ta règle prend maintenant fin.\n\n";
                                    }
                                    // we change new rule player in play fonction
                                  }
                                  return RuleDialog("GIF/"+this.ruleList.gif[this.playerPosition[this.currentPlayer]-1], this.ruleList.title[this.playerPosition[this.currentPlayer]-1], specialMessage + this.ruleList.rule[this.playerPosition[this.currentPlayer]-1]);
                                }
                            );
                            // does an action according to the square on which the player has fallen
                            play(this.playerPosition[this.currentPlayer]);
                            // next player
                            setState(() {
                              this.currentPlayer += 1;
                              if(this.currentPlayer == this.players.length){
                                this.currentPlayer = 0;
                              }
                              this.nbrTour += 1;
                            });
                          });
                        },
                      ),
                    ),
                    Container(
                      height: hauteur*0.05,
                    ),
                    Text(
                      this.imagePaths[currentPlayer].split(".")[0]+"\nPosition : " + this.playerPosition[this.currentPlayer].toString(),
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    )
                  ],
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

