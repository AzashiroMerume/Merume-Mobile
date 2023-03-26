import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Register> register(
    String nickname, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:8081/auth/register'),
    body: json.encode({
      'nickname': nickname,
      'email': email,
      'password': password,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  final responseData = json.decode(response.body);

  if (responseData['success'] != false) {
    return Register.fromJson(responseData['data'][0]);
  } else {
    final errorMessage = responseData['error_message'];
    throw Exception(errorMessage);
  }
}

Future<Login> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:8081/auth/login'),
    body: json.encode({'email': email, 'password': password}),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  final responseData = json.decode(response.body);

  if (responseData['success'] != false) {
    return Login.fromJson(responseData['data'][0]);
  } else {
    final errorMessage = responseData['error_message'];
    throw Exception(errorMessage);
  }
}

class Register {
  final String id;

  const Register({
    required this.id,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      id: json['insertedId']['\$oid'],
    );
  }
}

class Login {
  final String id;

  const Login({
    required this.id,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['\$oid'],
    );
  }
}
