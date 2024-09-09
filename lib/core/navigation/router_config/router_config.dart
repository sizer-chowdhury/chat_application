import 'package:chat_app/core/navigation/routes/routes_name.dart';
import 'package:chat_app/feature/home/presentation/pages/home_page.dart';
import 'package:chat_app/feature/logIn/presentation/pages/forget_password_page.dart';
import 'package:chat_app/feature/logIn/presentation/pages/login_page.dart';
import 'package:chat_app/feature/signup/presentation/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyRouterConfig {
  static GoRouter router = GoRouter(
    initialLocation: (FirebaseAuth.instance.currentUser == null)
        ? RoutesName.login
        : RoutesName.home,
    routes: [
      GoRoute(
        path: RoutesName.login,
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        path: RoutesName.signup,
        pageBuilder: (context, state) {
          return MaterialPage(child: SignupPage());
        },
      ),
      GoRoute(
        path: RoutesName.home,
        pageBuilder: (context, state) {
          return MaterialPage(child: HomePage());
        },
      ),
      GoRoute(
        path: RoutesName.forgetPassword,
        pageBuilder: (context, state) {
          return MaterialPage(child: ForgetPasswordPage());
        },
      ),
    ],
  );
}
