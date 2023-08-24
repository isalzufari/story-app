import 'package:json_annotation/json_annotation.dart';
import 'login_result.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  bool? error;
  String? message;
  LoginResult? loginResult;

  Login({this.error, this.message, this.loginResult});

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
