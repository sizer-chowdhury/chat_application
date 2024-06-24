import 'package:chat_app/feature/logIn/domain/entities/login_entity.dart';
import 'package:chat_app/feature/logIn/domain/repositories/login_repository.dart';
import 'package:chat_app/feature/logIn/presentation/widgets/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_use_case.g.dart';

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  final loginRepository = ref.read(loginRepositoryProvider);
  return LoginUseCase(loginRepository: loginRepository);
}

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase({required this.loginRepository});

  FutureOr<(LoginEntity?, String?)> login({
    required UserData userData,
  }) async {
    return await loginRepository.login(
      userData: userData,
    );
  }
}
