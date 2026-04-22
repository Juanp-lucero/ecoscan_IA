import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // 🔐 REGISTRO
  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // 🔓 LOGIN
  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 🚪 LOGOUT
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // 👤 USUARIO ACTUAL
  User? get currentUser => supabase.auth.currentUser;
}