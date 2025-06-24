import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class WeeklyForecast extends StatelessWidget {
  const WeeklyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);
    final list = prov.forecast;
    if (list.isEmpty) return const SizedBox();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<Map<String, dynamic>> daily = [];
    for (var f in list) {
      final d = DateTime(f.dateTime.year, f.dateTime.month, f.dateTime.day);
      if (!daily.any((e) => e['date'] == d)) {
        daily.add({
          'date': d,
          'temp': prov.useFahrenheit ? f.tempFahrenheit : f.tempCelsius,
          'icon': f.iconCode,
          'desc': f.description,
        });
      }
      if (daily.length == 7) break;
    }
    // Today is always the first item
    if (!daily.any((e) => e['date'] == today)) {
      final tf = list.firstWhere(
        (f) =>
            f.dateTime.year == today.year &&
            f.dateTime.month == today.month &&
            f.dateTime.day == today.day,
        orElse: () => list[0],
      );
      daily.insert(0, {
        'date': today,
        'temp': prov.useFahrenheit ? tf.tempFahrenheit : tf.tempCelsius,
        'icon': tf.iconCode,
        'desc': tf.description,
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: daily.length,
          itemBuilder: (ctx, i) {
            final item = daily[i];
            final isToday = item['date'] == today;
            final label = isToday
                ? 'Today'
                : DateFormat.E().format(item['date']);
            final margin = EdgeInsets.only(left: i == 0 ? 16 : 8, right: 8);
            return Container(
              width: 100,
              margin: margin,
              decoration: BoxDecoration(
                color: isToday ? Colors.white38 : Colors.white24,
                borderRadius: BorderRadius.circular(12),
                border: isToday
                    ? Border.all(color: Colors.white, width: 1.5)
                    : null,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white)),
                  Image.network(
                    'https://openweathermap.org/img/wn/${item['icon']}@2x.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(item['temp'] as double).toStringAsFixed(0)}°',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['desc'],
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
