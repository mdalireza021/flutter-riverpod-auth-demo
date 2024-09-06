import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_auth_demo/home_screen.dart';
import 'package:riverpod_auth_demo/models/login_form_response.dart';
import 'package:riverpod_auth_demo/providers/auth_provider.dart';
import 'package:riverpod_auth_demo/providers/auth_state.dart';
import 'package:riverpod_auth_demo/screens/pass_recovery_screen.dart';
import '../utils/utility.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  LoginFormData? formData;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      formData = await ref.read(authProvider.notifier).fetchLogin();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.userLoginData?.whenOrNull(
        data: (data) => Navigator.of(context)
            .pushNamedAndRemoveUntil(HomeScreen.routeName, (_) => false),
        error: (error, _) => showSnackBar(context, error.toString(), true),
      );
    });

    final authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Log in"),
      ),
      body: authState.loginFormData?.when(
        data: (data) => rootWidget(),
        error: (err, _) => Text('$err'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget tfUserName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'required Username';
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
      onChanged: (value) => formData?.username = value,
      decoration: const InputDecoration(
          hintText: "Username",
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
          suffixIcon: Icon(Icons.person_outline_rounded)),
      textInputAction: TextInputAction.next,
    );
  }

  Widget tfPassword() {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'required Password';
        }
        return null;
      },
      onChanged: (value) => formData?.password = value,
      decoration: InputDecoration(
        hintText: "Password",
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
            removeFocusFromInputField(context);
          },
        ),
      ),
      textInputAction: TextInputAction.done,
      maxLength: 30,
    );
  }

  Widget tfEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (!(formData?.usernamesEnabled ?? false) &&
            (value == null || value.isEmpty || !isValidEmailAddress(value))) {
          return "invalid email";
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
      onChanged: (value) => formData?.email = value,
      decoration: const InputDecoration(
          hintText: "Email",
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
          suffixIcon: Icon(Icons.email_outlined)),
      textInputAction: TextInputAction.next,
    );
  }

  Widget rootWidget() {
    final authNotifier = ref.watch(authProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (formData?.usernamesEnabled ?? false)
                    ? tfUserName()
                    : tfEmail(),
                const SizedBox(height: 15),
                tfPassword(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(PasswordRecoveryScreen.routeName);
            },
            child: const Text('forgot password?'),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: authNotifier.userLoginData?.isLoading == true
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();
                      ref.read(authProvider.notifier).postLogin(formData);
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
        ),
      ],
    );
  }
}
