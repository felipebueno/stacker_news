import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_api/sn_api.dart' show SnStorage;
import 'package:stacker_news/utils/log_service.dart';

class SharedPrefsManager {
  static Future<void> set(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      LogService().error(
        'SharedPrefsManager.set error: value => $value for key => $key has unexpected type.',
      );
    }
  }

  static Future<dynamic> get(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.get(key);
  }

  static Future<bool> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    // TODO: Clear cookies
    // final appDocDir = await getApplicationDocumentsDirectory();
    // final String appDocPath = appDocDir.path;
    // await PersistCookieJar(
    //   ignoreExpires: true,
    //   storage: FileStorage('$appDocPath/.cookies/'),
    // ).deleteAll();

    final prefs = await SharedPreferences.getInstance();

    return prefs.clear();
  }
}

/// [SnStorage] implementation backed by [SharedPreferences].
/// Inject this into [SNApiClient] so the library can persist cursors and
/// session data using the platform's shared preferences.
class SharedPrefsStorage implements SnStorage {
  @override
  Future<void> set(String key, String value) => SharedPrefsManager.set(key, value);

  @override
  Future<String?> getString(String key) async {
    final value = await SharedPrefsManager.get(key);
    return value?.toString();
  }

  @override
  Future<bool> remove(String key) => SharedPrefsManager.delete(key);

  @override
  Future<bool> clear() => SharedPrefsManager.clear();
}
