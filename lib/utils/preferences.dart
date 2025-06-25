import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _keyDefaultCity = 'defaultCity';
  static const _keyUseFahrenheit = 'useFahrenheit';
  static const _keyUseCurrentLocation = 'useCurrentLocation';

  static Future<void> setDefaultCity(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDefaultCity, id);
  }

  static Future<int?> getDefaultCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDefaultCity);
  }

  static Future<void> setUseFahrenheit(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseFahrenheit, value);
  }

  static Future<bool> getUseFahrenheit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUseFahrenheit) ?? false;
  }

  static Future<void> setUseCurrentLocation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseCurrentLocation, value);
  }

  static Future<bool> getUseCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUseCurrentLocation) ?? false;
  }
}
