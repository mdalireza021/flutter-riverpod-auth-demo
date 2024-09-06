import 'login_form_response.dart';

class UserLoginReqBody {
  UserLoginReqBody({
    this.data,
  });

  LoginFormData? data;

  factory UserLoginReqBody.fromJson(Map<String, dynamic> json) => UserLoginReqBody(
    data: LoginFormData.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "Data": data!.toJson(),
  };
}

