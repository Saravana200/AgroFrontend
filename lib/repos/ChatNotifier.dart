import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kang/models/LocalModels.dart';
import 'package:kang/repos/providers.dart';

class ChatStateNotifier extends AsyncNotifier<List<ChatMessage>> {
  @override
  FutureOr<List<ChatMessage>> build() => [];

  Future<void> sendMessage(String message) async {
    final now = DateTime.now();
    final current = state.value ?? const <ChatMessage>[];
    final id = current.length + 1;
    final userMessage =
        ChatMessage(id: id, text: message, isUser: true, time: now);
    final awaitMessage = ChatMessage(
        id: id, text: "Awaiting for response.....", isUser: false, time: now);
    state = AsyncData([...current, userMessage, awaitMessage]);
    try {
      final dio = await ref.read(dioProvider);
      final response = await dio.post('/chat', data: {"text": message});
      String content = response.data["reply"];
      final reply = ChatMessage(
          id: id + 1, text: content, isUser: false, time: DateTime.now());
      final list = state.value ?? [];
      list.removeLast();
      state = AsyncData([...list, reply]);
    } on DioException catch (e, st) {
      final errorMessage =
          e.response?.data["detail"] ?? "Unknown error occurred";
      print('Error fetching reply: $errorMessage');
      state = AsyncError(e, st);
      throw Exception(errorMessage);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final chatProvider =
    AsyncNotifierProvider<ChatStateNotifier, List<ChatMessage>>(
        () => ChatStateNotifier());
