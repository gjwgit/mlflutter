import 'package:mlflutter/Modules/Room.dart';
import 'package:mlflutter/Screens/RoomScreen.dart';
import 'package:mlflutter/Widgets/ImageContainer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';

import "dart:math";

class RoomContainer extends StatelessWidget {
  final Room room;
  final showcase;  // The members to showcase on Home.

  const RoomContainer({Key key, this.room, this.showcase}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: RoomScreen(
              room: room,
            ),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54.withOpacity(0.3),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.name,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 100,
                    ),
                    Positioned(
                      right: 0,
                      top: 20,
                      child: ImageContainer(
                        width: 45,
                        height: 45,
                        image: room.audience[showcase[1]].profilePicture,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: ImageContainer(
                        width: 45,
                        height: 45,
                        image: room.audience[showcase[0]].profilePicture,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    room.audience[showcase[index]].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    CupertinoIcons.archivebox, 
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            );
                          }),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            room.audience.length.toString() + ' ',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.archivebox_fill, 
                            color: Colors.grey,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
