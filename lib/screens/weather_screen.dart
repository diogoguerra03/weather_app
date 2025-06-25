import 'package:flutter/material.dart';
import '../widgets/clock_widget.dart';
import '../widgets/weather_display.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/weekly_forecast.dart';
import 'settings_screen.dart';

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
              // Toggle de unidades
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const ClockWidget(),
              const SizedBox(height: 4),
              const WeatherDisplay(),
              const PreferredSize(
                preferredSize: Size.fromHeight(36),
                child: TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 2,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: TextStyle(fontSize: 14),
                  tabs: [
                    Tab(text: 'Hourly Forecast'),
                    Tab(text: 'Weekly Forecast'),
                  ],
                ),
              ),
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
