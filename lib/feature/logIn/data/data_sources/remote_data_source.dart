import 'package:chat_app/feature/logIn/data/models/login_model.dart';
import 'package:chat_app/feature/logIn/presentation/widgets/user_data.dart';
import 'package:chat_app/feature/logIn/presentation/widgets/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_data_source.g.dart';

@riverpod
LoginRemoteDataSource loginRemoteDataSource(Ref ref) {
  return LoginRemoteDataSource();
}

class LoginRemoteDataSource {
  FutureOr<(LoginModel?, String?)> login({required UserData userData}) async {
    final email = userData.email;
    final pass = userData.pass;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = credential.user;
      if (user != null) {
        return (LoginModel(user: user), null);
      }
    } on FirebaseAuthException catch (e) {
      String? errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid credential';
      }
      return (null, errorMessage);
    } catch (e) {
      return (null, e.toString());
    }
    return (null, null);
  }
}
