import 'package:flutter/material.dart';
import 'map_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = "";
  bool loading = false;

  void login() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        message = "Completa todos los campos";
      });
      return;
    }

    setState(() {
      loading = true;
      message = "";
    });

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapScreen()),
      );
    });
  }

  void register() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        message = "Completa todos los campos";
      });
      return;
    }

    setState(() {
      loading = true;
      message = "";
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
        message = "Cuenta creada (simulación)";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF020617),
              Color(0xFF064E3B),
              Color(0xFF022C22),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [

                  const Icon(
                    Icons.eco,
                    color: Colors.greenAccent,
                    size: 80,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "EcoScan AI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Impacto ambiental inteligente",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.greenAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [

                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Correo",
                            labelStyle:
                                const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.email,
                                color: Colors.greenAccent),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            labelStyle:
                                const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.lock,
                                color: Colors.greenAccent),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (loading)
                          const CircularProgressIndicator(),

                        if (message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              message,
                              style: const TextStyle(
                                  color: Colors.greenAccent),
                            ),
                          ),

                        const SizedBox(height: 15),

                        // LOGIN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Iniciar Sesión",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // REGISTER
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: register,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.greenAccent),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Crear Cuenta",
                              style:
                                  TextStyle(color: Colors.greenAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}