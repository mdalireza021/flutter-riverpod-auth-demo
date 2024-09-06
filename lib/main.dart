import 'package:flutter/material.dart';
import 'package:riverpod_auth_demo/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_auth_demo/screens/pass_recovery_screen.dart';
import 'package:riverpod_auth_demo/screens/login_screen.dart';
import 'package:riverpod_auth_demo/services/GlobalService.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: GlobalService().navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        PasswordRecoveryScreen.routeName: (context) => const PasswordRecoveryScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
    );
  }
}
