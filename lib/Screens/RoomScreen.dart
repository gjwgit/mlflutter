import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io' show Platform;

import 'package:mlflutter/Modules/Data.dart';
import 'package:mlflutter/Modules/Room.dart';
import 'package:mlflutter/Widgets/ImageContainer.dart';

class RoomScreen extends StatefulWidget {
  final Room room;

  const RoomScreen({Key key, this.room}) : super(key: key);
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
    ? myString
    : '${myString.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KClubhouseColor,
      body: Center(
        child: Container(
          width: 600,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: ListView(
                          children: [
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.room.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ), // Row
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.room.description == null
                                    ? 'Yet another category of packages.'
                                    : widget.room.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ), // Row
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 30,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: widget.room.audience.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        child: ImageContainer(
                                          width: 50,
                                          height: 50,
                                          image: widget.room.audience[index].profilePicture,
                                        ),
                                        onTap: () {
                                          print("Button tapped $index");
                                          Navigator.pop(context);
                                        },
                                        onDoubleTap: () {
                                          print("Button double tapped $index");
                                        },
                                        onLongPress: () {
                                          print("Button long pressed $index");
                                        },
                                      ),
                                      SizedBox(height: 5),
                                      Expanded(
                                        child: Text(
                                          ' ' +
                                          truncateWithEllipsis(6, widget.room.audience[index].name
                                            .split(' ')[0]), //.substring(0,4),
                                          style: TextStyle(
                                            // FIX ME Small font otherwise text is too wide
                                            fontSize: kIsWeb || ! Platform.isAndroid ? 15 : 8, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_left,
                                  size: 40,
                                ),
                                Text(
                                  "MLHub.AI Rooms",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ), // Text
                              ], // children
                            ), // Row
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
