import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kang/models/models.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final dioProvider =
    Provider((ref) => Dio(BaseOptions(baseUrl: "http://52.66.253.251:8036")));

class ApiServiceProvider {
  final dio;

  ApiServiceProvider(this.dio);

  Future<Test> request(LatLng position) async {
    try {
      final response = await dio.post('/weather',
          data: {"lat": position.latitude, "long": position.longitude});
      if (response.statusCode == 200) {
        print(response.data.toString());
        Test data = Test.fromJson(response.data);
        return data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
      throw e;
    }
    return Test(greeting: "error");
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
  var dio = ref.watch(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.request(position);
});

FutureProviderFamily<Uint8List?, LatLng> aridityImageServiceProvider =
    FutureProvider.family<Uint8List?, LatLng>((ref, position) async {
  var dio = ref.watch(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.getImageAridity(position: position);
});

FutureProviderFamily<Uint8List?, LatLng> imageServiceProvider =
    FutureProvider.family<Uint8List?, LatLng>((ref, position) async {
  var dio = ref.watch(dioProvider);
  var apiService = ApiServiceProvider(dio);
  return await apiService.getImage(position: position);
});
