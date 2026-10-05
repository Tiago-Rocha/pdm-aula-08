// Static data for this class. Real data comes from the course API later on.
// This file is not part of the exercises: read it, do not change it.
import 'package:flutter/material.dart';

/// Weather condition with the Material icon and the Portuguese label.
enum WeatherType {
  sunny('Sol', Icons.wb_sunny),
  partlyCloudy('Parcialmente nublado', Icons.cloud_queue),
  cloudy('Nublado', Icons.cloud),
  rain('Chuva', Icons.umbrella),
  storm('Trovoada', Icons.thunderstorm);

  const WeatherType(this.description, this.icon);

  final String description;
  final IconData icon;
}

/// Forecast for one day.
class DayForecast {
  const DayForecast({
    required this.date,
    required this.type,
    required this.tMin,
    required this.tMax,
    required this.rainChance,
    required this.windKmh,
  });

  final DateTime date;
  final WeatherType type;
  final double tMin;
  final double tMax;
  final int rainChance; // 0 to 100
  final double windKmh;

  static const _weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  /// Short weekday label in Portuguese: 'Seg', 'Ter', ...
  String get weekday => _weekdays[date.weekday - 1];
}

/// One of the nine islands, with the photo in assets/img/.
class Island {
  const Island(this.name, this.image);

  final String name;
  final String image;
}

const islands = [
  Island('São Miguel', 'assets/img/sao_miguel.jpg'),
  Island('Santa Maria', 'assets/img/santa_maria.jpg'),
  Island('Terceira', 'assets/img/terceira.jpg'),
  Island('Graciosa', 'assets/img/graciosa.jpg'),
  Island('São Jorge', 'assets/img/sao_jorge.jpg'),
  Island('Pico', 'assets/img/pico.jpg'),
  Island('Faial', 'assets/img/faial.jpg'),
  Island('Flores', 'assets/img/flores.jpg'),
  Island('Corvo', 'assets/img/corvo.jpg'),
];

const location = 'Ponta Delgada';
const currentIsland = Island('São Miguel', 'assets/img/sao_miguel.jpg');

/// Five days starting today.
final List<DayForecast> forecasts = () {
  final today = DateTime.now();
  DateTime day(int i) => DateTime(today.year, today.month, today.day + i);
  return [
    DayForecast(date: day(0), type: WeatherType.partlyCloudy, tMin: 17, tMax: 23, rainChance: 20, windKmh: 18),
    DayForecast(date: day(1), type: WeatherType.rain, tMin: 16, tMax: 21, rainChance: 80, windKmh: 32),
    DayForecast(date: day(2), type: WeatherType.cloudy, tMin: 16, tMax: 22, rainChance: 40, windKmh: 25),
    DayForecast(date: day(3), type: WeatherType.sunny, tMin: 18, tMax: 25, rainChance: 5, windKmh: 12),
    DayForecast(date: day(4), type: WeatherType.storm, tMin: 17, tMax: 21, rainChance: 90, windKmh: 45),
  ];
}();
