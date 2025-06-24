import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/city.dart';
import '../models/city_weather.dart';
import '../widgets/search_bar.dart';
import '../widgets/cities_grid.dart';
import '../utils/city_location_helper.dart';
import '../utils/city_storage.dart';
import '../widgets/add_city_bottom_sheet.dart';

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

  late Future<List<CityWeather>> _weathersFuture = Future.value([]);
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    final loaded = await CityStorage.loadCities();
    if (loaded.isNotEmpty) {
      setState(() {
        _cities.clear();
        _cities.addAll(loaded);
      });
    }
    setState(() {
      _weathersFuture = Future.wait(
        _cities.map((city) async {
          final w = await _service.fetchWeatherByCityId(city.id);
          return CityWeather(city: city, weather: w);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                    CityStorage.saveCities(_cities);
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
                        'Error: {snap.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  final filtered = snap.data!
                      .where(
                        (cw) => cw.city.name.toLowerCase().contains(_filter),
                      )
                      .toList();
                  return CitiesGrid(
                    cityWeathers: filtered,
                    onRemoveCity: (cityWeather) async {
                      setState(() {
                        _cities.removeWhere((c) => c.id == cityWeather.city.id);
                        _weathersFuture = Future.wait(
                          _cities.map(
                            (c) async => CityWeather(
                              city: c,
                              weather: await _service.fetchWeatherByCityId(
                                c.id,
                              ),
                            ),
                          ),
                        );
                      });
                      await CityStorage.saveCities(_cities);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'City "${cityWeather.city.name}" removed.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFE0E7FF), // cor mais clara
            child: const Icon(
              Icons.add,
              color: Color(0xFF362A84),
            ), // ícone escuro para contraste
            onPressed: () async {
              final city = await showModalBottomSheet<City>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (ctx) => AddCityBottomSheet(
                  existingCities: List<City>.from(_cities),
                ),
              );
              if (city != null && city.name.trim().isNotEmpty) {
                if (!_cities.any((c) => c.id == city.id)) {
                  setState(() {
                    _cities.add(city);
                    _weathersFuture = Future.wait(
                      _cities.map(
                        (c) async => CityWeather(
                          city: c,
                          weather: await _service.fetchWeatherByCityId(c.id),
                        ),
                      ),
                    );
                  });
                  await CityStorage.saveCities(_cities);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('City "${city.name}" added.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'City "${city.name}" is already in the list.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
