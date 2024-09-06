import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_auth_demo/models/user_login_response.dart';
import '../models/login_form_response.dart';

class AuthState {
  final AsyncValue<LoginFormData?>? loginFormData;
  final AsyncValue<UserLoginData?>? userLoginData;
  final AsyncValue<String?>? performLogout;
  final AsyncValue<String?>? passwordRecovery;

  AuthState({
    this.loginFormData,
    this.userLoginData,
    this.performLogout ,
    this.passwordRecovery,
  });

  AuthState copyWith({
  AsyncValue<LoginFormData?>? loginFormData,
  AsyncValue<UserLoginData?>? userLoginData,
    AsyncValue<String?>? performLogout,
    AsyncValue<String?>? passwordRecovery,
  }) {
    return AuthState(
      loginFormData: loginFormData ?? this.loginFormData,
      userLoginData: userLoginData ?? this.userLoginData,
      performLogout: performLogout ?? this.performLogout,
      passwordRecovery: passwordRecovery ?? this.passwordRecovery,
    );
  }

  factory AuthState.initial() => AuthState();
}
