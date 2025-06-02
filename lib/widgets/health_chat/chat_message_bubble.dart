/// A widget that displays a chat message bubble, distinguishing between user and AI messages.
/// It supports dynamic message content rendering, including a typing indicator when the AI is processing a response.
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

import 'package:mlflutter/models/chat_message.dart';
import 'package:mlflutter/widgets/health_chat/typing_indicator.dart';

class ChatMessageBubble extends StatelessWidget {
  // Message object contains the message content and metadata (e.g., sender, loading state)
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == Sender.user;

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment
              .centerLeft, // Align user messages to the right, AI messages to the left
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // Limit the width of the message bubble to 70% of the screen width
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // Set different background colors for user and AI messages
            color: isUser
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.9)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 16),
            ),
          ),
          child: message.isLoading
              // If the message is loading (AI is typing), show a typing indicator
              ? const TypingIndicator()
              : Text(
                  message.text,
                  style: const TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }
}
