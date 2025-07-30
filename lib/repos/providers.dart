import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kang/repos/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final dioProvider = Provider((ref) async {
  final storage = ref.read(storageProvider);
  final token = await storage.read(key: 'token');

  final headers = <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
  return Dio(BaseOptions(baseUrl: "http://10.0.2.2:8036", headers: headers));
});

final storageProvider = Provider((ref) => FlutterSecureStorage());

final mainApiServiceProvider = Provider<ApiServiceProvider>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiServiceProvider(dio);
});
