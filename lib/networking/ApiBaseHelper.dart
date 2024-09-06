import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jaguar_jwt/jaguar_jwt.dart' as jwt;
import '../models/base_response.dart';
import '../services/GlobalService.dart';
import '../utils/AppConstants.dart';
import 'AppException.dart';
import 'Endpoints.dart';



class ApiBaseHelper {
  final String _baseUrl = Endpoints.baseUrl;

  Future<dynamic> get(String url) async {
    var responseJson;

    try {
      final response = await http
          .get(Uri.parse(_baseUrl + url), headers: getRequestHeader())
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FetchDataException(408, 'Request timeout');
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(0, 'No Internet connection');
    }

    print('Get received!');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic requestBody) async {
    var body = json.encode(requestBody);
    var responseJson;

    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          headers: getRequestHeader(), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(0, 'No Internet connection');
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isNotEmpty) {
          Map<String, dynamic> responseJson =
          jsonDecode(response.body.toString());
          log(responseJson.toString());

          var errorMsg = parseErrorMessage(response.body.toString());
          if (errorMsg.isNotEmpty && errorMsg != response.body) {
            throw BadRequestException(response.statusCode, errorMsg);
          }

          return responseJson;
        }
        return '';
      case 302:
      case 400:
      case 401:
      case 403:
      case 404:
      case 500:
        throw BadRequestException(
            response.statusCode, parseErrorMessage(response.body.toString()));
      default:
        throw FetchDataException(response.statusCode,
            'Network error. StatusCode : ${response.statusCode}');
    }
  }

  Map<String, String> getRequestHeader() {
    final claimSet = jwt.JwtClaim(
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{
        'NST_KEY': AppConstants.NstKey,
      },
    );

    String jwtToken = jwt.issueJwtHS256(claimSet, AppConstants.NstSecret);

    var map = {
      'NST': jwtToken,
      'deviceId': "1234567890",
      'Content-Type': 'application/json',
      'User-Agent': 'nopstationcart.flutter/v1'
    };

    if (GlobalService().getAuthToken().isNotEmpty) {
      map['Token'] = GlobalService().getAuthToken();
    }


    return map;
  }

  String parseErrorMessage(String response) {
    var error = "";
    try {
      error =
          BaseResponse.fromJson(jsonDecode(response)).getFormattedErrorMsg();
    } catch (e) {
      error = response;
    }

    return error;
  }
}
