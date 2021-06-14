import 'package:mlflutter/Modules/Data.dart';
import 'package:mlflutter/Modules/Room.dart';
import 'package:mlflutter/Widgets/RoomContainer.dart';
import 'package:flutter/material.dart';

class MobileHomeScreen extends StatefulWidget {
  @override
  _MobileHomeScreenState createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                Room room = rooms[index];
                return RoomContainer(
                  room: room,
                );
              },
            ),
            SizedBox(height: 100),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 15,
          left: 15,
          child: Container(
            padding: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: KClubhouseColor.withOpacity(0.8),
                  blurRadius: 1,
                  offset: Offset(0, 25),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
