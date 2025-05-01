import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1) Define a provider for your chat state
final chatProvider = StateNotifierProvider<ChatNotifier, List<Map<String, String>>>(
  (ref) => ChatNotifier(),
);

class ChatNotifier extends StateNotifier<List<Map<String, String>>> {
  ChatNotifier() : super([]);

  static const _randomReplies = [
    "That's interesting!",
    "I see!",
    "Can you tell me more?",
    "Oh really?",
    "Hmm, that's something to think about.",
  ];

  void sendMessage(String text) {
    // 1️⃣ add user message
    state = [
      ...state,
      {'sender': 'user', 'text': text},
    ];

    // 2️⃣ simulate AI reply after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final reply = _randomReplies[Random().nextInt(_randomReplies.length)];
      state = [
        ...state,
        {'sender': 'ai', 'text': reply},
      ];
    });
  }
}

// 2) Convert ChatPage to a ConsumerStatefulWidget
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // Scroll to bottom helper
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

  void _onSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Notify the provider
    ref.read(chatProvider.notifier).sendMessage(text);

    // clear & refocus
    _controller.clear();
    _focusNode.requestFocus();

    // then scroll
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
    // Watch the current list of messages
    final messages = ref.watch(chatProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, i) {
              final msg = messages[i];
              final isUser = msg['sender'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(msg['text']!),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Type your message...",
                  ),
                  onSubmitted: (_) => _onSend(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _onSend,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
