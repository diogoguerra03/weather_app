import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/widgets/clock_widget.dart';
import 'widgets/weather_display.dart';
import 'providers/weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const int cityId = 2267094; // Leiria

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider()..loadWeather(cityId),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Weather App')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ClockWidget(), WeatherDisplay()],
            ),
          ),
        ),
      ),
    );
  }
}
