import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final forecastList = provider.forecast;

    if (forecastList.isEmpty) {
      return const SizedBox();
    }

    final now = DateTime.now();

    // Get the current forecast item based on the current time
    final currentForecast = forecastList.firstWhere(
      (f) =>
          f.dateTime.hour == now.hour &&
          f.dateTime.day == now.day &&
          f.dateTime.month == now.month,
      orElse: () => forecastList[0], // fallback
    );

    // Create a modified list with the current forecast at the start
    final modifiedForecastList = [
      {
        'label': 'Now',
        'temp': currentForecast.tempCelsius,
        'desc': currentForecast.description,
        'icon': currentForecast.iconCode,
        'isNow': true,
      },
      ...forecastList
          .take(9) // max 10 (atual + 9) items after the current time
          .map(
            (f) => {
              'label': '${f.dateTime.hour.toString().padLeft(2, '0')}:00',
              'temp': f.tempCelsius,
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
          itemCount: modifiedForecastList.length,
          itemBuilder: (context, index) {
            final item = modifiedForecastList[index];
            final label = item['label'] as String;
            final temp = '${(item['temp'] as double).toStringAsFixed(0)}°';
            final desc = item['desc'] as String;
            final icon = item['icon'] as String;
            final isNow = item['isNow'] as bool;

            final margin = EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8);

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
                    temp,
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
