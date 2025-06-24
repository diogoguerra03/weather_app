class Weather {
  final int cityId;
  final double temp; // Temperatura atual (em Kelvin)
  final String description;
  final String city;
  final String iconCode;
  final List<WeatherForecast> forecast;

  Weather({
    required this.cityId,
    required this.temp,
    required this.description,
    required this.city,
    required this.iconCode,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>;
    final cityJson = json['city'] as Map<String, dynamic>;

    // Extrai o id e o nome
    final int id = cityJson['id'] as int;
    final String name = cityJson['name'] as String;

    // Temperatura e descrição do primeiro item (atual)
    final current = list.first;
    final double currentTemp = (current['main']['temp'] as num).toDouble();
    final String currentDesc = current['weather'][0]['description'];
    final String currentIcon = current['weather'][0]['icon'];

    // Previsões futuras
    final forecastList = list.map((item) {
      return WeatherForecast(
        dateTime: DateTime.parse(item['dt_txt']),
        temp: (item['main']['temp'] as num).toDouble(),
        description: item['weather'][0]['description'],
        iconCode: item['weather'][0]['icon'],
      );
    }).toList();

    return Weather(
      cityId: id,
      city: name,
      temp: currentTemp,
      description: currentDesc,
      iconCode: currentIcon,
      forecast: forecastList,
    );
  }

  double get tempCelsius => temp - 273.15;
  double get tempFahrenheit => tempCelsius * 9 / 5 + 32;
}

class WeatherForecast {
  final DateTime dateTime;
  final double temp; // em Kelvin
  final String description;
  final String iconCode;

  WeatherForecast({
    required this.dateTime,
    required num temp,
    required this.description,
    required this.iconCode,
  }) : temp = temp.toDouble();

  double get tempCelsius => temp - 273.15;
  double get tempFahrenheit => tempCelsius * 9 / 5 + 32;
}
