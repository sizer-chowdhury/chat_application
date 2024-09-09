import 'dart:async';
import 'package:chat_app/core/utils/user_data.dart';
import 'package:chat_app/feature/signup/data/data_sources/remote_data_source.dart';
import 'package:chat_app/feature/signup/data/models/sign_up_model.dart';
import 'package:chat_app/feature/signup/domain/repositories/sign_up_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpRepositoryImp implements SignUpRepository {
  SignUpRemoteDataSource signUpRemoteDataSource;

  SignUpRepositoryImp(this.signUpRemoteDataSource);

  @override
  FutureOr<(SignUpModel?, String?)> signUp({
    required UserData userData,
  }) async {
    (SignUpModel?, String?) createdUser =
        await signUpRemoteDataSource.signUp(userData: userData);

    if (createdUser.$1 != null) {
      User user = createdUser.$1!.user;
      final db = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;

      try {
        await user.updateProfile(displayName: userData.name);
        await user.reload();
        user = auth.currentUser!;

        signUpRemoteDataSource.saveUserInfo(
          userMappedData: SignUpModel.toMap(user: user),
          collection: 'users',
          uid: user.uid,
        );
      } catch (e) {
        return (null, e.toString());
      }
    }
    return createdUser;
  }

  @override
  void saveGoogleUser({required user}) {
    try {
      signUpRemoteDataSource.saveUserInfo(
          userMappedData: SignUpModel.toMap(user: user),
          collection: 'users',
          uid: user.uid);
    } catch (e) {
      print(e.toString());
    }
  }
}
