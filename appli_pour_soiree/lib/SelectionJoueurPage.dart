import 'package:flutter/material.dart';
import 'package:appli_pour_soiree/PimPamPoum.dart';

// vue principale pour ajouter/supprimer
class SelectionJoueurPage extends StatefulWidget {
  SelectionJoueurPage({Key key}) : super(key: key);

  @override
  _SelectionJoueurPage createState() => _SelectionJoueurPage();
}

// state
class _SelectionJoueurPage extends State<SelectionJoueurPage> {
  List<String> players = new List();
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mega Teuf"),
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
                        // color: Color.fromARGB(255, 241, 48, 77),
                        elevation: 10,
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
              Container(
                color: Theme.of(context).primaryColor,
                height: 80,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      width: 15,
                    ),
                    Text("Choisis ton jeu"),
                  ],
                ),
              ),

              //First choice and so on
              ListTile(
                title: Text('Pim Pam Poum'),
                tileColor: Theme.of(context).accentColor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      // on affiche la page du livre
                      // info = false --> on affiche le livre pour potentiellement l'ajouter à sa biblihothèque
                      // info = true --> on affiche juste les détails du livre
                      MaterialPageRoute(builder: (context) => PimPamPoum()));
                },
              ),
              ListTile(
                title: Text('Jeu 2'),
                tileColor: Theme.of(context).accentColor,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}