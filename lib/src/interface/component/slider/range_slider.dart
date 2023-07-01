import 'package:flutter/material.dart';

class TimeRangeSliderDur30min extends StatelessWidget {
  final double start;
  final double end;
  final tapFunc;
  const TimeRangeSliderDur30min(
      {required this.start, required this.end, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: RangeValues(start, end),
      divisions: 48,
      min: 0,
      max: 24,
      onChanged: tapFunc,
    );
  }
}
