// pages/chat_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mlflutter/models/chat_message.dart';
import 'package:mlflutter/providers/health_chat/chat_provider.dart';
import 'package:mlflutter/widgets/health_chat/chat_message_bubble.dart';
import 'package:mlflutter/widgets/health_chat/chat_input_field.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _contextEnabled = true;
  bool _contextAvailable = false;

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

  Future<void> _checkContextAvailability() async {
    final dir = await getTemporaryDirectory();
    final contextDir = Directory('${dir.path}/mlflutter/data/vector_store');
    final exists = await contextDir.exists();
    final hasFiles = exists && contextDir.listSync().isNotEmpty;

    setState(() {
      _contextAvailable = hasFiles;
      _contextEnabled = hasFiles;
    });
  }

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
    final List<ChatMessage> messages = ref.watch(chatProvider);
    final bool aiIsLoading = messages.isNotEmpty && messages.last.isLoading;

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
