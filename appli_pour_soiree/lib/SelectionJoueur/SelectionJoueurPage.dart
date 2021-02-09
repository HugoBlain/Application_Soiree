import 'package:flutter/material.dart';


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
        title: Text("titre de la app bar"),
      ),
      body: new Container(

      )
    );
  }
}