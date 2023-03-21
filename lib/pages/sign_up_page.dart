import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/sign_up.dart';
import '../utils/loading.dart';
import '../utils/scaffold_messenger_service.dart';
import 'account_page.dart';

final _emailController = Provider.autoDispose(
  (ref) => TextEditingController(),
);

final _passwordController = Provider.autoDispose(
  (ref) => TextEditingController(),
);

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      signUpControllerProvider,
      (_, state) async {
        if (state.isLoading) {
          ref.watch(overlayLoadingProvider.notifier).update((state) => true);
          return;
        }

        await state.when(
          data: (_) async {
            // ローディングを非表示にする
            ref.watch(overlayLoadingProvider.notifier).update((state) => false);

            // ログインできたらスナックバーでメッセージを表示してホーム画面に遷移する
            ref
                .read(scaffoldMessengerServiceProvider)
                .showSnackBar('アカウントを作成しました！');

            await Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => const AccountPage(),
              ),
            );
          },
          error: (e, s) async {
            // ローディングを非表示にする
            ref.watch(overlayLoadingProvider.notifier).update((state) => false);

            // エラーが発生したらエラーダイアログを表示する
            // state.showAlertDialogOnError(context);
          },
          loading: () {
            // ローディングを表示する
            ref.watch(overlayLoadingProvider.notifier).update((state) => true);
          },
        );
      },
    );

    final email = ref.watch(_emailController);
    final password = ref.watch(_passwordController);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: password,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              ref.read(signUpControllerProvider.notifier).signUp(
                    email: email.text,
                    password: password.text,
                  );
            },
            child: const Text('login'),
          ),
        ],
      ),
    );
  }
}
