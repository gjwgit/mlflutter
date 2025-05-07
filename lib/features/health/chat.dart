import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlflutter/features/health/chat/chat_interface.dart';
import 'package:mlflutter/features/health/chat/file/service/page.dart';

class HealthChat extends StatefulWidget {
  @override
  _HealthChatState createState() => _HealthChatState();
}

class _HealthChatState extends State<HealthChat> {
  bool _disclaimerShownThisSession = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ChatPage(),
    const FileService(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disclaimerShownThisSession) {
        _showDisclaimer();
        _disclaimerShownThisSession = true;
      }
    });
  }

  Future<void> _showDisclaimer() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Disclaimer'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: const Text(
            'This chat is for informational purposes only and does not constitute professional medical advice. '
            'Please consult a qualified healthcare provider for professional guidance.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // if you want it centered
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Health Chat'),
            const SizedBox(width: 8),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.info_outline, size: 20),
              onPressed: _showDisclaimer,
              tooltip: 'Disclaimer',
            ),
          ],
        ),
        // you can then drop your actions list if you don't need any extra icons over on the right.
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
