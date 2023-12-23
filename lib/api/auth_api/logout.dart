import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<bool> logout() async {
  await storage.delete(key: 'accessToken');
  final checkToken = await storage.read(key: 'accessToken');

  return checkToken == null;
}
