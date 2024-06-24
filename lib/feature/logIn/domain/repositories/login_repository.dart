import 'package:chat_app/feature/logIn/data/data_sources/remote_data_source.dart';
import 'package:chat_app/feature/logIn/data/repositories/login_repository_imp.dart';
import 'package:chat_app/feature/logIn/domain/entities/login_entity.dart';
import 'package:chat_app/feature/logIn/presentation/widgets/user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_repository.g.dart';

@riverpod
LoginRepository loginRepository(Ref ref) {
  final loginRemoteDataSource = ref.read(loginRemoteDataSourceProvider);
  return LoginRepositoryImp(loginRemoteDataSource);
}

abstract class LoginRepository {
  FutureOr<(LoginEntity?, String?)> login({
    required UserData userData,
  });
}
