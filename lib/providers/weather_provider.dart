import 'package:flutter/material.dart';
import '../utils/preferences.dart';
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

  // Load the unit preference from Preferences
  Future<void> _loadUnitPreference() async {
    _useFahrenheit = await Preferences.getUseFahrenheit();
    notifyListeners();
  }

  // Save the unit preference to Preferences
  Future<void> _saveUnitPreference() async {
    await Preferences.setUseFahrenheit(_useFahrenheit);
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
