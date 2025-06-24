import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  bool _useFahrenheit = false;
  bool get useFahrenheit => _useFahrenheit;

  // Constructor to initialize the provider and load the unit preference
  WeatherProvider() {
    _loadUnitPreference();
  }

  // Load the unit preference from SharedPreferences
  Future<void> _loadUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _useFahrenheit = prefs.getBool('useFahrenheit') ?? false;
    notifyListeners();
  }

  // Save the unit preference to SharedPreferences
  Future<void> _saveUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useFahrenheit', _useFahrenheit);
  }

  // Toggle the unit between Celsius and Fahrenheit
  void toggleUnit() {
    _useFahrenheit = !_useFahrenheit;
    _saveUnitPreference();
    notifyListeners();
  }

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<WeatherForecast> get forecast => _weather?.forecast ?? [];

  Future<void> loadWeather(int cityId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _weatherService.fetchWeather(cityId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
