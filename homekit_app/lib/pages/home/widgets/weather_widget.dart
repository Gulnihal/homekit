import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/pages/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final HomeServices homeServices = HomeServices();
  Weather? _weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final weather = await homeServices.getWeatherData(context);
    setState(() {
      _weatherData = weather;
    });
  }

  IconData _getWeatherIcon(String? weatherIcon) {
    switch (weatherIcon) {
      case '01d':
        return Icons.wb_sunny;
      case '01n':
        return Icons.nightlight_round;
      case '02d':
      case '02n':
        return Icons.cloud;
      case '03d':
      case '03n':
        return Icons.cloud_queue;
      case '04d':
      case '04n':
        return Icons.cloud_off;
      case '09d':
      case '09n':
        return Icons.waves;
      case '10d':
      case '10n':
        return Icons.beach_access;
      case '11d':
      case '11n':
        return Icons.flash_on;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.filter_drama;
      default:
        return Icons.error;
    }
  }

  Color _getWeatherColor(String? weatherIcon) {
    switch (weatherIcon) {
      case '01d':
        return Colors.orange;
      case '01n':
        return Colors.indigo;
      case '02d':
      case '02n':
        return Colors.white70;
      case '03d':
      case '03n':
        return Colors.black45;
      case '04d':
      case '04n':
        return Colors.black45;
      case '09d':
      case '09n':
        return Colors.blueGrey;
      case '10d':
      case '10n':
        return Colors.amber;
      case '11d':
      case '11n':
        return Colors.blueAccent;
      case '13d':
      case '13n':
        return Colors.cyanAccent;
      case '50d':
      case '50n':
        return Colors.blueGrey;
      default:
        return Colors.red;
    }
  }

  Color _getTemperatureColor(double? temperature){
    if (temperature! > 30.0){
      return Colors.red;
    }
    if (temperature > 20.0){
      return Colors.orange;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 35, 20),
      decoration: BoxDecoration(
        gradient: GlobalVariables.weatherBox,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: homeServices.getWeather() == null
          ? const CircularProgressIndicator()
          : Row(
        children: [
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather Information',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    _getWeatherIcon(homeServices.getWeather()!.weatherIcon),
                    color: _getWeatherColor(homeServices.getWeather()!.weatherIcon),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    homeServices.getWeather()?.weatherMain ?? 'N/A',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width / 40),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.thermostat_outlined,
                    color: _getTemperatureColor(homeServices.getWeather()!.temperature!.celsius),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${homeServices.getWeather()!.temperature?.celsius?.toStringAsFixed(1)}°C',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width / 40),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
