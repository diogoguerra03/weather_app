import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final forecastList = provider.forecast;

    if (forecastList == null || forecastList.isEmpty) {
      return const SizedBox(); // ou CircularProgressIndicator
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastList.length.clamp(
          0,
          10,
        ), // só mostrar os 10 primeiros
        itemBuilder: (context, index) {
          final forecast = forecastList[index];
          final time =
              '${forecast.dateTime.hour.toString().padLeft(2, '0')}:00';
          final temp = '${forecast.tempCelsius.toStringAsFixed(0)}°';
          final desc = forecast.description;

          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(time, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  temp,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 4),
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
    );
  }
}
