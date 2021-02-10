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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mega Teuf"),
      ),
      body: new Container(),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            //Header of the drawer
            Container(
              color: Colors.blue,
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
    );
  }
}
