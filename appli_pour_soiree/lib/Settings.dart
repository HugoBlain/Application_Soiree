import 'package:appli_pour_soiree/MyTheme.dart';
import 'package:appli_pour_soiree/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// vue principale pour ajouter/supprimer
class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

@override
class _Settings extends State<Settings> {
  bool isDark = currentTheme.getState();

  Widget build(BuildContext context) {
    double hauteur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Settings"),
          centerTitle: true,
        ),
        // first container to get a black background and insert padding
        body: new Container(
            color: Theme.of(context).backgroundColor,
            child: new ListView(
              children: [
                Card(
                  color: Theme.of(context).accentColor,
                  child: ListTile(
                    title: Text(
                      'Theme',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    leading: Icon(
                      Icons.brightness_6,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    trailing: Switch(
                        onChanged: (bool value) {
                          setState(() {
                            isDark = value;
                            currentTheme.switchTheme();
                          });
                        },
                        value: isDark),
                  ),
                ),
                // new Row(
                //   children: [
                //     Icon(Icons.brightness_6,
                //         color: Theme.of(context).textTheme.bodyText1.color),
                //     Text(
                //       'Theme',
                //       style: TextStyle(
                //           color: Theme.of(context).textTheme.bodyText1.color),
                //     ),
                //     Switch(
                //       onChanged: (bool value) {},
                //       value: isDark,
                //     )
                //   ],
                // )
              ],
            )));
  }
}
