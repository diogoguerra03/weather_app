import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../utils/preferences.dart';

class StartupHelper {
  static Future<int> getStartupCityId() async {
    final useCurrentLocation = await Preferences.getUseCurrentLocation();
    if (useCurrentLocation) {
      try {
        final pos = await Geolocator.getCurrentPosition();
        final weather = await WeatherService().fetchWeatherByCoords(
          pos.latitude,
          pos.longitude,
        );
        await Preferences.setDefaultCity(weather.cityId);
        return weather.cityId;
      } catch (e) {
        // fallback para última cidade favorita se der erro
        final fallback = await Preferences.getDefaultCity() ?? 2267094;
        return fallback;
      }
    } else {
      return await Preferences.getDefaultCity() ?? 2267094;
    }
  }
}
