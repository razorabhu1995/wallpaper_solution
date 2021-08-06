import 'package:backgroundSolution/widgets/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List imagesPath = [
      "https://images.pexels.com/photos/5778749/pexels-photo-5778749.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/2440061/pexels-photo-2440061.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/2882234/pexels-photo-2882234.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/1192332/pexels-photo-1192332.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
    ];
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Wallpaper",
              style: TextStyle(color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
            ),
            elevation: 0.0
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 10),
                wallPaper(imagesPath, context),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
    );
  }
}