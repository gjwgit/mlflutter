import 'package:flutter/material.dart';
import 'package:mlflutter/features/health/chat/chat_interface.dart';
import 'package:mlflutter/features/health/chat/file/service/page.dart';

class HealthChat extends StatefulWidget {
  @override
  _HealthChatState createState() => _HealthChatState();
}

class _HealthChatState extends State<HealthChat> {
  int _selectedIndex = 0;

  // Define the widget for each subpage
  final List<Widget> _pages = [
    const ChatPage(),
    const FileService(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Chat')),
      body: _pages[_selectedIndex],
  bottomNavigationBar: Container(
    // match the BottomNavigationBar’s default height
    // height: kBottomNavigationBarHeight,
    child: Stack(
      children: [
        BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open),
              label: 'Browse Files',
            ),
          ],
        ),

        // vertical divider in the middle
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 0.5, 
          top: 8,    // adjust to control vertical padding
          bottom: 8, // adjust to control vertical padding
          child: Container(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    ),
  ),
    );
  }
}
