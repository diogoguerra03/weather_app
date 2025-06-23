import 'package:flutter/material.dart';
import '../widgets/clock_widget.dart';
import '../widgets/weather_display.dart';
import '../widgets/hourly_forecast.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF362A84),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SizedBox(height: 20),
            ClockWidget(),
            SizedBox(height: 40),
            WeatherDisplay(),
            SizedBox(height: 60),
            HourlyForecast(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
