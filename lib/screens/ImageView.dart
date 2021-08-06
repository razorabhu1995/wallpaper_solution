import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class ImageView extends StatefulWidget {
  final String imgPath;

  ImageView({@required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  
  int homeScreenType = 1;
  int lockScreenType = 2;
  int bothScreenType = 3;
  Stream<String> progressString;
  static const platform = const MethodChannel('com.example.backgroundSolution/wallpaper');

  Future<void> _setWallpaper(imagePath ,int wallpaperType) async {
    try {
      final int result = await platform
          .invokeMethod('setWallpaper', [imagePath, wallpaperType]);
      print('Wallpaper Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaer: '${e.message}'.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.imgPath, fit: BoxFit.cover)
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0)), //this right here
                          child: Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ButtonTheme(
                                    height: 50,
                                    minWidth: double.infinity,
                                    child: FlatButton(
                                      onPressed: () {
                                        _save(homeScreenType);
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            MdiIcons.home
                                          ),
                                          SizedBox(width : 10),
                                          Text(
                                            "Home Screen", style: TextStyle(color: Colors.black87, fontSize: 16, wordSpacing: 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  ButtonTheme(
                                    height: 50,
                                    minWidth: double.infinity,
                                    child: FlatButton(
                                      onPressed: () {
                                        _save(lockScreenType);
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            MdiIcons.lock
                                          ),
                                          SizedBox(width : 10),
                                          Text(
                                            "Lock Screen", style: TextStyle(color: Colors.black87, fontSize: 16, wordSpacing: 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  ButtonTheme(
                                    height: 50,
                                    minWidth: double.infinity,
                                    child: FlatButton(
                                      onPressed: () {
                                        _save(bothScreenType);
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            MdiIcons.wallpaper
                                          ),
                                          SizedBox(width : 10),
                                          Text(
                                            "Both Screens", style: TextStyle(color: Colors.black87, fontSize: 16, wordSpacing: 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Set Wallpaper",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                              ],
                            )),
                      ],
                    )),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _save(int screenType) async {
    await Permission.storage.request();
    print("${widget.imgPath}");
    if(await Permission.storage.request().isGranted){
      final dir = await getExternalStorageDirectory();
      Dio dio = new Dio();
      dio.download(
        widget.imgPath,
        "${dir.path}/myimage.jpeg",
        onReceiveProgress: (rcv, total) {
          print(
              'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        },
        deleteOnError: true,
      ).then((_) {
        _setWallpaper("${dir.path}/myimage.jpeg", screenType);
      });
    }
  }
}
