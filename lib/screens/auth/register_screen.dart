import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../api/auth_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String nickname = '';
  String email = '';
  String password = '';

  String errorMessage = '';

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Map<String, String> errors = {};

  void validateFields(String nickname, String email, String password) {
    // Clear previous errors
    errors.clear();

    // Check nickname
    if (nickname.isEmpty) {
      errors['nickname'] = 'Nickname is required';
    }

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
                'Sign up now',
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
                  'Error: ${errorMessage.substring(11)}',
                  style: const TextStyle(
                      fontFamily: 'WorkSans', fontSize: 16, color: Colors.red),
                ),
              if (errorMessage.isNotEmpty) const SizedBox(height: 24.0),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: 'Nickname',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('nickname')
                      ? errors['nickname']
                      : null,
                ),
                onChanged: (value) {
                  nickname = value;
                },
              ),
              const SizedBox(height: 50.0),
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
              const SizedBox(height: 50.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    validateFields(nickname, email, password);
                    setState(() {
                      errorMessage = '';
                    });
                    if (errors.isEmpty) {
                      try {
                        final user = await register(nickname, email, password);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/main',
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        setState(() {
                          errorMessage = e.toString();
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
                    'Sign up',
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
                    Navigator.of(context).pushReplacementNamed('/login')),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I already have an account ',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sign in',
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
            ]),
      )),
    );
  }
}
