import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PimPamPoum extends StatefulWidget {
  // constructeur pour afficher les détails
  PimPamPoum() {}

  // creatState
  @override
  _PimPamPoumState createState() => new _PimPamPoumState();
}

class _PimPamPoumState extends State<PimPamPoum> {
  // constructeurs du state
  _PimPamPoumState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Regle du Pim Pam Poum !"),
          centerTitle: true,
        ),
        body: new Center(
            child: new Text(
                "Dans un premier temps il faut désigner un sens de jeu (comme dans quasiment tous les jeux à boire on est d’accord). Les règles de ce jeu sont simples, un joueur doit dire PIM, le suivant doit suivre avec PAM, et le suivant doit dire POUM en désignant une personne de son choix dans le jeu… et c’est reparti la personne désignée doit dire PIM, la personne à côté doit dire PAM et ainsi de suite. La personne qui perd, se trompe de sens, ainsi que toutes les personnes l’auront suivi doivent boire.")));
  }
} // _PimPamPoumState
