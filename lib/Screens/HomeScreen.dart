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
              // backgroundColor: KClubhouseColor,
              // elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MLHub',
                    style: TextStyle(
                      color: Colors.white,
                    ), // TextStyle
                  ), // Text
                  Container(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ), // Icon Search
                        Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ), //Icon
                      ], // children
                    ), // Row
                  ), // Container
                ], // children
              ), // Row
            ) //AppBar
          : AppBar(
              backgroundColor: KClubhouseColor,
              elevation: 0,
              title: Image.asset(
                'assets/clubhouse.png',
                width: 200,
              ), // Image.asset
            ), // AppBar
      body: ResponsiveUI(
        mobile: MobileHomeScreen(),
        web: WebHomeScreen(),
      ), // ResponsieUI
    ); // Scaffold 
  } // build
} // HomeScreen
