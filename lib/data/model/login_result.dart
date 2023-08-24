import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  String? userId;
  String? name;
  String? token;

  LoginResult({this.userId, this.name, this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
