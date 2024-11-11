import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/views/widgets/animation_builder.dart';
import 'package:weather/views/widgets/info_builder.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  final _controller = TextEditingController();

  //  Function for getting weather via current location
  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getWeatherByLocation();
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not fetch weather. Please try again.';
        _weather = null;
      });
      print(e); // For debugging purposes
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    _controller.clear();
  }

  // Function for getting weather data
  Future<void> _getWeather(String city) async {
    if (city.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCityName(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not fetch weather. Please try again.';
        _weather = null;
      });
      print(e); // For debugging purposes
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    _controller.clear();
  }

  @override
  void initState() {
    _getCurrentLocationWeather();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when no longer needed to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Setting up background-image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/weather-bg.jpg'), // Path to your image
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black
                    .withOpacity(0.4), // Add a slight color overlay if needed
              ),
            ),
          ),
          // Weather info widgets
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 70.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Input Section
                  _isLoading
                      ? Container()
                      : Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter a location',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0.r),
                                  ),
                                ),
                                controller: _controller,
                                onSubmitted: _getWeather,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            InkWell(
                              onTap: () => _getWeather(_controller.text.trim()),
                              child: Container(
                                padding: EdgeInsets.all(12.0.r),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8.0.r),
                                ),
                                child:
                                    const Icon(Icons.send, color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                  SizedBox(height: 20.h),

                  // Loading Indicator
                  if (_isLoading) ...[
                    Lottie.asset('assets/loading-plane.json',
                        width: 350, height: 350),
                    // SizedBox(height: 20.h),
                  ],

                  // Error Message
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                  ],

                  // Weather Information
                  if (_weather != null && !_isLoading) ...[
                    // Weather Icon
                    Image.network(
                      'https:${_weather!.icon}',
                      width: 100.w,
                      height: 100.h,
                    ),
                    SizedBox(height: 10.h),

                    // City and Country
                    Text(
                      '${_weather!.name}, ${_weather!.country}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Temperature
                    Text(
                      '${_weather!.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Description
                    Text(
                      _weather!.description,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Additional Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BuildInfoColumn(
                            label: 'Humidity', value: '${_weather!.humidity}%'),
                        BuildInfoColumn(
                            label: 'Wind',
                            value:
                                '${_weather!.windSpeed} kph ${_weather!.windDirection}'),
                        BuildInfoColumn(
                            label: 'Clouds', value: '${_weather!.clouds}%'),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // Lottie Animation Based on Weather Condition
                    LottieAnimationBuilder(weatherCode: _weather!.code),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
