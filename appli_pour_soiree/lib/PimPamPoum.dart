import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PimPamPoum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double hauteur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Regle du Pim Pam Poum !"),
          centerTitle: true,
        ),
        // first container to get a black background and insert padding
        body: Container(
          color: Theme.of(context).backgroundColor,
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
                    // card's title
                    Text(
                      "Les règles de ce jeu sont simples:",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.8,
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      height: 30,
                    ),
                    // card's body --> rules
                    Text(
                      "Dans un premier temps, il faut désigner un sens de jeu (comme dans quasiment tous les jeux à boire on est d’accord).\nLe joueur qui commence doit dire PIM, le suivant doit enchainer avec PAM, et le suivant doit dire POUM en désignant une personne de son choix dans le jeu… Et c’est reparti la personne désignée doit repartir avec PIM, la personne à côté doit dire PAM et ainsi de suite.\nLa personne qui perd, se trompe de sens, ainsi que toutes les personnes qui l’auront suivi doivent boire.",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      textScaleFactor: 1.2,
                      textAlign: TextAlign.justify,
                    ),
                    Container(
                      height: 30,
                    ),
                    // card's end --> Bonus
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.whatshot_outlined,
                          size: 40,
                        ),
                        Container(
                          width: 5,
                        ),
                        Text(
                          "Pour corser le jeu",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: 1.3,
                        ),
                      ],
                    ),
                    Text(
                      "Si vous avez bien compris le jeu, vous pouvez rajouter une règle supplémentaire. A tout moment, le joueur qui doit dit POUM peut décider de dire à la place SARCE, toujours en pointant du doigts un autre joueur. Le joueur pointé doit dire le plus vite possible un nom d'animal, s'il se trompe, met trop de temps ou donne un animal déjà dit alors il doit boir. Sinon si il répond correctement, le joueur qui l'a désigner doit boir autant de gorgées qu'il y a de syllabes dans le nom de cet animal.",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      textScaleFactor: 1.2,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          )),
        ));
  }
} // _PimPamPoumState
