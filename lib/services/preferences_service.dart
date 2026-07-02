import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _isLoggedInKey = 'is_logged_in';

  // Singleton pattern for easy access
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  Future<bool> get isFirstLaunch async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, value);
  }

  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  Future<void> resetAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }
}
