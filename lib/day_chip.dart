import 'package:flutter/material.dart';

import 'data.dart';

/// One day in the horizontal row: weekday, icon and max temperature.
///
/// Same shape as LocationCard from class 5: final fields, const constructor
/// with named parameters, and a build method.
class DayChip extends StatelessWidget {
  const DayChip({super.key, required this.forecast});

  final DayForecast forecast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 72,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(forecast.weekday, style: textTheme.labelLarge),
            const SizedBox(height: 4),
            Icon(forecast.type.icon, size: 24),
            const SizedBox(height: 4),
            Text('${forecast.tMax.round()}°', style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
