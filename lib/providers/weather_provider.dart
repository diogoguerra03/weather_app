import 'package:flutter/material.dart';
import '../utils/preferences.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../utils/location_helper.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  bool _useFahrenheit = false;
  bool get useFahrenheit => _useFahrenheit;

  bool _useCurrentLocation = false;
  bool get useCurrentLocation => _useCurrentLocation;

  // Constructor to initialize the provider and load the unit and location preferences
  WeatherProvider() {
    _loadPreferences();
  }

  // Load the unit and location preferences from Preferences
  Future<void> _loadPreferences() async {
    _useFahrenheit = await Preferences.getUseFahrenheit();
    _useCurrentLocation = await Preferences.getUseCurrentLocation();
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

  // Set the unit directly
  void setUnit(bool fahrenheit) {
    _useFahrenheit = fahrenheit;
    _saveUnitPreference();
    notifyListeners();
  }

  Future<void> setUseCurrentLocation(
    bool value, {
    BuildContext? context,
  }) async {
    _useCurrentLocation = value;
    await Preferences.setUseCurrentLocation(value);
    notifyListeners();
    if (value) {
      try {
        final pos = await LocationHelper.getCurrentPosition();
        final weather = await _weatherService.fetchWeatherByCoords(
          pos.latitude,
          pos.longitude,
        );
        await Preferences.setDefaultCity(weather.cityId);
        await loadWeather(weather.cityId);
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Current location set successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get current location: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
      _weather = await _weatherService.fetchWeatherByCityId(cityId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
