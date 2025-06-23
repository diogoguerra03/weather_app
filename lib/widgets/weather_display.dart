import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherDisplay extends StatelessWidget {
  const WeatherDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    if (provider.isLoading) {
      return const CircularProgressIndicator(color: Colors.white);
    } else if (provider.error != null) {
      return Text(
        'Erro: ${provider.error}',
        style: const TextStyle(color: Colors.white),
      );
    } else if (provider.weather != null) {
      final weather = provider.weather!;
      final iconUrl =
          'https://openweathermap.org/img/wn/${weather.iconCode}@4x.png';

      return Column(
        children: [
          const SizedBox(height: 8),
          Text(
            weather.city,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${weather.tempCelsius.toStringAsFixed(0)}°',
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          Image.network(
            iconUrl,
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.cloud_off, size: 60, color: Colors.white54),
          ),
          Text(
            weather.description,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
          ),
        ],
      );
    } else {
      return const Text(
        'Sem dados disponíveis.',
        style: TextStyle(color: Colors.white),
      );
    }
  }
}
