import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../api/auth_api.dart';
import '../../exceptions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeauty = const Color(0xFF8E05C2);

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String identifier = '';
  String password = '';

  String errorMessage = '';

  bool useEmailLogin = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Map<String, String> errors = {};

  void validateFields(String identifier, String password) {
    // Clear previous errors
    errors.clear();

    // Check identifier (email or nickname)
    if (useEmailLogin && identifier.isEmpty) {
      errors['identifier'] = 'Email is required';
    } else if (useEmailLogin && !EmailValidator.validate(identifier)) {
      errors['identifier'] = 'Invalid email format';
    } else if (identifier.trim().isEmpty) {
      errors['identifier'] = 'Nickname is required';
    } else if (RegExp(r"\s").hasMatch(identifier.trim())) {
      errors['identifier'] = 'Nickname must be a non-conjoint string';
    } else if (identifier.trim().length < 6) {
      errors['identifier'] = 'Nickname must be at least 6 characters long';
    } else if (identifier.trim().length > 20) {
      errors['identifier'] = 'Nickname must contain no more than 20 characters';
    }

    // Check password
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 8) {
      errors['password'] = 'Password must be at least 8 characters long';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 47.0, left: 47.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign in now',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: littleLight,
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Welcome to Merume!',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50.0),
              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          'Error: $errorMessage',
                          style: const TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (errorMessage.isNotEmpty) const SizedBox(height: 16.0),
              TextField(
                controller: _identifierController,
                decoration: InputDecoration(
                  hintText: useEmailLogin ? 'Email' : 'Nickname',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('identifier')
                      ? errors['identifier']
                      : null,
                ),
                onChanged: (value) {
                  identifier = value;
                },
              ),
              const SizedBox(height: 50.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('password')
                      ? errors['password']
                      : null,
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(height: 32.0),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: littleLight,
                      fontFamily: 'WorkSans',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    validateFields(identifier, password);

                    setState(() {
                      errorMessage = '';
                    });

                    if (errors.isEmpty) {
                      NavigatorState state = Navigator.of(context);
                      try {
                        await login(identifier, password, useEmailLogin);

                        state.pushNamedAndRemoveUntil(
                          '/main',
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        if (e is PreferencesUnsetException) {
                          state.pushNamedAndRemoveUntil(
                            '/preferences',
                            (Route<dynamic> route) => false,
                          );
                        }
                        setState(() {
                          if (e is AuthenticationException) {
                            if (useEmailLogin) {
                              errorMessage =
                                  'Email or password is incorrect, please try a different email or sign up for a new account.';
                            } else {
                              errorMessage =
                                  'Nickname or password is incorrect, please try a different nickname or sign up for a new account.';
                            }
                          } else if (e is NotFoundException) {
                            if (useEmailLogin) {
                              errorMessage = 'Email not found, try to sign up.';
                            } else {
                              errorMessage =
                                  'Nickname not found, try to sign up.';
                            }
                          } else if (e is UnprocessableEntityException ||
                              e is ContentTooLargeException) {
                            errorMessage =
                                'Invalid input data. Please follow the requirements.';
                          } else if (e is NetworkException) {
                            errorMessage =
                                'A network error has occurred. Please check your internet connection.';
                          } else if (e is ServerException ||
                              e is HttpException) {
                            errorMessage =
                                'There was an error on the server side. Please try again later.';
                          } else if (e is TimeoutException) {
                            errorMessage =
                                'Network connection is poor. Please try again later.';
                          } else {
                            errorMessage =
                                'An unexpected error occurred. Please try again later.';
                          }
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(178, 38),
                    backgroundColor: purpleBeauty,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/register'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I don\'t have an account ',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 16,
                        color: littleLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    useEmailLogin ? 'Login by' : 'Login by unique',
                    style: const TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        useEmailLogin = !useEmailLogin;
                      });
                    },
                    child: Text(
                      useEmailLogin ? 'Nickname' : 'Email',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 16,
                        color: littleLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
