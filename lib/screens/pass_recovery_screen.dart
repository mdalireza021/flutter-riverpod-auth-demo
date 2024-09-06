import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_auth_demo/providers/auth_provider.dart';
import 'package:riverpod_auth_demo/providers/auth_state.dart';
import '../utils/utility.dart';

class PasswordRecoveryScreen extends ConsumerStatefulWidget {
  static const routeName = '/forgot-password';
  const PasswordRecoveryScreen({super.key});

  @override
  ConsumerState<PasswordRecoveryScreen> createState() =>
      _ForgotPassScreenState();
}

class _ForgotPassScreenState extends ConsumerState<PasswordRecoveryScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailEditingCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailEditingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      next.passwordRecovery?.whenOrNull(
        data: (value)=> showSnackBar(context, value, false),
        error: (err, st) => showSnackBar(context, err.toString(), true),
      );
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Password Recovery"),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 48.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailEditingCtrl,
                      autofocus: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "required email";
                        }
                        return null;
                      },
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                      //onChanged: (value) => email = value,
                      decoration: const InputDecoration(
                          hintText: 'Your email address',
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
                          suffixIcon: Icon(Icons.email_outlined)),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    authNotifier.passwordRecovery?.isLoading == true ?
                        CircularProgressIndicator() : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          removeFocusFromInputField(context);
                          ref
                              .read(authProvider.notifier)
                              .postPasswordRecovery(
                              emailEditingCtrl.value.text);
                        }
                      },
                      child: const Text("Recover"),
                    ),
                    const SizedBox(height: 48.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
