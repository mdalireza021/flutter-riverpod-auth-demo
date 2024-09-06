import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_auth_demo/models/login_form_response.dart';
import 'package:riverpod_auth_demo/providers/auth_state.dart';
import '../models/pass_recovery_response.dart';
import '../models/user_login_req_body.dart';
import '../services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(Ref ref)
      : _authService = ref.read(authServiceProvider),
        super(AuthState.initial());

  Future<LoginFormData?> fetchLogin() async {
    state = state.copyWith(loginFormData: const AsyncValue.loading());

    try {
      final response = await _authService.getLoginFormData();

      await Future.delayed(const Duration(seconds: 3));

      state = state.copyWith(loginFormData: AsyncValue.data(response.data));

      return response.data;
    } catch (err, stackTrace) {
      state = state.copyWith(loginFormData: AsyncValue.error(err, stackTrace));
    }
    return null;
  }

  Future<void> postLogin(LoginFormData? data) async {
    state = state.copyWith(userLoginData: const AsyncValue.loading());

    try {
      final reqBody = UserLoginReqBody(data: data);
      final response = await _authService.postLoginFormData(reqBody);

      state = state.copyWith(userLoginData: AsyncValue.data(response.data));
    } catch (err, stackTrace) {
      state = state.copyWith(userLoginData: AsyncValue.error(err, stackTrace));
    }
  }

  Future<void> postPasswordRecovery(String email) async {
    state = state.copyWith(passwordRecovery: const AsyncValue.loading());

    try {
      final reqBody = PasswordRecoveryResponse(
        data: PasswordRecoveryData(email: email, displayCaptcha: false),
        message: "",
        errorList: [],
      );

      final response = await _authService.recoverPassword(reqBody);
      state = state.copyWith(passwordRecovery: AsyncValue.data(response.message));
    } catch (err, st) {
      state = state.copyWith(passwordRecovery: AsyncValue.error(err, st));
    }
  }

  Future<void> performLogout() async {
    state = state.copyWith(performLogout: const AsyncValue.loading());
    try {
      final response = await _authService.performLogout();
      state = state.copyWith(performLogout: AsyncValue.data(response));
    }
    catch(err, st) {
      state = state.copyWith(performLogout: AsyncValue.error(err, st));
    }
  }
}
