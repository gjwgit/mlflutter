import 'package:mlflutter/Modules/Data.dart';
import 'package:mlflutter/Modules/Member.dart';
import 'package:mlflutter/Screens/MobileHomeScreen.dart';
import 'package:mlflutter/Widgets/ImageContainer.dart';
import 'package:mlflutter/Widgets/ResponsiveUI.dart';
import 'package:flutter/material.dart';

class WebHomeScreen extends StatefulWidget {
  @override
  _WebHomeScreenState createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                    ), // Icon
                    title: ResponsiveUI.isTablet(context)
                    ? null
                    : Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ), // TextStyle
                    ), // Text
                  ), // ListTile
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Colors.black,
                      size: 30,
                    ), // Icon
                    title: ResponsiveUI.isTablet(context)
                    ? null
                    : Text(
                      'Survivor',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ), // ListTile 
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: ResponsiveUI.isTablet(context)
                        ? null
                        : Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 600,
          child: MobileHomeScreen(),
        ),
        const Spacer(),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: ListView(
                children: [
                  Text(
                    'All Curated Packages',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      Member member = packages[index];
                      return ListTile(
                        leading: ImageContainer(
                          height: 35,
                          width: 35,
                          image: member.profilePicture,
                        ),
                        title: ResponsiveUI.isTablet(context)
                        ? null
                        : Text(
                          member.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
