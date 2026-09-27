import 'package:flutter/material.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';

/// A labelled, single-select row of chips.
///
/// [options] maps each value to its chip label, in display order.
class ThaheenChoiceChips<T> extends StatelessWidget {
  const ThaheenChoiceChips({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label),
        ThaheenSpacing.gapVerticalSmall,
        Wrap(
          spacing: ThaheenSpacing.small,
          children: [
            for (final MapEntry(key: value, value: text) in options.entries)
              ChoiceChip(
                label: Text(text),
                selected: value == selected,
                onSelected: (_) => onSelected(value),
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
          ],
        ),
      ],
    );
  }
}
