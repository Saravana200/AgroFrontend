import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'models.g.dart';

Test testFromJson(String str) => Test.fromJson(json.decode(str));

String testToJson(Test data) => json.encode(data.toJson());

@JsonSerializable()
class Test {
    @JsonKey(name: "greeting")
    String? greeting;

    Test({
         this.greeting,
    });

    factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

    Map<String, dynamic> toJson() => _$TestToJson(this);
}
