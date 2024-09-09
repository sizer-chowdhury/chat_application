import 'package:chat_app/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpModel extends SignUpEntity {
  SignUpModel({
    required super.user,
  });
  static Map<String, dynamic> toMap({required User user}) {
    return {
      'name': user.displayName,
      'email': user.email,
      'uid': user.uid,
      'groupId': '',
      'isActive': true,
      'photoUrl':user.photoURL,
    };
  }
}
