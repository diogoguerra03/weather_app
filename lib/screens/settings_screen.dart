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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Default Weather Source',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: prov.useCurrentLocation
                          ? const Color(0xFF5146A6)
                          : Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                      border: prov.useCurrentLocation
                          ? Border(
                              left: BorderSide(color: Colors.white, width: 5),
                            )
                          : null,
                    ),
                    child: RadioListTile<bool>(
                      value: true,
                      groupValue: prov.useCurrentLocation,
                      onChanged: (v) =>
                          prov.setUseCurrentLocation(true, context: context),
                      activeColor: Colors.white,
                      tileColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.my_location, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Current Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Always show weather for your current location.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: !prov.useCurrentLocation
                          ? const Color(0xFF5146A6)
                          : Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                      border: !prov.useCurrentLocation
                          ? Border(
                              left: BorderSide(color: Colors.white, width: 5),
                            )
                          : null,
                    ),
                    child: RadioListTile<bool>(
                      value: false,
                      groupValue: prov.useCurrentLocation,
                      onChanged: (v) =>
                          prov.setUseCurrentLocation(false, context: context),
                      activeColor: Colors.white,
                      tileColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.star, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Favorite City',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Show weather for your selected favorite city.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
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
