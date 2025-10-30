import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weatherModel.dart';

class WeatherService {
  static const String _apiHost = '';
  static const String _apiKey = '';

  Future<Weather?> fetchWeather(String city) async {
    final url = Uri.https(_apiHost, '/city', {'city': city, 'lang': 'IN'});

    try {
      final res = await http.get(url, headers: {
        'x-rapidapi-key': _apiKey,
        'x-rapidapi-host': _apiHost,
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Weather.fromJson(data);
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
