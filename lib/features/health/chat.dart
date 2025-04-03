import 'package:flutter/material.dart';
import 'package:mlflutter/features/health/chat/chat_interface.dart';
import 'package:mlflutter/features/health/chat/file_browser.dart';
import 'package:mlflutter/features/health/chat/file_browser2.dart';

class HealthChat extends StatefulWidget {
  @override
  _HealthChatState createState() => _HealthChatState();
}

class _HealthChatState extends State<HealthChat> {
  int _selectedIndex = 0;

  // Define the widget for each subpage
  final List<Widget> _pages = [
    const ChatPage(),
    DirectoryBrowserScreen(),
    const Center(child: Text('Subpage 2')),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Highlight color for the selected tab
        unselectedItemColor: Colors.grey, // Color for unselected tabs
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Browse Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            label: 'Subpage 2',
          ),
        ],
      ),
    );
  }
}
