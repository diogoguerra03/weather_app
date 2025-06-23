class Weather {
  final double temp; // em Kelvin
  final String description;
  final String city;

  Weather({required this.temp, required this.description, required this.city});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final firstItem = json['list'][0];
    return Weather(
      temp: firstItem['main']['temp'],
      description: firstItem['weather'][0]['description'],
      city: json['city']['name'],
    );
  }

  double get tempCelsius => temp - 273.15;
  double get tempFahrenheit => tempCelsius * 9 / 5 + 32;
}
