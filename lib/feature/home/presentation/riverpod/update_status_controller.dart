import 'package:chat_app/feature/home/domain/entities/drawer_entity.dart';
import 'package:chat_app/feature/home/domain/use_cases/drawer_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_status_controller.g.dart';

@riverpod
class UpdateStatusController extends _$UpdateStatusController {
  @override
  FutureOr<(MyDrawerEntity?, String?)> build() {
    return (null, null);
  }

  void updateStatus({required status}) async {
    state = const AsyncData((null, null));
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(myDrawerUseCaseProvider)
          .updateStatus(status: status);
    });
  }
}