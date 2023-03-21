import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/auth_repository.dart';
import '../utils/loading.dart';
import 'account_page.dart';
import 'login_page.dart';

/// 注意：画面遷移に [MaterialPageRoute] を採用しているので、ローディング時に重ねる
/// [OverlayLoadingWidget] は各画面で実装が必要である。
class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(authCurrentUserProvider) != null
          ? const AccountPage()
          : const LoginPage(),
    );
  }
}
