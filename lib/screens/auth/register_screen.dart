import 'dart:async';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_base;
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/api/auth_api/firebase_auth_api.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/api/auth_api/register_api.dart';
import 'package:merume_mobile/utils/exceptions.dart';
import 'package:merume_mobile/providers/user_provider.dart';
import 'package:merume_mobile/utils/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:merume_mobile/screens/shared/basic/basic_elevated_button_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String username = '';
  String nickname = '';
  String email = '';
  String password = '';

  bool isPressed = false;

  String errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Map<String, String> errors = {};

  void validateFields() {
    // Clear previous errors
    errors.clear();

    //check username
    if (username.trim().isEmpty) {
      errors['username'] = 'Username is requred';
    } else if (username.trim().length > 20) {
      errors['username'] = 'Username must contain no more than 20 characters';
    }

    // Check nickname
    if (nickname.trim().isEmpty) {
      errors['nickname'] = 'Nickname is required';
    } else if (RegExp(r"\s").hasMatch(nickname.trim())) {
      errors['nickname'] = 'Nickname must be a non-conjoint string';
    } else if (nickname.trim().length < 6) {
      errors['nickname'] = 'Nickname must be at least 6 characters long';
    } else if (nickname.trim().length > 20) {
      errors['nickname'] = 'Nickname must contain no more than 20 characters';
    }

    // Check email
    if (email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!EmailValidator.validate(email)) {
      errors['email'] = 'Invalid email format';
    }

    // Check password
    if (password.trim().isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.trim().length < 8) {
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
          padding: const EdgeInsets.only(right: 47.0, left: 47.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign up now',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                      color: AppColors.mellowLemon),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Welcome to Merume!',
                  style: TextStyles.body,
                ),
                const SizedBox(height: 40.0),
                if (errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
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
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    fillColor: Colors.white,
                    filled: true,
                    errorText: errors.containsKey('username')
                        ? errors['username']
                        : null,
                  ),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 40.0),
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    hintText: 'Unique Nickname',
                    fillColor: Colors.white,
                    filled: true,
                    errorText: errors.containsKey('nickname')
                        ? errors['nickname']
                        : null,
                  ),
                  onChanged: (value) {
                    // Convert the input to lowercase
                    value = value.toLowerCase();
                    _nicknameController.value =
                        _nicknameController.value.copyWith(
                      text: value,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: value.length),
                      ),
                    );

                    nickname = value;
                  },
                ),
                const SizedBox(height: 40.0),
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
                const SizedBox(height: 40.0),
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
                const SizedBox(height: 40.0),
                Center(
                  child: BasicElevatedButtonWidget(
                    buttonText: 'Sign up',
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
                                firebaseUserId =
                                    await registerInFirebase(email, password);

                                final user = await register(username, nickname,
                                    email, password, firebaseUserId!);

                                userInfoProvider.setUser(user);

                                state.pushNamedAndRemoveUntil(
                                  '/main',
                                  (Route<dynamic> route) => false,
                                );
                              } catch (e) {
                                if (e is! fire_base.FirebaseException) {
                                  deleteCurrentFirebaseUser();
                                }

                                setState(() {
                                  if (e is RegistrationException) {
                                    errorMessage = e.message;
                                  } else if (e
                                      is fire_base.FirebaseAuthException) {
                                    if (e.code == 'email-already-in-use') {
                                      errorMessage =
                                          'The email address is already in use. Please use a different email or try logging in.';
                                    } else {
                                      errorMessage =
                                          'An unexpected error occurred. Please try again later.';
                                    }
                                  } else if (e
                                          is UnprocessableEntityException ||
                                      e is ContentTooLargeException) {
                                    errorMessage =
                                        'Invalid input data. Please follow the requirements.';
                                  } else if (e is NetworkException) {
                                    errorMessage =
                                        'Network error has occured. Please check your internet connection.';
                                  } else if (e is ServerException ||
                                      e is HttpException) {
                                    errorMessage =
                                        'There was an error on the server side, try again later.';
                                  } else if (e is TimeoutException) {
                                    errorMessage =
                                        'Network connection is poor, try again later.';
                                  } else {
                                    if (kDebugMode) {
                                      errorMessage =
                                          'An unexpected error occurred. Please try again later.';
                                    }
                                  }
                                });
                              } finally {
                                isPressed = false;
                              }
                            }
                          },
                    isPressed: isPressed,
                  ),
                ),
                const SizedBox(height: 24.0),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/login'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I already have an account ',
                        style: TextStyles.body,
                      ),
                      Text(
                        'Sign in',
                        style: TextStyles.hintedText,
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
