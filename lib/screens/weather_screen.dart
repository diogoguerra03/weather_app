import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/clock_widget.dart';
import '../widgets/weather_display.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/weekly_forecast.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('°C', style: TextStyle(color: Colors.white)),
                    Switch(
                      value: prov.useFahrenheit,
                      onChanged: (_) => prov.toggleUnit(),
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                    ),
                    const Text('°F', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const ClockWidget(),
              const SizedBox(height: 40),
              const WeatherDisplay(),
              const SizedBox(height: 100),
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
