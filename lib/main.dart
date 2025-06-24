import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/weather_provider.dart';
import 'screens/weather_screen.dart';
import 'screens/cities_screen.dart';
import 'widgets/bottom_nav.dart';

import 'utils/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final defaultId = await Preferences.getDefaultCity() ?? 2267094;

  runApp(MyApp(defaultId: defaultId));
}

class MyApp extends StatelessWidget {
  final int defaultId;
  const MyApp({super.key, required this.defaultId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider()..loadWeather(defaultId),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _Root(),
      ),
    );
  }
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  int _selectedIndex = 0;

  static const _pages = [WeatherScreen(), CitiesScreen()];

  void _onNavTap(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF362A84),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
