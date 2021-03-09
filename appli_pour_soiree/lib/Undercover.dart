import 'dart:ui';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Undercover extends StatefulWidget {
  // attributs
  List<String> players;

  // constructor
  Undercover(List<String> players) {
    this.players = players;
  }

  @override
  State<StatefulWidget> createState() {
    return _Undercover(players);
  }
}

class _Undercover extends State<Undercover> {
  // attributs
  List<String> players;
  int selectedView = 0;
  int indexWhoChooseWords = 0;
  String commonWord = "erreur";
  String undercoverWord = "erreur";

  // list for the game
  List<String> playersGame = [];
  List<String> wordsGame = [];

  // constructor
  _Undercover(List<String> players) {
    this.players = players;
  }

  // display message (error or example)
  Future<Null> displayMessage(
      String title, String body, bool barrierDismiss) async {
    return showDialog(
        context: context,
        barrierDismissible: barrierDismiss,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text(title),
            children: [
              new Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      new Text(
                        body,
                        textAlign: TextAlign.justify,
                      ),
                      new Container(height: 10),
                    ],
                  )),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(),
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: new Text("Retour", textScaleFactor: 1.1)),
                ],
              )
            ],
          );
        });
  }

  // display the word which corresoond to the player
  Future<Null> displayWord(String word) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new SimpleDialog(
            children: [
              new Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  word,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double hauteur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    // views of the page
    List<Widget> views = [
      // 0 --> first view -> welcome
      Container(
        padding: EdgeInsets.only(
            top: hauteur * 0.07,
            bottom: hauteur * 0.07,
            left: largeur * 0.05,
            right: largeur * 0.05),
        child: new Center(
            child: Column(
              children: [
                Image.asset(
                  "images/secret-agent.png",
                  height: hauteur*0.25,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
                Container(height: hauteur * 0.05),
                Text(
                  "Bienvenue!\nConnaissez-vous les règles?",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Container(height: hauteur * 0.05),
                Container(
                  width: largeur * 0.75,
                  height: hauteur * 0.075,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text(
                      "Bien sûr, Go!",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        this.indexWhoChooseWords =
                            new Random().nextInt(players.length);
                        selectedView = 2;
                      });
                    },
                  ),
                ),
                Container(height: hauteur * 0.02),
                Container(
                  width: largeur * 0.75,
                  height: hauteur * 0.075,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text(
                      "Voir les règles",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedView = 1;
                      });
                    },
                  ),
                ),
              ],
            )
        ),
      ),
      // 1 --> rules
      Container(
        padding: EdgeInsets.only(
            top: hauteur * 0.07,
            bottom: hauteur * 0.07,
            left: largeur * 0.05,
            right: largeur * 0.05),
        child: Center(
          child: Card(
            child: Container(
              padding:
                  EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Règles du jeux",
                      textScaleFactor: 2,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(height: hauteur * 0.05),
                    Text(
                      "Au début de chaque manche un joueur est désigné pour choisir deux mots secrets. Parmis les autres joueurs, tous se verront attribuer le même mot sauf un qui aura le second, ce joueur solitaire sera ''l'Undercover''. Bien sûr personne ne connait le mot des autres joueurs et il est interdit de le dire avant le vote final\n\nUne fois que tous joueurs ont pris connaissance de leurs mots le premier tour peut commencer. Après qu'un tirage au sort aura désigner quel joueur commence, chacun leur tour ils devront donné un indice sur leur mot. Le but est de découvrir qui est l'Undercover et pour lui de ne pas se faire demasquer. Bien entendu les indices choisis peuvent rester vagues pour ne pas donner trop d'informations trop vite mais doivent toujours avoir un lien avec le mot du joueur.\n\n On peut ainsi faire 2 ou 3 tours selon si les joueurs arrivent à se faire un avis assez vite ou pas. Pour finir, les joueurs peuvent débattre, se défendre. On procède à un vote et l'Undercover peut se réveler.\n\nTous les joueurs qui se sont trompés et n'ont pas pointé du doigts l'Uncover, boivent 3 gorgées. Si personne n'a démasquer l'Undercover alors il peut distribuer 10 gorgées comme il veut.",
                      textAlign: TextAlign.justify,
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    Container(height: hauteur * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Un exemple ?",
                          textScaleFactor: 1.5,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.help),
                          iconSize: 40,
                          color: Colors.black,
                          onPressed: () {
                            displayMessage(
                                "Voici un exemple de manche",
                                'Pierre est désigné pour choisir les mots, il entre comme mot commun "chat" et comme mot pour l Undercover "chien". Le jeu commence, le tirage au sort choisit Paul qui a le mot commun pour donner le premier indice et il dit "poil". Jack qui est l Undercover, enchaine avec "animal". Chirac qui a donc lui aussi le mot commun comme Paul, finit par "compagnie".\n\nLes joueurs continue ainsi pendant 2 ou 3 tours, débattent de qui ils pensent être l Undercover et finissent par voter.',
                                true);
                          },
                        )
                      ],
                    ),
                    Container(height: hauteur * 0.02),
                    Container(
                      width: largeur * 0.75,
                      height: hauteur * 0.055,
                      child: RaisedButton(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          "Jouer",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                          textScaleFactor: 1.8,
                        ),
                        onPressed: () {
                          setState(() {
                            this.indexWhoChooseWords =
                                new Random().nextInt(players.length);
                            selectedView = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // 2 --> word's selection
      Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: hauteur * 0.07,
                    left: largeur * 0.05,
                    right: largeur * 0.05),
                child: Text(
                  "C'est à " +
                      this.players[this.indexWhoChooseWords] +
                      " de choisir les mots pour les autres",
                  textScaleFactor: 2,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    bottom: hauteur * 0.07,
                    left: largeur * 0.05,
                    right: largeur * 0.05),
                width: largeur * 0.75,
                child: Column(
                  children: [
                    Text(
                      "Mot Commun à tous les joueurs:",
                      textScaleFactor: 1.3,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Container(height: hauteur * 0.02),
                    TextField(
                      onChanged: (String value) {
                        this.commonWord = value;
                        print(value);
                      },
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                      decoration: InputDecoration(
                          fillColor: Theme.of(context).accentColor,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'entrer le mot commun'),
                    ),
                    Container(height: hauteur * 0.05),
                    Text(
                      "Mot de l'Undercover:",
                      textScaleFactor: 1.3,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Container(height: hauteur * 0.02),
                    TextField(
                      onChanged: (String value) {
                        this.undercoverWord = value;
                        print(value);
                      },
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                      decoration: InputDecoration(
                          fillColor: Theme.of(context).accentColor,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: "entrer le mot de l'Undercover"),
                    ),
                    Container(height: hauteur * 0.07),
                    Container(
                      width: largeur * 0.75,
                      height: hauteur * 0.075,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          "Lancer la manche!",
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontWeight: FontWeight.bold),
                          textScaleFactor: 1.7,
                        ),
                        onPressed: () {
                          if (this.commonWord == this.undercoverWord ||
                              this.commonWord == "erreur" ||
                              this.undercoverWord == "erreur") {
                            displayMessage(
                                "Erreur",
                                "Désolé, les mots choisis sont vides ou identiques. Réessayer!",
                                true);
                          } else {
                            setState(() {
                              // clean previous list
                              this.playersGame.clear();
                              this.wordsGame.clear();
                              // build new list which contains player's name and word for the sleeve
                              // index match between the two list and the player who choose the words doesn't play for this sleeve
                              for (int i = 0; i < this.players.length; i++) {
                                if (i != this.indexWhoChooseWords) {
                                  this.playersGame.add(players[i]);
                                  this.wordsGame.add(this.commonWord);
                                }
                              }
                              // draw lots for the player who will be the Undercover
                              this.wordsGame[new Random()
                                      .nextInt(playersGame.length)] =
                                  this.undercoverWord;
                              selectedView = 3;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 3 --> game
      Center(
        child: Container(
          padding: EdgeInsets.only(
              top: hauteur * 0.02,
              bottom: hauteur * 0.05,
              left: largeur * 0.05,
              right: largeur * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                  child: Text(
                    "Decouvrer vos mots chacun votre tour, puis commencer à jouer!",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.8,
                  ),
                ),
              ),
              Container(
                height: hauteur * 0.02,
              ),
              Expanded(
                child: Container(
                    child: GridView.builder(
                        itemCount: this.playersGame.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2 / 1),
                        itemBuilder: (context, index) {
                          return RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Text(
                              this.playersGame[index],
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                  fontWeight: FontWeight.normal),
                              textScaleFactor: 1.4,
                            ),
                            onPressed: () {
                              displayWord(this.wordsGame[index]);
                            },
                          );
                        })
                ),
              ),
              Container(
                height: hauteur * 0.02,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Fin de la manche, choisir de nouveaux mots",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    this.indexWhoChooseWords += 1;
                    if (this.indexWhoChooseWords == players.length) {
                      this.indexWhoChooseWords = 0;
                    }
                    selectedView = 2;
                  });
                },
              ),
            ],
          ),
        ),
      )
    ];

    return Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Undercover"),
        ),
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: views[selectedView],
        )); // scaffold's end
  } // build's end

} // state's end
