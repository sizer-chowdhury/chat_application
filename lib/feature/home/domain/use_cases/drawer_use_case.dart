import 'package:chat_app/feature/home/domain/entities/drawer_entity.dart';
import 'package:chat_app/feature/home/domain/repositories/drawer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drawer_use_case.g.dart';

@riverpod
MyDrawerUseCase myDrawerUseCase(MyDrawerUseCaseRef ref) {
  final myDrawerRepository = ref.read(myDrawerRepositoryProvider);
  return MyDrawerUseCase(myDrawerRepository: myDrawerRepository);
}

class MyDrawerUseCase {
  final MyDrawerRepository myDrawerRepository;

  MyDrawerUseCase({required this.myDrawerRepository});

  FutureOr<(MyDrawerEntity?, String?)> myDrawer() async {
    return await myDrawerRepository.myDrawer();
  }

  FutureOr<(MyDrawerEntity?, String?)> updateImage({required image}) async {
    return await myDrawerRepository.updateImage(image: image);
  }

  FutureOr<(MyDrawerEntity?, String?)> updateStatus({required status}) async {
    return await myDrawerRepository.updateStatus(status: status);
  }
}