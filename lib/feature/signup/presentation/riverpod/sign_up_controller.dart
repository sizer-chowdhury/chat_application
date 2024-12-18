import 'package:chat_app/core/utils/user_data.dart';
import 'package:chat_app/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/use_cases/sign_up_use_case.dart';

part 'sign_up_controller.g.dart';

@riverpod
class SignUpController extends _$SignUpController {
  @override
  FutureOr<(SignUpEntity?, String?)> build() {
    return (null, null);
  }

  void signUp(UserData userData) async {
    state = const AsyncData((null, null));
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(signUpUseCaseProvider).signUp(userData: userData);
    });
  }

  void saveGoogleUser({required user}) {
    ref.read(signUpUseCaseProvider).saveGoogleUser(user: user);
  }
}
