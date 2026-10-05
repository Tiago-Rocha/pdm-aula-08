import 'package:flutter/material.dart';

import 'data.dart';

/// One island in the grid: photo on top, name below.
///
/// Extracted from IslandsGrid: the same Card, now with a name and a file of
/// its own, so it can be reused anywhere.
class IslandCard extends StatelessWidget {
  const IslandCard({super.key, required this.island});

  final Island island;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Image.asset(island.image, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(island.name, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
