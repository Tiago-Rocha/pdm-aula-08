import 'package:flutter/material.dart';

import 'alerts_form.dart';
import 'data.dart';
import 'day_chip.dart';
import 'island_card.dart';

/// Forecast screen for one location.
///
/// TODO 2: turn ForecastScreen into a StatefulWidget with a bool _fahrenheit,
/// put a SegmentedButton °C / °F in the AppBar actions, and pass the unit to
/// CurrentConditions.
class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tempo Açores')),
      body: ListView(
        children: const [
          IslandHeader(),
          Padding(padding: EdgeInsets.all(16), child: CurrentConditions()),
          DaysRow(),
          Padding(padding: EdgeInsets.all(16), child: DetailCard()),
          IslandsGrid(),
          Padding(padding: EdgeInsets.all(16), child: AlertsForm()),
        ],
      ),
    );
  }
}

/// Island photo with a gradient so that text on top of it stays readable.
class IslandHeader extends StatelessWidget {
  const IslandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand, // children without a position fill the box
        children: [
          Image.asset(currentIsland.image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Text(
              currentIsland.name,
              style: textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Chip(label: Text(forecasts.first.type.description)),
          ),
        ],
      ),
    );
  }
}

/// Location name, current temperature and the min / max / rain row.
class CurrentConditions extends StatelessWidget {
  const CurrentConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final today = forecasts.first;
    // TODO 2: with fahrenheit, show °F = °C × 9 / 5 + 32
    String temp(double c) => '${c.round()} °C';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // one at each end
          children: [
            // Expanded: a long name wraps instead of pushing the temperature out
            Expanded(child: Text(location, style: textTheme.headlineSmall)),
            Text(temp(today.tMax), style: textTheme.displaySmall),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _Measure('Mín', temp(today.tMin))),
            Expanded(child: _Measure('Máx', temp(today.tMax))),
            Expanded(child: _Measure('Chuva', '${today.rainChance} %')),
          ],
        ),
      ],
    );
  }
}

/// A label above a value. Private to this file (leading underscore).
class _Measure extends StatelessWidget {
  const _Measure(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(label, style: textTheme.labelMedium),
        Text(value, style: textTheme.titleMedium),
      ],
    );
  }
}

/// Horizontal row with the five days.
class DaysRow extends StatelessWidget {
  const DaysRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: forecasts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => DayChip(forecast: forecasts[i]),
      ),
    );
  }
}

/// Details of the first day, one per line.
///
/// Step 1: tapping the card shows or hides the wind and rain lines.
class DetailCard extends StatefulWidget {
  const DetailCard({super.key});

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final f = forecasts.first;
    Widget line(IconData icon, String label, String value) => Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: textTheme.bodyMedium)),
            Text(value, style: textTheme.titleMedium),
          ],
        );
    return Card(
      clipBehavior: Clip.antiAlias, // keeps the ripple inside the corners
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              line(Icons.thermostat, 'Mínima', '${f.tMin.round()} °C'),
              const SizedBox(height: 8),
              line(Icons.thermostat, 'Máxima', '${f.tMax.round()} °C'),
              if (_expanded) ...[
                const SizedBox(height: 8),
                line(Icons.air, 'Vento', '${f.windKmh.round()} km/h'),
                const SizedBox(height: 8),
                line(Icons.water_drop, 'Chuva', '${f.rainChance} %'),
              ],
              Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}

/// The nine islands in a grid.
///
/// TODO 3: turn IslandsGrid into a StatefulWidget with a search box on top
/// (a TextField with a TextEditingController, created in initState and freed
/// in dispose). The grid shows only the islands whose name contains the text;
/// a clear button appears when there is text; with no results, the text
/// 'Nenhuma ilha encontrada'.
class IslandsGrid extends StatelessWidget {
  const IslandsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 160, // as many columns as fit, each up to 160 dp
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true, // only the height it needs, inside the ListView
      physics: const NeverScrollableScrollPhysics(), // the ListView scrolls
      children: [for (final i in islands) IslandCard(island: i)],
    );
  }
}
