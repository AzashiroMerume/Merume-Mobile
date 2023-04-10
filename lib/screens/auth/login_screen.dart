import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../api/auth_api.dart';
import '../../exceptions.dart';

class LoginScreen extends StatefulWidget {
  final String? errorMessage;

  const LoginScreen({super.key, this.errorMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String email = '';
  String password = '';

  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    errorMessage = widget.errorMessage ?? '';
  }

  Map<String, String> errors = {};

  void validateFields(String email, String password) {
    // Clear previous errors
    errors.clear();

    // Check email
    if (email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!EmailValidator.validate(email)) {
      errors['email'] = 'Invalid email format';
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
          padding: const EdgeInsets.only(
              top: 100.0, bottom: 100.0, right: 47.0, left: 47.0),
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
                    color: littleLight),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Welcome to Merume!',
                style: TextStyle(
                    fontFamily: 'WorkSans', fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 50.0),
              if (errorMessage.isNotEmpty)
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(
                      fontFamily: 'WorkSans', fontSize: 16, color: Colors.red),
                ),
              if (errorMessage.isNotEmpty) const SizedBox(height: 24.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  errorText:
                      errors.containsKey('email') ? errors['email'] : null,
                ),
                onChanged: (value) {
                  email = value;
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
              const SizedBox(
                height: 32.0,
              ),
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
              const SizedBox(height: 50.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    validateFields(email, password);
                    setState(() {
                      errorMessage = '';
                    });
                    if (errors.isEmpty) {
                      try {
                        NavigatorState state = Navigator.of(context);

                        await login(email, password);

                        state.pushNamedAndRemoveUntil(
                          '/main',
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        setState(() {
                          if (e is AuthenticationException) {
                            errorMessage =
                                'Email or password are incorrect, please try a different email or sign up for a new account.';
                          } else if (e is NotFoundException) {
                            errorMessage = 'Email not found, try to sign up.';
                          } else if (e is UnprocessableEntityException) {
                            errorMessage =
                                'Invalid input data. Please follow instructions.';
                          } else if (e is NetworkException) {
                            errorMessage =
                                'Network error has occured. Please check your internet connection.';
                          } else if (e is ServerException) {
                            errorMessage =
                                'There was an error on the server side, try again later.';
                          } else if (e is HttpException) {
                            errorMessage =
                                'There was an error on the server side, try again later.';
                          } else {
                            errorMessage =
                                'An unexpected error occurred. Please try again later.';
                          }
                        });
                      }
                    } else {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(178, 38),
                      backgroundColor: purpleBeaty,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
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
                onPressed: (() =>
                    Navigator.of(context).pushReplacementNamed('/register')),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
