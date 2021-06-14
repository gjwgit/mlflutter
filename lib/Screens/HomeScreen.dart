import 'package:mlflutter/Modules/Data.dart';
import 'package:mlflutter/Screens/MobileHomeScreen.dart';
import 'package:mlflutter/Screens/WebHomeScreen.dart';
import 'package:mlflutter/Widgets/ImageContainer.dart';
import 'package:mlflutter/Widgets/ResponsiveUI.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KClubhouseColor,
      appBar: ResponsiveUI.isMobile(context)
          ? AppBar(
              backgroundColor: KClubhouseColor,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                  Container(
                    width: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                          size: 30,
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 30,
                        ),
                        Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                          size: 30,
                        ),
                        ImageContainer(
                          height: 35,
                          width: 35,
                          image: 'assets/c1.jpg',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : AppBar(
              backgroundColor: KClubhouseColor,
              elevation: 0,
              title: Image.asset(
                'assets/clubhouse.png',
                width: 200,
              ),
            ),
      body: ResponsiveUI(
        mobile: MobileHomeScreen(),
        web: WebHomeScreen(),
      ),
    );
  }
}
