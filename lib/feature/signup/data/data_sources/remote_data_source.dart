import 'package:chat_app/feature/signup/data/models/sign_up_model.dart';
import 'package:chat_app/feature/signup/presentation/widgets/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_data_source.g.dart';

@riverpod
SignUpRemoteDataSource signUpRemoteDataSource(Ref ref) {
  return SignUpRemoteDataSource();
}

class SignUpRemoteDataSource {
  FutureOr<(SignUpModel?, String?)> signUp({required UserData userData}) async {
    try {
      final email = userData.email;
      final pass = userData.password;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = credential.user;
      if (user != null) {
        return (SignUpModel(user: user), null);
      }
    } on FirebaseAuthException catch (e) {
      String? errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      return (null, errorMessage);
    } catch (e) {
      return (null, e.toString());
    }
    return (null, null);
  }
}
