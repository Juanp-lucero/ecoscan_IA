import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isLoading = false;

  final auth = AuthService();

  // 🔐 VALIDACIONES
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Falta ingresar el email";
    }
    if (!value.contains("@")) {
      return "Email inválido";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Falta ingresar la contraseña";
    }
    if (value.length < 6) {
      return "Mínimo 6 caracteres";
    }
    return null;
  }

  Future<void> _submit() async {
    // 🚨 VALIDAR FORM
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await auth.signIn(email, password);
      } else {
        await auth.signUp(email, password);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      String message = "Error inesperado";

      if (e.toString().contains("Invalid login credentials")) {
        message = "Correo o contraseña incorrectos";
      } else if (e.toString().contains("User already registered")) {
        message = "El usuario ya existe";
      } else if (e.toString().contains("rate limit")) {
        message = "Demasiados intentos, espera un momento";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "EcoScan AI 🌱",
                  style: TextStyle(fontSize: 28),
                ),

                const SizedBox(height: 30),

                // 📧 EMAIL
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: validateEmail,
                ),

                const SizedBox(height: 10),

                // 🔐 PASSWORD
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: validatePassword,
                ),

                const SizedBox(height: 20),

                // 🔘 BOTÓN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(isLogin ? "Login" : "Register"),
                  ),
                ),

                const SizedBox(height: 10),

                // 🔁 CAMBIAR MODO
                TextButton(
                  onPressed: () {
                    setState(() => isLogin = !isLogin);
                  },
                  child: Text(isLogin
                      ? "Create account"
                      : "Already have an account?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}