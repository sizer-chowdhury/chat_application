import 'package:chat_app/feature/home/domain/entities/drawer_entity.dart';
import 'package:chat_app/feature/home/domain/use_cases/drawer_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_image_controller.g.dart';

@riverpod
class UpdateImageController extends _$UpdateImageController {
  @override
  FutureOr<(MyDrawerEntity?, String?)> build() {
    return (null, null);
  }

  void updateImage({required image}) async {
    state = const AsyncData((null, null));
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(myDrawerUseCaseProvider).updateImage(
        image: image,
      );
    });
  }
}