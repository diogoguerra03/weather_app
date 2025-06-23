import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'package:intl/intl.dart';

class WeeklyForecast extends StatelessWidget {
  const WeeklyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final forecastList = provider.forecast;

    if (forecastList.isEmpty) {
      return const SizedBox();
    }

    final List<Map<String, dynamic>> daily = [];

    for (final f in forecastList) {
      final date = DateTime(f.dateTime.year, f.dateTime.month, f.dateTime.day);
      final existing = daily.indexWhere((d) => d['date'] == date);

      if (existing == -1) {
        daily.add({
          'date': date,
          'temp': f.tempCelsius,
          'icon': f.iconCode,
          'desc': f.description,
        });
      }
      if (daily.length == 7) break;
    }

    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    final todayExists = daily.any((d) => d['date'] == todayDate);
    if (!todayExists) {
      final todayForecast = forecastList.firstWhere(
        (f) =>
            f.dateTime.year == todayDate.year &&
            f.dateTime.month == todayDate.month &&
            f.dateTime.day == todayDate.day,
        orElse: () => forecastList[0],
      );

      daily.insert(0, {
        'date': todayDate,
        'temp': todayForecast.tempCelsius,
        'icon': todayForecast.iconCode,
        'desc': todayForecast.description,
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: daily.length,
          itemBuilder: (context, index) {
            final item = daily[index];
            final DateTime date = item['date'];
            final String icon = item['icon'];
            final String desc = item['desc'];

            final isToday =
                date.day == now.day &&
                date.month == now.month &&
                date.year == now.year;

            final label = isToday
                ? 'Today'
                : DateFormat.E().format(date); // Mon, Tue...

            final margin = EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8);

            return Container(
              width: 80,
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
                    'https://openweathermap.org/img/wn/$icon@2x.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item['temp'].toStringAsFixed(0)}°',
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
