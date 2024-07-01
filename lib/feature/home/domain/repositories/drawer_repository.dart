import 'package:chat_app/feature/home/data/data_sources/remote_data_source.dart';
import 'package:chat_app/feature/home/data/repositories/drawer_repository_imp.dart';
import 'package:chat_app/feature/home/domain/entities/drawer_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drawer_repository.g.dart';

@riverpod
MyDrawerRepository myDrawerRepository(Ref ref) {
  final myDrawerRemoteDataSource = ref.read(myDrawerRemoteDataSourceProvider);
  return MyDrawerRepositoryImp(myDrawerRemoteDataSource);
}

abstract class MyDrawerRepository {
  FutureOr<(MyDrawerEntity?, String?)> myDrawer();
  FutureOr<(MyDrawerEntity?, String?)> updateImage({required image});
  FutureOr<(MyDrawerEntity?, String?)> updateStatus({required status});
}