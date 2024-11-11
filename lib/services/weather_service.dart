import 'dart:convert';
import 'package:location/location.dart';
import 'package:weather/constants/constant.dart';
import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Weather> getWeatherByCityName(String city) async {
    final url = Uri.parse(
        '${Constant.BASE_URL}?${Constant.key}&q=$city${Constant.aqi}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to get weather data");
    }
  }

  Future<Weather> getWeatherByLocation() async {
    Location location = Location();
    bool serviceEnabled = false;
    PermissionStatus permissionGranted = PermissionStatus.denied;
    LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    // Check location permission
    permissionGranted = await location.hasPermission();
    print("in the weather service...");
    if (permissionGranted == PermissionStatus.denied) {
      print("permission denied");
      permissionGranted = await location.requestPermission();
    }
    print("permission not denied");

    // Get current location
    locationData = await location.getLocation();
    print(locationData.latitude);

    final myLocation = '${locationData.latitude},${locationData.longitude}';

    final url = Uri.parse(
        '${Constant.BASE_URL}?${Constant.key}&q=$myLocation${Constant.aqi}');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to get weather data");
    }
  }
}
