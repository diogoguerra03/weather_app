import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherDisplay extends StatelessWidget {
  const WeatherDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);

    if (prov.isLoading) {
      return const CircularProgressIndicator(color: Colors.white);
    } else if (prov.error != null) {
      return Text(
        'Erro: ${prov.error}',
        style: const TextStyle(color: Colors.white),
      );
    } else if (prov.weather != null) {
      final w = prov.weather!;
      final temp = prov.useFahrenheit
          ? w.tempFahrenheit.toStringAsFixed(0)
          : w.tempCelsius.toStringAsFixed(0);
      final iconUrl = 'https://openweathermap.org/img/wn/${w.iconCode}@4x.png';

      return Column(
        children: [
          const SizedBox(height: 8),
          Text(
            w.city,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$temp°',
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          Image.network(iconUrl, width: 200, height: 200),
          Text(
            w.description,
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
