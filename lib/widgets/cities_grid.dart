import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city_weather.dart';
import '../providers/weather_provider.dart';
import '../utils/preferences.dart';

class CitiesGrid extends StatelessWidget {
  final List<CityWeather> cityWeathers;
  const CitiesGrid({super.key, required this.cityWeathers});

  @override
  Widget build(BuildContext context) {
    final useF = context.watch<WeatherProvider>().useFahrenheit;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cityWeathers.length,
      itemBuilder: (ctx, i) {
        final cw = cityWeathers[i];
        final w = cw.weather;
        final tempValue = useF ? w.tempFahrenheit : w.tempCelsius;
        final unitLabel = useF ? '°F' : '°C';

        final h = (tempValue + 3).toStringAsFixed(0) + unitLabel;
        final l = (tempValue - 3).toStringAsFixed(0) + unitLabel;

        return GestureDetector(
          onTap: () async {
            await Preferences.setDefaultCity(cw.city.id);
            if (context.mounted) {
              // Atualiza o WeatherProvider
              context.read<WeatherProvider>().loadWeather(cw.city.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Default city updated successfully: ${cw.city.name}!',
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // on top: temperature + icon
                Row(
                  children: [
                    Text(
                      '${tempValue.toStringAsFixed(0)}$unitLabel',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Image.network(
                      'https://openweathermap.org/img/wn/${w.iconCode}@2x.png',
                      width: 72,
                      height: 72,
                    ),
                  ],
                ),

                const Spacer(),

                // Low: H/L
                Row(
                  children: [
                    Text(
                      'H:$h',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'L:$l',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                // Low: nome da cidade
                Text(
                  cw.city.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
