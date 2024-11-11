class Weather {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final double temperature;
  final int humidity;
  final int clouds;
  final double windSpeed;
  final String windDirection;
  final String icon;
  final int code;
  final String description;

  Weather({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.humidity,
    required this.clouds,
    required this.windSpeed,
    required this.windDirection,
    required this.icon,
    required this.code,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      name: json['location']['name'] as String,
      country: json['location']['country'] as String,
      latitude: (json['location']['lat'] as num).toDouble(),
      longitude: (json['location']['lon'] as num).toDouble(),
      temperature: (json['current']['temp_c'] as num).toDouble(),
      humidity: json['current']['humidity'] as int,
      clouds: json['current']['cloud']
          as int, // Note: JSON has "cloud", not "clouds"
      windSpeed: (json['current']['wind_kph'] as num).toDouble(),
      windDirection: json['current']['wind_dir'] as String,
      icon: json['current']['condition']['icon'] as String,
      code: json['current']['condition']['code'] as int,
      description: json['current']['condition']['text'] as String,
    );
  }
}

//  condition icon, code, text 