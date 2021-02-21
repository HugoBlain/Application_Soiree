import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class Face extends StatelessWidget {
  final double zoom;
  final Color color;

  const Face({Key key, this.zoom = 1, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZRect(
      stroke: 50 * zoom,
      width: 50,
      height: 50,
      color: color,
    );
  }
}

// object dot on the dice's faces
class Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZCircle(
      diameter: 15,
      stroke: 0,
      fill: true,
      color: Colors.white,
    );
  }
}

class GroupTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.update,
      children: [
        ZPositioned(translate: ZVector.only(y: -20), child: Dot()),
        ZPositioned(translate: ZVector.only(y: 20), child: Dot()),
      ],
    );
  }
}


class GroupFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.update,
      children: [
        ZPositioned(translate: ZVector.only(x: 20, y: 0), child: GroupTwo()),
        ZPositioned(translate: ZVector.only(x: -20, y: 0), child: GroupTwo()),
      ],
    );
  }
}

class Dice extends StatelessWidget {
  final Color color;
  final double zoom;

  const Dice({Key key, this.zoom = 1, this.color = const Color(0xffF23726)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      children: [
        ZGroup(
          sortMode: SortMode.update,
          children: [
            ZPositioned(
                translate: ZVector.only(z: -25),
                child: Face(zoom: zoom, color: color)),
            ZPositioned(
                translate: ZVector.only(z: 25),
                child: Face(zoom: zoom, color: color)),
            ZPositioned(
                translate: ZVector.only(y: 25),
                rotate: ZVector.only(x: tau / 4),
                child: Face(
                  zoom: zoom,
                  color: color,
                )),
            ZPositioned(
                translate: ZVector.only(y: -25),
                rotate: ZVector.only(x: tau / 4),
                child: Face(zoom: zoom, color: color)),
          ],
        ),
        //one
        ZPositioned(translate: ZVector.only(z: 50), child: Dot()),
        //two
        ZPositioned(
          rotate: ZVector.only(x: tau / 4),
          translate: ZVector.only(y: 50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              ZPositioned(translate: ZVector.only(y: -20), child: Dot()),
              ZPositioned(translate: ZVector.only(y: 20), child: Dot()),
            ],
          ),
        ),
        //three
        ZPositioned(
          rotate: ZVector.only(y: tau / 4),
          translate: ZVector.only(x: 50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              Dot(),
              ZPositioned(translate: ZVector.only(x: 20, y: -20), child: Dot()),
              ZPositioned(translate: ZVector.only(x: -20, y: 20), child: Dot()),
            ],
          ),
        ),
        //four
        ZPositioned(
          rotate: ZVector.only(y: tau / 4),
          translate: ZVector.only(x: -50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              ZPositioned(
                  translate: ZVector.only(x: 20, y: 0), child: GroupTwo()),
              ZPositioned(
                  translate: ZVector.only(x: -20, y: 0), child: GroupTwo()),
            ],
          ),
        ),

        //five
        ZPositioned(
          rotate: ZVector.only(x: tau / 4),
          translate: ZVector.only(y: -50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              Dot(),
              ZPositioned(child: GroupFour()),
            ],
          ),
        ),

        //six
        ZPositioned(
          translate: ZVector.only(z: -50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              ZPositioned(rotate: ZVector.only(z: tau / 4), child: GroupTwo()),
              ZPositioned(child: GroupFour()),
            ],
          ),
        ),
      ],
    );
  }
}