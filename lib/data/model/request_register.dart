import 'package:json_annotation/json_annotation.dart';

part 'request_register.g.dart';

@JsonSerializable()
class RegisterRequest {
  String? name;
  String? email;
  String? password;

  RegisterRequest({this.name, this.email, this.password});

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
