import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/app_strings.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;

  bool isLoading = false;

  final auth = AuthService();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    if (!value.contains("@")) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 6) {
      return AppStrings.minCharacters;
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email =
        emailController.text.trim();

    final password =
        passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        await auth.signIn(
          email,
          password,
        );
      } else {
        await auth.signUp(
          email,
          password,
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const HomeScreen(),
        ),
      );
    } catch (e) {
      print("ERROR AUTH:");
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),

          backgroundColor:
              Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(25),

            child: Form(
              key: _formKey,

              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.eco,
                    size: 80,
                    color: Colors.greenAccent,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    AppStrings.appName,

                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  TextFormField(
                    controller:
                        emailController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        InputDecoration(
                      labelText:
                          AppStrings.email,

                      labelStyle:
                          const TextStyle(
                        color:
                            Colors.white70,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white
                              .withOpacity(
                        0.05,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        borderSide:
                            const BorderSide(
                          color: Colors
                              .greenAccent,
                        ),
                      ),
                    ),

                    validator:
                        validateEmail,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  TextFormField(
                    controller:
                        passwordController,

                    obscureText: true,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        InputDecoration(
                      labelText:
                          AppStrings.password,

                      labelStyle:
                          const TextStyle(
                        color:
                            Colors.white70,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white
                              .withOpacity(
                        0.05,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        borderSide:
                            const BorderSide(
                          color: Colors
                              .greenAccent,
                        ),
                      ),
                    ),

                    validator:
                        validatePassword,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: _submit,

                      style:
                          ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets
                                .symmetrical(
                          vertical: 15,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),

                        backgroundColor:
                            Colors.greenAccent,

                        foregroundColor:
                            Colors.black,
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              isLogin
                                  ? AppStrings
                                      .login
                                  : AppStrings
                                      .register,

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin =
                            !isLogin;
                      });
                    },

                    child: Text(
                      isLogin
                          ? AppStrings
                              .noAccount
                          : AppStrings
                              .alreadyAccount,

                      style: const TextStyle(
                        color:
                            Colors.greenAccent,
                      ),
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