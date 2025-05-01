import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlflutter/features/health/chat/chat_interface.dart';
import 'package:mlflutter/features/health/chat/file/service/page.dart';

class HealthChat extends StatefulWidget {
  @override
  _HealthChatState createState() => _HealthChatState();
}

class _HealthChatState extends State<HealthChat> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const ChatPage(),
    const FileService(),
  ];

  @override
  void initState() {
    super.initState();
    // schedule the disclaimer check after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerIfNeeded();
    });
  }

  Future<void> _showDisclaimerIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('healthDisclaimerSeen') ?? false;
    if (!seen) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Disclaimer'),
          content: const Text(
            'This chat is for informational purposes only and does not constitute professional medical advice. '
            'Please consult a qualified healthcare provider for professional guidance.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('I Understand'),
            ),
          ],
        ),
      );
      await prefs.setBool('healthDisclaimerSeen', true);
    }
  }

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
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 0.5,
              top: 8,
              bottom: 8,
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
