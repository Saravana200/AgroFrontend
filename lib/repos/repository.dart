import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kang/models/models.dart';
import 'package:kang/repos/providers.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


class ApiServiceProvider {
  final dio;

  ApiServiceProvider(this.dio);

  Future<NewsResponse> NewsRequest() async {
    try {
      final response = await dio.get('/news', data: {});
      NewsResponse data = NewsResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["detail"] ?? "Unknown error occurred";
      print('Error fetching image: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<String> UserRequest() async {
    try {
      final response = await dio.get('/user-details', data: {});
      String data = response.data["name"];
      return data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["detail"] ?? "Unknown error occurred";
      print('Error fetching image: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<WeatherResponse> WeatherRequest(LatLng position) async {
    try {
      final response = await dio.post('/weather',
          data: {"lat": position.latitude, "long": position.longitude});
      print(response.data.toString());
      WeatherResponse data = WeatherResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["detail"] ?? "Unknown error occurred";
      print('Error fetching image: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<Test> request(LatLng position) async {
    try {
      final response = await dio.post('/chat/weather',
          data: {"lat": position.latitude, "long": position.longitude});
      print(response.data.toString());
      Test data = Test.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["detail"] ?? "Unknown error occurred";
      print('Error fetching image: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<Uint8List?> getImage({required LatLng position}) async {
    try {
      final response = await dio.post(
        '/SoilMoistureImage',
        data: {"lat": position.latitude, "long": position.longitude},
        options: Options(responseType: ResponseType.bytes),
      );
      String contentType = response.headers.map['content-type']!.first;
      MediaType mediaType = MediaType.parse(contentType);

      if (mediaType.mimeType == 'image/png') {
        return response.data;
      } else {
        print('Response is not of type image/png');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  Future<Uint8List?> getImageAridity({required LatLng position}) async {
    try {
      final response = await dio.post(
        '/SoilAridityImage',
        data: {"lat": position.latitude, "long": position.longitude},
        options: Options(responseType: ResponseType.bytes),
      );
      String contentType = response.headers.map['content-type']!.first;
      MediaType mediaType = MediaType.parse(contentType);

      if (mediaType.mimeType == 'image/png') {
        return response.data;
      } else {
        print('Response is not of type image/png');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }
}

FutureProviderFamily<Test, LatLng> apiServiceProvider =
    FutureProvider.family<Test, LatLng>((ref, position) async {
  var dio = await ref.read(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.request(position);
});

FutureProviderFamily<WeatherResponse, LatLng> weatherServiceProvider =
    FutureProvider.family<WeatherResponse, LatLng>((ref, position) async {
  var dio = await ref.read(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.WeatherRequest(position);
});

FutureProvider<NewsResponse> newsServiceProvider =
    FutureProvider<NewsResponse>((ref) async {
  var dio = await ref.read(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.NewsRequest();
});

FutureProvider<String> userServiceProvider =
    FutureProvider<String>((ref) async {
  var dio = await ref.read(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.UserRequest();
});

FutureProviderFamily<Uint8List?, LatLng> aridityImageServiceProvider =
    FutureProvider.family<Uint8List?, LatLng>((ref, position) async {
  var dio = await ref.read(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.getImageAridity(position: position);
});

FutureProviderFamily<Uint8List?, LatLng> imageServiceProvider =
    FutureProvider.family<Uint8List?, LatLng>((ref, position) async {
  var dio = await ref.read(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.getImage(position: position);
});
