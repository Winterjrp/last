import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  writeSecureData({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  readSecureData({required String key}) async {
    String value = await storage.read(key: key) ?? 'No data found!';
    return value;
  }

  deleteSecureData({required String key}) async {
    await storage.delete(key: key);
  }
}
