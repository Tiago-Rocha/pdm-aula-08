import 'package:flutter/material.dart';

import 'alerts_form.dart';
import 'data.dart';
import 'day_chip.dart';
import 'island_card.dart';

/// Forecast screen for one location.
///
/// Step 2: the unit (°C or °F) is state of this screen, because it is the
/// closest common ancestor of the widgets that show temperatures.
class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  bool _fahrenheit = false; // the state lives in the State, not in the widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempo Açores'),
        actions: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('°C')),
              ButtonSegment(value: true, label: Text('°F')),
            ],
            selected: {_fahrenheit},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _fahrenheit = s.first),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          const IslandHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            // passed down by parameter: CurrentConditions does not keep it
            child: CurrentConditions(fahrenheit: _fahrenheit),
          ),
          const DaysRow(),
          const Padding(padding: EdgeInsets.all(16), child: DetailCard()),
          const IslandsGrid(),
          const Padding(padding: EdgeInsets.all(16), child: AlertsForm()),
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
  const CurrentConditions({super.key, required this.fahrenheit});

  final bool fahrenheit; // chosen in ForecastScreen, received here

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final today = forecasts.first;
    // °F = °C × 9 / 5 + 32
    String temp(double c) =>
        fahrenheit ? '${(c * 9 / 5 + 32).round()} °F' : '${c.round()} °C';
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

/// The nine islands in a grid, with a search box on top.
///
/// Step 3: the search text is state of this widget; the grid shows only the
/// islands whose name contains it.
class IslandsGrid extends StatefulWidget {
  const IslandsGrid({super.key});

  @override
  State<IslandsGrid> createState() => _IslandsGridState();
}

class _IslandsGridState extends State<IslandsGrid> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState(); // once, before the first build
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _search.dispose(); // what initState creates, dispose frees
    super.dispose();
  }

  // Calculated from the state on every build, never stored as state.
  List<Island> get _filtered => islands
      .where((i) => i.name.toLowerCase().contains(_search.text.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Pesquisar ilha',
              border: const OutlineInputBorder(),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(_search.clear),
                    ),
            ),
            onChanged: (_) => setState(() {}), // the text is in _search
          ),
        ),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text('Nenhuma ilha encontrada'),
          ),
        GridView.extent(
          maxCrossAxisExtent: 160, // as many columns as fit, each up to 160 dp
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          shrinkWrap: true, // only the height it needs, inside the ListView
          physics: const NeverScrollableScrollPhysics(), // the ListView scrolls
          children: [for (final i in filtered) IslandCard(island: i)],
        ),
      ],
    );
  }
}
