import 'dart:math';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  // List of random replies for the AI
  final List<String> _randomReplies = [
    "That's interesting!",
    "I see!",
    "Can you tell me more?",
    "Oh really?",
    "Hmm, that's something to think about."
  ];

  // Function to send a message and then reply randomly
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add the user's message
      _messages.add({"sender": "user", "text": text});
    });
    _controller.clear();

    // Simulate a delay before replying
    Future.delayed(const Duration(milliseconds: 500), () {
      final reply = _randomReplies[Random().nextInt(_randomReplies.length)];
      setState(() {
        _messages.add({"sender": "ai", "text": reply});
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message["sender"] == "user";
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue.shade100 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(message["text"] ?? ''),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        // Input field and send button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Type your message..."
                  ),
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
