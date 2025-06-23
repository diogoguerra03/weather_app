import 'package:flutter/material.dart';
import '../widgets/clock_widget.dart';
import '../widgets/weather_display.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/weekly_forecast.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF362A84),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const ClockWidget(),
              const SizedBox(height: 40),
              const WeatherDisplay(),
              const SizedBox(height: 350),
              PreferredSize(
                preferredSize: const Size.fromHeight(36),
                child: Container(
                  color: const Color(0xFF362A84),
                  child: const TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 2,
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 14),
                    unselectedLabelColor: Colors.white54,
                    tabs: [
                      Tab(text: 'Hourly Forecast'),
                      Tab(text: 'Weekly Forecast'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: TabBarView(
                  children: [HourlyForecast(), WeeklyForecast()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
