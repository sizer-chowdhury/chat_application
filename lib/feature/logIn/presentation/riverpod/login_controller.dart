import 'package:chat_app/feature/logIn/domain/entities/login_entity.dart';
import 'package:chat_app/feature/logIn/domain/use_cases/login_use_case.dart';
import 'package:chat_app/feature/logIn/presentation/widgets/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<(LoginEntity?, String?)> build() {
    return (null, null);
  }

  void login(UserData userData) async {
    state = const AsyncData((null, null));
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(loginUseCaseProvider).login(userData: userData);
    });
  }
}
