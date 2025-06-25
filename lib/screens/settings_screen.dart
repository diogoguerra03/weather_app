import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF362A84),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Temperature Unit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12,
              ),
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text(
                      'Cº',
                      style: TextStyle(
                        color: !prov.useFahrenheit
                            ? Colors.white
                            : Color(0xFF362A84), // cor escura para contraste
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: !prov.useFahrenheit,
                    selectedColor: Color(0xFF5146A6),
                    backgroundColor: !prov.useFahrenheit
                        ? Colors.white12
                        : Colors.white,
                    onSelected: (v) => prov.setUnit(false),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: Text(
                      'Fº',
                      style: TextStyle(
                        color: prov.useFahrenheit
                            ? Colors.white
                            : Color(0xFF362A84), // cor escura para contraste
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: prov.useFahrenheit,
                    selectedColor: Color(0xFF5146A6),
                    backgroundColor: prov.useFahrenheit
                        ? Colors.white12
                        : Colors.white,
                    onSelected: (v) => prov.setUnit(true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
