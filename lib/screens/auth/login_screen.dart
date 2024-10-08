import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fire_base;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/auth_api/firebase_auth_api.dart';
import 'package:merume_mobile/api/user_api/get_email_api.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:merume_mobile/api/auth_api/login_api.dart';
import 'package:merume_mobile/constants/exceptions.dart';
import 'package:merume_mobile/screens/shared/basic/basic_elevated_button_widget.dart';
import 'package:merume_mobile/providers/user_provider.dart';
import 'package:merume_mobile/constants/text_styles.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String identifier = '';
  String password = '';

  bool isPressed = false;

  String errorMessage = '';

  bool useEmailLogin = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Map<String, String> errors = {};

  void validateFields() {
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
    } else if (password.length > 50) {
      errors['password'] = 'Password must contain no more than 50 characters';
    }
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    final userInfoProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign in now',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: AppColors.mellowLemon,
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Welcome to Merume!',
                style: TextStyles.body,
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
                  if (!useEmailLogin) {
                    value = value.toLowerCase();
                    _identifierController.value =
                        _identifierController.value.copyWith(
                      text: value,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: value.length),
                      ),
                    );
                  }
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
                  child: const Text(
                    'Forgot password?',
                    style: TextStyles.errorSmall,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: BasicElevatedButtonWidget(
                    buttonText: 'Login',
                    onPressed: isPressed
                        ? null
                        : () async {
                            validateFields();

                            if (errors.isNotEmpty) {
                              isPressed = false;
                            } else {
                              isPressed = true;
                            }

                            setState(() {
                              errorMessage = '';
                            });

                            if (errors.isEmpty) {
                              String? firebaseUserId;
                              try {
                                if (!useEmailLogin) {
                                  String userEmail =
                                      await getEmailByNickname(identifier);

                                  firebaseUserId = await loginInFirebase(
                                      userEmail, password);
                                } else {
                                  firebaseUserId = await loginInFirebase(
                                      identifier, password);
                                }

                                final user = await login(identifier, password,
                                    useEmailLogin, firebaseUserId!);

                                userInfoProvider.setUser(user);

                                state.pushNamedAndRemoveUntil(
                                  '/main',
                                  (Route<dynamic> route) => false,
                                );
                              } catch (e) {
                                setState(() {
                                  if (e is AuthenticationException) {
                                    if (useEmailLogin) {
                                      errorMessage =
                                          'Email or password is incorrect, please try a different email or sign up for a new account.';
                                    } else {
                                      errorMessage =
                                          'Nickname or password is incorrect, please try a different nickname or sign up for a new account.';
                                    }
                                  } else if (e
                                      is fire_base.FirebaseAuthException) {
                                    if (e.code == 'user-not-found' ||
                                        e.code == 'wrong-password') {
                                      errorMessage =
                                          'Email or password is incorrect, please try a different email or sign up for a new account.';
                                    } else if (e.code == 'invalid-email') {
                                      errorMessage =
                                          'Invalid email format. Please provide a valid email address.';
                                    } else {
                                      errorMessage =
                                          'An unexpected error occurred. Please try again later.';
                                    }
                                  } else if (e is NotFoundException) {
                                    if (useEmailLogin) {
                                      errorMessage =
                                          'Email not found, try to sign up.';
                                    } else {
                                      errorMessage =
                                          'Nickname not found, try to sign up.';
                                    }
                                  } else if (e
                                          is UnprocessableEntityException ||
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
                                    if (kDebugMode) {
                                      print(e);
                                    }

                                    errorMessage =
                                        'An unexpected error occurred. Please try again later.';
                                  }
                                });
                              } finally {
                                isPressed = false;
                              }
                            }
                          },
                    isPressed: isPressed),
              ),
              const SizedBox(height: 24.0),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/register'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('I don\'t have an account ', style: TextStyles.body),
                    Text(
                      'Sign up',
                      style: TextStyles.hintedText,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    useEmailLogin ? 'Login by unique' : 'Login by',
                    style: TextStyles.body,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        useEmailLogin = !useEmailLogin;
                      });
                    },
                    child: Text(
                      useEmailLogin ? 'Nickname' : 'Email',
                      style: TextStyles.hintedText,
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
