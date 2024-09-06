import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_auth_demo/models/login_form_response.dart';
import 'package:riverpod_auth_demo/models/user_login_req_body.dart';
import 'package:riverpod_auth_demo/models/user_login_response.dart';
import '../models/pass_recovery_response.dart';
import '../networking/ApiBaseHelper.dart';
import '../networking/Endpoints.dart';

final authServiceProvider = Provider<AuthService>((ref)=> AuthService());

class AuthService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginFormResponse> getLoginFormData() async {
    final response = await _helper.get(Endpoints.userLogin);
    return LoginFormResponse.fromJson(response);
  }

  Future<UserLoginResponse> postLoginFormData(UserLoginReqBody reqBody) async {
    final response = await _helper.post(Endpoints.userLogin, reqBody);
    return UserLoginResponse.fromJson(response);
  }

  Future<PasswordRecoveryResponse> recoverPassword(PasswordRecoveryResponse reqBody) async {
    final response = await _helper.post(Endpoints.passwordRecovery, reqBody);
    return PasswordRecoveryResponse.fromJson(response);
  }

  Future<String> performLogout() async {
    final response = await _helper.get(Endpoints.userLogout);
    return response.toString();
  }
}