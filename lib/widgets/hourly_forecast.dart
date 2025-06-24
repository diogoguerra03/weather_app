import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);
    final list = prov.forecast;
    if (list.isEmpty) return const SizedBox();

    final now = DateTime.now();
    final current = list.firstWhere(
      (f) =>
          f.dateTime.hour == now.hour &&
          f.dateTime.day == now.day &&
          f.dateTime.month == now.month,
      orElse: () => list[0],
    );

    final modified = <Map<String, Object>>[
      {
        'label': 'Now',
        'temp': prov.useFahrenheit
            ? current.tempFahrenheit
            : current.tempCelsius,
        'desc': current.description,
        'icon': current.iconCode,
        'isNow': true,
      },
      ...list
          .take(9)
          .map(
            (f) => {
              'label': '${f.dateTime.hour.toString().padLeft(2, '0')}:00',
              'temp': prov.useFahrenheit ? f.tempFahrenheit : f.tempCelsius,
              'desc': f.description,
              'icon': f.iconCode,
              'isNow': false,
            },
          ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: modified.length,
          itemBuilder: (context, i) {
            final item = modified[i];
            final label = item['label'] as String;
            final desc = item['desc'] as String;
            final icon = item['icon'] as String;
            final temp = (item['temp'] as double).toStringAsFixed(0);
            final isNow = item['isNow'] as bool;

            final margin = EdgeInsets.only(left: i == 0 ? 16 : 8, right: 8);

            return Container(
              width: 80,
              margin: margin,
              decoration: BoxDecoration(
                color: isNow ? Colors.white38 : Colors.white24,
                borderRadius: BorderRadius.circular(12),
                border: isNow
                    ? Border.all(color: Colors.white, width: 1.5)
                    : null,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/$icon@2x.png',
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    '$temp°',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.white70),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
