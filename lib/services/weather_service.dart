import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

  Future<Weather> fetchWeather(int cityId) async {
    final apiKey = dotenv.env['WEATHER_API_KEY'];
    final url = Uri.parse('$_baseUrl?id=$cityId&APPID=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Error fetching weather data: ${response.statusCode}');
    }
  }
}
