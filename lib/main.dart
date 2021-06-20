import 'package:flutter/material.dart';

import 'package:mlflutter/Screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MLHub.AI",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
