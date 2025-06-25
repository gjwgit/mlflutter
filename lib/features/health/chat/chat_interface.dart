/// Page for chat interface.
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mlflutter/models/chat_message.dart';
import 'package:mlflutter/providers/health_chat/chat_provider.dart';
import 'package:mlflutter/widgets/health_chat/chat_message_bubble.dart';
import 'package:mlflutter/widgets/health_chat/chat_input_field.dart';
import 'package:mlflutter/constants/chat.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  // Controller for the chat input field
  final TextEditingController _controller = TextEditingController();

  // Focus node for the input field to control focus
  final FocusNode _focusNode = FocusNode();

  // Controller for the scroll view
  final ScrollController _scrollController = ScrollController();

  // State for whether context (extra information) is enabled
  bool _contextEnabled = true;

  // State for whether context (extra information) is available
  bool _contextAvailable = false;

  /// Method to scroll to the bottom of the chat when a new message is added
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkContextAvailability();
  }

  /// Method to check if context data is available in the local file system
  Future<void> _checkContextAvailability() async {
    final contextDir = Directory(contextDirPath);
    final exists = await contextDir.exists();
    final hasFiles = exists && contextDir.listSync().isNotEmpty;

    setState(() {
      _contextAvailable = hasFiles;
      _contextEnabled = hasFiles;
    });
  }

  /// Method to handle sending the message
  void _onSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text, _contextEnabled);
    _controller.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the messages from the provider
    final List<ChatMessage> messages = ref.watch(chatProvider);
    // Check if the LLM is currently generating a message
    final bool aiIsLoading = messages.isNotEmpty && messages.last.isLoading;

    // Scroll to the bottom whenever new messages are added
    ref.listen<List<ChatMessage>>(chatProvider, (previous, next) {
      if (previous == null || next.length > previous.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, i) {
                return ChatMessageBubble(message: messages[i]);
              },
            ),
          ),
          const Divider(height: 1),
          ChatInputField(
            controller: _controller,
            focusNode: _focusNode,
            contextEnabled: _contextEnabled,
            contextAvailable: _contextAvailable,
            aiIsLoading: aiIsLoading,
            onSend: _onSend,
            onToggleContext: (value) {
              setState(() {
                _contextEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
