import 'package:appli_pour_soiree/BoardGame.dart';
import 'package:appli_pour_soiree/Piccolo.dart';
import 'package:appli_pour_soiree/Settings.dart';
import 'package:flutter/material.dart';
import 'package:appli_pour_soiree/PimPamPoum.dart';
import 'package:appli_pour_soiree/Undercover.dart';

// vue principale pour ajouter/supprimer
class SelectionJoueurPage extends StatefulWidget {
  SelectionJoueurPage({Key key}) : super(key: key);

  @override
  _SelectionJoueurPage createState() => _SelectionJoueurPage();
}

// state
class _SelectionJoueurPage extends State<SelectionJoueurPage> {
  // attributs
  List<String> players = new List();
  var _controller = TextEditingController();

  // to display a message
  // display an exemple for rules
  Future<Null> messageBox(String title, String message, bool barrier) async {
    return showDialog(
        context: context,
        barrierDismissible: barrier,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text(title),
            children: [
              new Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      new Text(
                        message,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mega Teuf"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Swipe pour supprimer un joueur \n Valide avec ton clavier pour ajouter le joueur',
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyText1.color),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                0,
                MediaQuery.of(context).size.height * 0.01,
                0,
                MediaQuery.of(context).size.height * 0.03),
            child: TextField(
              enabled: true,
              controller: _controller,
              onSubmitted: (String value) {
                setState(() {
                  players.add(value);
                  _controller.clear();
                });
              },
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              decoration: InputDecoration(
                  fillColor: Theme.of(context).accentColor,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Nom'),
            ),
            width: MediaQuery.of(context).size.width / 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                String player = players.elementAt(index);
                return Dismissible(
                  key: Key(player),
                  onDismissed: (direction) {
                    setState(() {
                      players.remove(player);
                    });
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('On vire $player'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                    print(players);
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height / 12,
                      child: Card(
                        // elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height / 35)),
                        child: Text(
                          player,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Header of the drawer
              new SizedBox(
                height: 120.0,
                child: new DrawerHeader(
                    child: Center(
                      child: new Text('Choisis ton jeu',
                          style: TextStyle(color: Colors.white)),
                    ),
                    decoration: new BoxDecoration(
                        color: Theme.of(context).primaryColor),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero),
              ),

              //First choice and so on
              ListTile(
                title: Center(child: Text('Pim Pam Poum')),
                tileColor: Theme.of(context).accentColor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PimPamPoum()));
                },
              ),
              ListTile(
                title: Center(child: Text('Piccolo')),
                tileColor: Theme.of(context).accentColor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Piccolo(players)));
                },
              ),
              Container(
                color: Theme.of(context).accentColor,
                child: Container(
                  height: 3,
                  margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
              ListTile(
                title: Center(child: Text("Undercover")),
                tileColor: Theme.of(context).accentColor,
                onTap: () {
                  // close the drawer
                  Navigator.pop(context);
                  // launch the new page
                  if (this.players.length > 3) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Undercover(players)));
                  } else {
                    messageBox(
                        "Erreur",
                        "Désolé, il faut au moins 4 joueurs pour ce jeu.",
                        true);
                  }
                },
              ),
              ListTile(
                title: Center(child: Text('Course plateau')),
                tileColor: Theme.of(context).accentColor,
                onTap: () {
                  // close the drawer
                  Navigator.pop(context);
                  // launch the new page
                  if (this.players.length > 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BoardGame(players)));
                  } else {
                    messageBox(
                        "Erreur",
                        "Désolé, il faut au moins 2 joueurs pour ce jeu.",
                        true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
