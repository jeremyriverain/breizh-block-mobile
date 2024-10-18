import 'package:flutter/material.dart';

class BoulderListBuilderFilterRealisation extends StatefulWidget {
  const BoulderListBuilderFilterRealisation({
    required this.label,
    super.key,
  });

  final String label;

  @override
  State<BoulderListBuilderFilterRealisation> createState() =>
      _BoulderListBuilderFilterRealisationState();
}

class _BoulderListBuilderFilterRealisationState
    extends State<BoulderListBuilderFilterRealisation> {
  bool checked = true;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: checked,
      onChanged: (bool? value) {
        setState(() {
          checked = value!;
        });
      },
      title: Text(widget.label),
    );
  }
}
