/// Model for a single chat message.
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

// Enum to represent the sender of a message.
enum Sender { user, ai }

class ChatMessage {
  // The sender of the message, either a user or AI.
  final Sender sender;

  // The actual content of the message.
  final String text;

  // A flag to indicate whether the message is loading.
  // Mainly useful for asynchronous operations where the llm might be loading.
  final bool isLoading;

  ChatMessage({
    required this.sender,
    required this.text,
    this.isLoading = false,
  });
}
