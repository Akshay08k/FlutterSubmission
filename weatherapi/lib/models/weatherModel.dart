class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return Weather(
      cityName: json['name'] ?? '',
      temperature: (main['temp'] as num).toDouble(),
      condition: weather['main'] ?? '',
      description: weather['description'] ?? '',
      humidity: main['humidity'] ?? 0,
      windSpeed: (wind['speed'] as num).toDouble(),
    );
  }
}
