/// A Notifier that manages the state of a chat conversation, supporting message sending,
/// context toggling, and conversation restarting.
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mlflutter/models/chat_message.dart';

// Used to manage the state of the chat messages.
final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>(
  (ref) => ChatNotifier(),
);

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  // sends a message to the AI and updates the conversation.
  Future<void> sendMessage(String text, bool context) async {
    // Add the user's message to the state (chat history).
    state = [
      ...state,
      ChatMessage(sender: Sender.user, text: text),
    ];

    // placeholder message while llm is responding.
    state = [
      ...state,
      ChatMessage(sender: Sender.ai, text: '', isLoading: true),
    ];

    ProcessResult result;

    try {
      var cmdContext = '';
      if (context) {
        cmdContext = '--vectorstore-path /tmp/mlflutter/data/vector_store';
      }
      final command = 'ml query health_rag "$text" $cmdContext';

      // Run the command in the shell and capture the result.
      result = await Process.run(
        '/bin/bash',
        ['-c', command],
        runInShell: true,
      );
    } catch (e) {
      result = ProcessResult(0, 1, '', 'Failed to start process: $e');
    }

    // Get the AI's response or the error message.
    final output = result.stdout.toString().trim();
    final error = result.stderr.toString().trim();
    final reply = output.isNotEmpty ? output : error;

    // Update state of the conversation.
    final newState = List<ChatMessage>.from(state);
    if (newState.isNotEmpty) {
      newState.removeLast();
    }
    newState.add(ChatMessage(sender: Sender.ai, text: reply));
    state = newState;
  }

  void clear() {
    state = [];
  }
}
