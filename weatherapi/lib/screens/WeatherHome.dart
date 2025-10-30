import 'package:flutter/material.dart';
import '../models/weatherModel.dart';
import '../services/WeatherServices.dart';


class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();


}

class _WeatherHomeState extends State<WeatherHome> {

  double convertToCelcius(double fah){
    double cel = 0;
    cel = (fah - 32) * 5/9;
    return cel.roundToDouble();
  }
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _loading = false;
  String _error = '';

  Future<void> _getWeather() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = '';
      _weather = null;
    });

    final result = await _weatherService.fetchWeather(city);
    setState(() {
      if (result != null) {
        _weather = result;
      } else {
        _error = 'City not found or API error';
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('🌤 Rapid Weather'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // City Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: _getWeather,
                      ),
                    ),
                    onSubmitted: (_) => _getWeather(),
                  ),
                ),
                const SizedBox(height: 30),

                // Content
                if (_loading)
                  const Center(child: CircularProgressIndicator(color: Colors.white))
                else if (_error.isNotEmpty)
                  Text(_error, style: const TextStyle(color: Colors.redAccent, fontSize: 16))
                else if (_weather != null)
                    Expanded(child: _buildWeatherCard(_weather!))
                  else
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Type a city and tap search 🔍',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildWeatherCard(Weather weather) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(weather.cityName,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Text(weather.condition,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white70)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoColumn("🌡 Temp", "${convertToCelcius(weather.temperature)} °C"),
                _infoColumn("💧 Humidity", "${weather.humidity}%"),
                _infoColumn("💨 Wind", "${weather.windSpeed} mph"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
