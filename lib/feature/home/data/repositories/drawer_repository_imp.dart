import 'dart:async';
import 'package:chat_app/feature/home/data/data_sources/remote_data_source.dart';
import 'package:chat_app/feature/home/data/models/drawer_model.dart';
import 'package:chat_app/feature/home/domain/entities/drawer_entity.dart';
import 'package:chat_app/feature/home/domain/repositories/drawer_repository.dart';

class MyDrawerRepositoryImp implements MyDrawerRepository {
  MyDrawerRemoteDataSource myDrawerRemoteDataSource;

  MyDrawerRepositoryImp(this.myDrawerRemoteDataSource);

  @override
  FutureOr<(MyDrawerModel?, String?)> myDrawer() async {
    final responsne = await myDrawerRemoteDataSource.myDrawer();
    return responsne;
  }

  @override
  FutureOr<(MyDrawerEntity?, String?)> updateImage({required image}) async {
    return await myDrawerRemoteDataSource.updateImage(image: image);
  }

  @override
  FutureOr<(MyDrawerEntity?, String?)> updateStatus({required status}) async {
    return await myDrawerRemoteDataSource.updateStatus(status: status);
  }
}