import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/auth_repository.dart';

/// Firebase Auth を用いてサインアウトをする [AsyncNotifierProvider]。
final signOutControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignOutController, void>(
  SignOutController.new,
);

class SignOutController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // FutureOr<void> より、初期の処理の必要がないため何もしない。
  }

  /// サインアウトする
  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    // サインアウト結果をローディング中にする
    state = const AsyncLoading();

    // サインアウト処理を実行する
    state = await AsyncValue.guard(() async {
      // try {
      await authRepository.signOut();
      // } on FirebaseAuthException catch (e) {
      //   final exception = AppException(
      //     code: e.code,
      //     message: e.toJapanese,
      //   );
      //   debugPrint(e.code);
      //   throw exception;
      // }
    });
  }
}
