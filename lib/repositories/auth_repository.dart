import 'package:hooks_riverpod/hooks_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = riverpod.Provider<SupabaseClient>(
  (_) => Supabase.instance.client,
);

// final authUserProvider = riverpod.StreamProvider<AuthState>(
//   (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
// );

final authCurrentUserProvider = riverpod.Provider.autoDispose<User?>(
  (ref) => ref.watch(authRepositoryProvider).currentUser,
);

final authRepositoryProvider = riverpod.Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(authProvider),
  ),
);

class AuthRepository {
  AuthRepository(this._supabase);

  final SupabaseClient _supabase;

    User? get currentUser => _supabase.auth.currentUser;


  // Sign up
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
