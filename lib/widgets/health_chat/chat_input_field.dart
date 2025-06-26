/// A widget that provides an input field for chat, with support for context toggling,
/// message sending, and conversation restarting.
///
/// The button to toggle the context will be disabled if the context data is unavailable.
/// The send button will be disabled when the AI is loading a response.
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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mlflutter/providers/health_chat/chat_provider.dart';

class ChatInputField extends ConsumerWidget {
  // Controller for managing the text input field.
  final TextEditingController controller;

  // Focus node for managing focus state of the input field.
  final FocusNode focusNode;

  // Flag to check if context feature is enabled.
  final bool contextEnabled;

  // Flag to check if context data is available.
  final bool contextAvailable;

  // Flag to indicate if LLM is loading a response.
  final bool aiIsLoading;

  // Callback to trigger the sending of a message.
  final VoidCallback onSend;

  // Callback to toggle the context feature on or off.
  final ValueChanged<bool> onToggleContext;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.contextEnabled,
    required this.contextAvailable,
    required this.aiIsLoading,
    required this.onSend,
    required this.onToggleContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Focus(
      focusNode: focusNode,

      // Handles key events
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event.logicalKey == LogicalKeyboardKey.enter &&
            event is KeyDownEvent) {
          if (HardwareKeyboard.instance.isShiftPressed) {
            return KeyEventResult.ignored;
          } else {
            if (!aiIsLoading) onSend();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        child: Row(
          children: [
            // Button to restart the conversation by clearing chat history
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Restart Conversation',
              onPressed: () {
                ref.read(chatProvider.notifier).clear();
              },
            ),

            // Context toggle button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Tooltip(
                  message: contextAvailable
                      ? 'Toggle context usage' // Tooltip when context is available
                      : 'Context data not available.', // Tooltip when context is unavailable
                  child: OutlinedButton.icon(
                    icon: Icon(
                      contextEnabled ? Icons.check_circle : Icons.cancel,
                      color: contextEnabled ? Colors.green : Colors.grey,
                    ),
                    label: Text(
                      contextEnabled ? 'Context: ON' : 'Context: OFF',
                      style: TextStyle(
                        color: contextEnabled ? Colors.green : Colors.grey,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: contextEnabled ? Colors.green : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onPressed: contextAvailable
                        ? () => onToggleContext(!contextEnabled)
                        : null,
                  ),
                ),
              ),
            ),

            // Input field for typing messages
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: TextField(
                  controller: controller,
                  keyboardType:
                      TextInputType.multiline, // Allow multiple lines of input
                  minLines: 1, // Minimum number of lines
                  maxLines: 5, // Maximum number of lines
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
            ),

            // Button to send the message
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: aiIsLoading ? null : onSend,
            ),
          ],
        ),
      ),
    );
  }
}
