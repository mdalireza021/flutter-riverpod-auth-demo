import 'custom_properties.dart';
class PasswordRecoveryResponse {
  PasswordRecoveryResponse({
    this.data,
    this.message,
    this.errorList,
  });

  PasswordRecoveryData? data;
  String? message;
  List<String>? errorList;

  factory PasswordRecoveryResponse.fromJson(Map<String, dynamic> json) => PasswordRecoveryResponse(
    data: json["Data"] == null ? null : PasswordRecoveryData.fromJson(json["Data"]),
    message: json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data?.toJson(),
    "Message": message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList!.map((x) => x)),
  };
}

class PasswordRecoveryData {
  PasswordRecoveryData({
    this.email,
    this.result,
    this.displayCaptcha,
    this.customProperties,
  });

  String? email;
  dynamic result;
  bool? displayCaptcha;
  CustomProperties? customProperties;

  factory PasswordRecoveryData.fromJson(Map<String, dynamic> json) => PasswordRecoveryData(
    email: json["Email"],
    result: json["Result"],
    displayCaptcha: json["DisplayCaptcha"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Email": email,
    "Result": result,
    "DisplayCaptcha": displayCaptcha,
    "CustomProperties": customProperties?.toJson(),
  };
}

