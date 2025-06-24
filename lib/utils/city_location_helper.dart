import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

Future<void> addCurrentLocationCity({
  required BuildContext context,
  required List<City> cities,
  required WeatherService service,
  required void Function(void Function()) setState,
  required void Function(Future<List<Weather>> future) updateWeathers,
}) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
  }
  final pos = await Geolocator.getCurrentPosition();
  final weather = await service.fetchWeatherByCoords(
    pos.latitude,
    pos.longitude,
  );
  final newCityId = weather.cityId;
  final newCityName = weather.city;
  if (!cities.any((c) => c.id == newCityId)) {
    setState(() {
      cities.add(City(id: newCityId, name: newCityName));
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('City "$newCityName" added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('City "$newCityName" is already in the list.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
  updateWeathers(
    Future.wait(
      cities.map((c) async => await service.fetchWeatherByCityId(c.id)),
    ),
  );
}
