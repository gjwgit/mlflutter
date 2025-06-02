import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

// A message model with loading flag
enum Sender { user, ai }

class ChatMessage {
  final Sender sender;
  final String text;
  final bool isLoading;
  ChatMessage({
    required this.sender,
    required this.text,
    this.isLoading = false,
  });
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>(
  (ref) => ChatNotifier(),
);

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  static const _randomReplies = [
    "That's interesting!",
    "I see!",
    "Can you tell me more?",
    "Oh really?",
    "Hmm, that's something to think about.",
  ];

  Future<void> sendMessage(String text, bool context) async {
    // add user message
    state = [
      ...state,
      ChatMessage(sender: Sender.user, text: text),
    ];
    // add AI-loading message
    state = [
      ...state,
      ChatMessage(sender: Sender.ai, text: '', isLoading: true),
    ];

    // simulate AI reply delay
    // await Future.delayed(const Duration(seconds: 2));
    // final reply = _randomReplies[Random().nextInt(_randomReplies.length)];

    // run mlhub
    ProcessResult result;
    try {
      var cmd_context = '';
      if (context) {
        cmd_context = '--vectorstore-path /tmp/mlflutter/data/vector_store';
      }

      final command = 'ml query health_rag \"$text"\ $cmd_context';

      final envName = 'mlhub';
      final bashCommand = '''
 $command
''';
      result = await Process.run(
        '/bin/bash',
        ['-c', bashCommand],
        runInShell: true,
      );
    } catch (e) {
      result = ProcessResult(0, 1, '', 'Failed to start process: $e');
    }
    final output = result.stdout.toString().trim();
    final error = result.stderr.toString().trim();
    final reply = output.isNotEmpty ? output : error;

    // replace loading placeholder with real reply
    final newState = List<ChatMessage>.from(state);
    newState.removeLast();
    newState.add(ChatMessage(sender: Sender.ai, text: reply));
    state = newState;
  }
}

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _detectorNode = FocusNode(canRequestFocus: false);
  final ScrollController _scrollController = ScrollController();
  bool _contextEnabled = true;
  bool _contextAvailable = false;

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
      _contextEnabled = hasFiles; // Optionally default to ON only if available
    });
  }

  void _onSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Notify the provider (async)
    ref.read(chatProvider.notifier).sendMessage(text, _contextEnabled);

    // clear & refocus
    _controller.clear();
    _focusNode.requestFocus();
    // initial scroll to show placeholder
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
    final List<ChatMessage> messages = ref.watch(chatProvider);
    final bool aiIsLoading = messages.isNotEmpty && messages.last.isLoading;

    ref.listen<List<ChatMessage>>(chatProvider, (previous, next) {
      if (previous == null || next.length > previous.length) {
        _scrollToBottom();
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, i) {
              final msg = messages[i];
              final isUser = msg.sender == Sender.user;

              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        0.7,
                  ),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 16),
                      ),
                    ),
                    child: msg.isLoading
                        ? const TypingIndicator()
                        : Text(
                            msg.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Focus(
          focusNode: _focusNode,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            // Only handle key-down Enter events
            if (event.logicalKey == LogicalKeyboardKey.enter &&
                event is KeyDownEvent) {
              if (HardwareKeyboard.instance.isShiftPressed) {
                return KeyEventResult.ignored;
              } else {
                // Enter → send message
                if (!aiIsLoading) _onSend();
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Tooltip(
                      message: _contextAvailable
                          ? 'Toggle context usage'
                          : 'Context data not available. Download vector store from `Browse Files` page.',
                      child: OutlinedButton.icon(
                        icon: Icon(
                          _contextEnabled ? Icons.check_circle : Icons.cancel,
                          color: _contextEnabled ? Colors.green : Colors.grey,
                        ),
                        label: Text(
                          _contextEnabled ? 'Context: ON' : 'Context: OFF',
                          style: TextStyle(
                            color: _contextEnabled ? Colors.green : Colors.grey,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _contextEnabled ? Colors.green : Colors.grey,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: _contextAvailable
                            ? () {
                                setState(() {
                                  _contextEnabled = !_contextEnabled;
                                });
                              }
                            : null, // disables interaction
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: TextField(
                      // focusNode: _focusNode,
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      // you can still allow up to 5 lines if you like:
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type your message…',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: aiIsLoading ? null : _onSend,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A simple three-dot typing indicator.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _dotOne;
  late final Animation<double> _dotTwo;
  late final Animation<double> _dotThree;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _dotOne = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    );
    _dotTwo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.8, curve: Curves.easeInOut),
    );
    _dotThree = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.9, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: CircleAvatar(
          radius: 4,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(_dotOne),
        _buildDot(_dotTwo),
        _buildDot(_dotThree),
      ],
    );
  }
}
