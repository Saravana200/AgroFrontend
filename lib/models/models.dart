import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

// ------------------ Test Model ------------------

@JsonSerializable()
class Test {
    @JsonKey(name: "greeting")
    String? greeting;

  Test({this.greeting});

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);
    Map<String, dynamic> toJson() => _$TestToJson(this);
}

// ------------------ LoginRequest Model ------------------

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "password")
  String password;

  LoginRequest({
    required this.name,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// ------------------ LoginResponse Model ------------------

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "token")
  String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

// ------------------ WeatherResponse Model ------------------

@JsonSerializable()
class WeatherResponse {
  @JsonKey(name: 'wind_speed')
  final double windSpeed;
  final double humidity;
  final double temperature;

  WeatherResponse({
    required this.windSpeed,
    required this.humidity,
    required this.temperature,
  });

  /// Factory for deserialization
  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherResponseFromJson(json);

  /// Method for serialization
  Map<String, dynamic> toJson() => _$WeatherResponseToJson(this);
}
