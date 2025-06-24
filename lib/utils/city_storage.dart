import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';

class CityStorage {
  static const _key = 'savedCities';

  static Future<void> saveCities(List<City> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cities.map((c) => {'id': c.id, 'name': c.name}).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<City>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => City(id: e['id'], name: e['name'])).toList();
  }

  static Future<void> addCity(City city) async {
    final prefs = await SharedPreferences.getInstance();
    final cities = await loadCities();
    if (!cities.any((c) => c.id == city.id)) {
      cities.add(city);
      final jsonList = cities.map((c) => {'id': c.id, 'name': c.name}).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
    }
  }

  static Future<void> removeCity(int cityId) async {
    final prefs = await SharedPreferences.getInstance();
    final cities = await loadCities();
    cities.removeWhere((c) => c.id == cityId);
    final jsonList = cities.map((c) => {'id': c.id, 'name': c.name}).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }
}
