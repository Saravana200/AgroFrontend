// lib/features/chat/chat_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kang/repos/ChatNotifier.dart';
import 'package:kang/widgets/ChatWidgets.dart';

import '../models/LocalModels.dart';

@RoutePage()
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  var length = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatRelay = ref.watch(chatProvider);
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 156, 30, 0.18),
      appBar: AppBar(
        title: Text(
          'Ask the Assistant',
          style: TextStyle(
              fontFamily: 'BitcountSingle', letterSpacing: 1.4, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: Container(
                color: Color.fromRGBO(35, 156, 30, 0.18),
                child: chatRelay.when(
                    data: (List<ChatMessage> data) {
                      setState(() {
                        length = data.length;
                      });
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, count) {
                            final message = data[count];
                            return ChatBubble(
                                text: message.text,
                                isUser: message.isUser,
                                time: message.time);
                          });
                    },
                    error: (Object error, StackTrace stackTrace) {
                      final message = error.toString();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.red.shade600,
                              content: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.error_rounded,
                                      size: 22, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Request failed',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          message,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                textColor: Colors.white,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                              duration: const Duration(seconds: 4),
                            ),
                          );
                      });
                      return const SizedBox.shrink();
                    },
                    loading: () {})),
          ),

          // Input bar
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Ask anything…',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isEmpty) return;
                      ref.read(chatProvider.notifier).sendMessage(text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
