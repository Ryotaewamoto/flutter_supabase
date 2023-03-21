import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/auth_repository.dart';
import '../../utils/app_exception.dart';

/// Firebase Auth を用いてサインインをする [AsyncNotifierProvider]。
final signInControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignInController, void>(
  SignInController.new,
);

class SignInController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // FutureOr<void> より、初期の処理の必要がないため何もしない。
  }

  /// サインインする
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    // サインイン結果をローディング中にする
    state = const AsyncLoading();

    // サインイン処理を実行する
    state = await AsyncValue.guard(() async {
      // try {
      if (email.isEmpty || password.isEmpty) {
        const exception = AppException(
          message: 'メールアドレスとパスワードを入力してください。',
        );
        throw exception;
      }
      await authRepository.signIn(
        email: email,
        password: password,
      );
      // } catch (e) {
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
