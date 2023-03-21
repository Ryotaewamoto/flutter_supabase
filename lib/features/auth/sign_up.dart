import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/auth_repository.dart';
import '../../utils/app_exception.dart';


/// Firebase Auth を用いてサインアップをする [AsyncNotifierProvider]。
final signUpControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignUpController, void>(
  SignUpController.new,
);

class SignUpController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // FutureOr<void> より、初期の処理の必要がないため何もしない。
  }

  /// 新規登録する
  Future<void> signUp({
    // required bool isCheckTerms,
    // required String userName,
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    // ログイン結果をローディング中にする
    state = const AsyncLoading();

    // ログイン処理を実行する
    state = await AsyncValue.guard(() async {
      // try {
        // if (isCheckTerms == false) {
        //   const exception = AppException(
        //     message: '利用規約とプライバシーポリシーに同意してください。',
        //   );
        //   throw exception;
        // }

        if (email.isEmpty || password.isEmpty) {
          const exception = AppException(
            message: 'ユーザ名、メールアドレス、パスワードを入力してください。',
          );
          throw exception;
        }

        await authRepository.signUp(
          email: email,
          password: password,
        );

        // } else {
        //   const exception = AppException(
        //     message: 'アカウントの作成に失敗しました。別のメールアドレスでお試しください。',
        //   );
        //   throw exception;
        // }
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
