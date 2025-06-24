import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';

class WeatherService {
  final _base = 'https://api.openweathermap.org/data/2.5/forecast';
  final _key = dotenv.env['WEATHER_API_KEY'];

  Future<Weather> fetchWeatherByCityId(int cityId) =>
      _fetch('$_base?id=$cityId&appid=$_key');

  Future<Weather> fetchWeatherByCoords(double lat, double lon) =>
      _fetch('$_base?lat=$lat&lon=$lon&appid=$_key');

  Future<Weather> _fetch(String url) async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception('Error getting weather');
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return Weather.fromJson(json);
  }
}
