import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../models/city.dart';
import '../models/city_weather.dart';
import '../widgets/search_bar.dart';
import '../widgets/cities_grid.dart';
import '../utils/city_location_helper.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final WeatherService _service = WeatherService();

  // Default cities to show on the screen
  final List<City> _cities = [
    City(id: 2267056, name: 'Lisboa'),
    City(id: 2267094, name: 'Leiria'),
    City(id: 2740636, name: 'Coimbra'),
    City(id: 2735941, name: 'Porto'),
    City(id: 2268337, name: 'Faro'),
  ];

  late Future<List<CityWeather>> _weathersFuture;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _weathersFuture = Future.wait(
      _cities.map((city) async {
        final w = await _service.fetchWeatherByCityId(city.id);
        return CityWeather(city: city, weather: w);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),

        // SearchBar that filters the cities
        CustomSearchBar(
          hint: 'Find city...',
          onChanged: (q) => setState(() => _filter = q.toLowerCase()),
          onSearch: () async {
            await addCurrentLocationCity(
              context: context,
              cities: _cities,
              service: _service,
              setState: setState,
              updateWeathers: (future) {
                setState(() {
                  _weathersFuture = Future.wait(
                    _cities.map(
                      (c) async => CityWeather(
                        city: c,
                        weather: await _service.fetchWeatherByCityId(c.id),
                      ),
                    ),
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 16),

        Expanded(
          child: FutureBuilder<List<CityWeather>>(
            future: _weathersFuture,
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (snap.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snap.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              // filter the list based on the search query
              final filtered = snap.data!
                  .where((cw) => cw.city.name.toLowerCase().contains(_filter))
                  .toList();

              return CitiesGrid(cityWeathers: filtered);
            },
          ),
        ),
      ],
    );
  }
}
