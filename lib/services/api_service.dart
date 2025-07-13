// lib/repos/api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Example: GET request
  // static final String baseUrl = 'https://agrofusionnode.share.zrok.io';
  static final String baseUrl = "https://agrofusionnode.share.zrok.io";

  // final String baseUrl = 'http://10.0.2.2:4000';

  Future<dynamic> fetchData(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(url, headers: headers);

      print('Request URL: $url');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      // Check the response status code
      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse and return JSON response
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data from $endpoint: $e');
    }
  }

  // Example: POST request
  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

// final aridityImageProvider = FutureProvider.family<Uint8List, LatLng>((ref, position) async {
//   final url = Uri.https("agrofusionnode.share.zrok.io", "/map/getMap", {
//     "lat": position.latitude.toString(),
//     "long": position.longitude.toString(),
//   });
//
//   try {
//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'image/png',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       return response.bodyBytes;
//     } else {
//       throw Exception('Failed to fetch image. Status: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Error fetching image: $e');
//   }
// });
