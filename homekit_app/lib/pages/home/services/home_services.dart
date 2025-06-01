import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:homekit_app/providers/user_provider.dart';
import 'package:homekit_app/constants/error_handling.dart';
import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/constants/utils.dart';
import 'package:homekit_app/models/device.dart';
import 'package:weather/weather.dart';
// import 'package:geolocator/geolocator.dart';

class HomeServices {
  Weather? weatherData;
  Future<Weather?> getWeatherData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/get-weather-data'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'accessToken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> decodedBody = jsonDecode(res.body);
        weatherData = Weather(decodedBody['weatherData']);
        return Weather(decodedBody['weatherData']);
      } else {
        throw Exception('API error: ${res.statusCode}');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return null;
  }
  Weather? getWeather() => weatherData;

  //TODO not emulator friendly
  // Future<Position> getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Location service is not active.');
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
  //       throw Exception('Access denied.');
  //     }
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }
  //
  // Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
  //   const apiKey = '01578481c3bb78f5238d649488e962ff';
  //   final url = Uri.parse(
  //     'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&lang=tr&appid=$apiKey',
  //   );
  //
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('No weather status received.');
  //   }
  // }

  Future<bool> addDevice({
    required BuildContext context,
    required name,
    required wifi,
    required pass,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-device'),
        body: jsonEncode({
          'name': name,
          'wifi': wifi,
          'pass': pass,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'accessToken': userProvider.user.token,
        },
      );
      if (res.statusCode == 200) {
        showSnackBar(context, 'Device Added Successfully!');
        return true;
      } else {
        showSnackBar(context, jsonDecode(res.body)['msg']);
        return false;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  //todo beklet
  Future<Map<String, dynamic>> refreshDeviceData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
    Uri.parse('$uri/api/device/refresh'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'accessToken': userProvider.user.token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // msg, newRecords gibi veriler
    } else {
      throw Exception(json.decode(response.body)['error'] ?? 'Unknown error');
    }
  }

  String deviceName = "";
  Future<DeviceData> fetchedDeviceData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.get(
      Uri.parse('$uri/api/device/data'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'accessToken': userProvider.user.token,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      deviceName = jsonResponse['deviceName'] as String;
      return DeviceData.fromJson(jsonResponse);
    } else {
      throw Exception(json.decode(response.body)['error'] ?? 'Unknown error');
    }
  }
  String getDeviceName() => deviceName;

  Future<void> deleteDevice({
    required BuildContext context,
    required Device device,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-device'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'accessToken': userProvider.user.token,
        },
        body: jsonEncode({
          'id': device.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.of(context).pop(true);
          showSnackBar(context, "Device Deleted!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}