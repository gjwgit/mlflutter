/// Page for LLM chat and Solid Pod file browsing.
///
/// Copyright (C) 2025 The Authors
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Arjun Raj

library;

import 'package:flutter/material.dart';

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

  String _getPageSubheading(int index) {
    switch (index) {
      case 0:
        return 'Chat with AI';
      case 1:
        return 'Browse your health files';
      default:
        return '';
    }
  }

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
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Health Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _getPageSubheading(_selectedIndex),
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showDisclaimer,
            tooltip: 'Disclaimer',
          ),
        ],
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
