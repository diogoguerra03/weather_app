import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherDisplay extends StatelessWidget {
  const WeatherDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    if (provider.isLoading) {
      return const CircularProgressIndicator();
    } else if (provider.error != null) {
      return Text('Erro: ${provider.error}');
    } else if (provider.weather != null) {
      final weather = provider.weather!;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.city,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '${weather.tempCelsius.toStringAsFixed(1)} °C',
            style: const TextStyle(fontSize: 30),
          ),
          Text(weather.description),
        ],
      );
    } else {
      return const Text('Data not available');
    }
  }
}
