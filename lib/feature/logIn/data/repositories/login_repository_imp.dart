import 'package:chat_app/feature/logIn/data/data_sources/remote_data_source.dart';
import 'package:chat_app/feature/logIn/data/models/login_model.dart';
import 'package:chat_app/feature/logIn/domain/repositories/login_repository.dart';
import 'package:chat_app/feature/logIn/presentation/widgets/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class LoginRepositoryImp implements LoginRepository {
  LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImp(this.loginRemoteDataSource);

  @override
  FutureOr<(LoginModel?, String?)> login({
    required UserData userData,
  }) async {
    final res = await loginRemoteDataSource.login(userData: userData);
    if (res.$1?.user != null) print(res.$1!.user.uid);
    return res;
  }
}
