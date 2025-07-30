import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kang/models/models.dart';
import 'package:kang/repos/providers.dart';

class GenericStateNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return '';
  }

  Future<void> login(LoginRequest request) async {
    state = const AsyncLoading();
    try {
      final dio = await ref.read(dioProvider);
      final response = await dio.post('/login', data: request.toJson());
      LoginResponse contentType = LoginResponse.fromJson(response.data);
      var token = contentType.token;
      final storage = ref.read(storageProvider);
      await storage.write(key: 'token', value: token);
      state = AsyncData(token);
    } on DioException catch (e, st) {
      final errorMessage =
          e.response?.data["detail"] ?? "Unknown error occurred";
      print('Error fetching image: $errorMessage');
      state = AsyncError(e, st);
      throw Exception(errorMessage);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signUp(LoginRequest request) async {
    state = const AsyncLoading();
    try {
      final dio = await ref.read(dioProvider);
      final response = await dio.post('/signup', data: request.toJson());
      LoginResponse contentType = LoginResponse.fromJson(response.data);
      var token = contentType.token;
      final storage = ref.read(storageProvider);
      await storage.write(key: 'token', value: token);
      state = AsyncData(token);
    } on DioException catch (e, st) {
      final errorMessage =
          e.response?.data["detail"] ?? "Unknown error occurred";
      print('Error fetching token: $errorMessage');
      state = AsyncError(e, st);
      throw Exception(errorMessage);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final genericNotifierProvider =
    AsyncNotifierProvider<GenericStateNotifier, String>(
  () => GenericStateNotifier(),
);
