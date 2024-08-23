import 'package:shared_preferences/shared_preferences.dart';
import '../config/storage_keys.dart';

class StorageService {
  late final SharedPreferences _prefs;
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setString(String key, value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  bool getDeviceFirstOpen() {
    return _prefs.getBool(StorageKeys.STORAGE_DEVICE_FIRST_OPEN) ?? false;
  }
}
