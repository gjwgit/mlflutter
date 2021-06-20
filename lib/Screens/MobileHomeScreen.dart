import 'package:mlflutter/Modules/Data.dart';
import 'package:mlflutter/Modules/Room.dart';
import 'package:mlflutter/Widgets/RoomContainer.dart';
import 'package:flutter/material.dart';
import "dart:math";

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
                // Generate two random members to showcase at Home.
                var rng = new Random();
                int rm1 = rng.nextInt(room.audience.length);
                int rm2 = rng.nextInt(room.audience.length);
                if (rm1 == rm2) rm2 = (rm2+1)%room.audience.length;
                var rm = [rm1,rm2];
                return RoomContainer(
                  room: room,
                  showcase: rm,
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
