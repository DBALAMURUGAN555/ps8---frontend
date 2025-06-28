// models/dashboard_data.dart
class DashboardData {
  final String city;
  final List<double> coordinates;
  final String date;
  final double temperature;
  final String weatherDescription;
  final int aqi;
  final String aqiStatus;
  final double pm25;
  final double pm10;
  final double no2;
  final double co;
  final double o3;

  DashboardData({
    required this.city,
    required this.coordinates,
    required this.date,
    required this.temperature,
    required this.weatherDescription,
    required this.aqi,
    required this.aqiStatus,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.co,
    required this.o3,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final weather = json['weather'];
    final pollution = json['pollution'];

    return DashboardData(
      city: location['city'],
      coordinates: List<double>.from(location['coordinates']),
      date: json['date'],
      temperature: weather['temp'].toDouble(),
      weatherDescription: weather['description'],
      aqi: pollution['aqi'],
      aqiStatus: pollution['aqi_status'],
      pm25: pollution['pm25'].toDouble(),
      pm10: pollution['pm10'].toDouble(),
      no2: pollution['no2'].toDouble(),
      co: pollution['co'].toDouble(),
      o3: pollution['o3'].toDouble(),
    );
  }
}
