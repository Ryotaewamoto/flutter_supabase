import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/sign_out.dart';
import '../utils/loading.dart';
import '../utils/scaffold_messenger_service.dart';
import 'auth_page.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      signOutControllerProvider,
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
                .showSnackBar('ログアウトしました！');

            await Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (_) => const AuthPage(),
              ),
              (_) => false,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          // TextFormField(
          //   controller: _usernameController,
          //   decoration: const InputDecoration(labelText: 'User Name'),
          // ),
          // const SizedBox(height: 18),
          // TextFormField(
          //   controller: _websiteController,
          //   decoration: const InputDecoration(labelText: 'Website'),
          // ),
          // const SizedBox(height: 18),
          // ElevatedButton(
          //   onPressed: _updateProfile,
          //   child: Text(_loading ? 'Saving...' : 'Update'),
          // ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () async {
              await ref.read(signOutControllerProvider.notifier).signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
