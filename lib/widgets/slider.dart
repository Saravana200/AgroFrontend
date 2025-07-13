import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SliderBar extends StatefulWidget {
  const SliderBar({
    Key? key,
    required this.theme,
    required this.value, // If value is meant to change, consider moving it to the state class
    this.minValue = 57,
    this.maxValue = 64,
    this.currentValue = 59,
    this.description = '',
    this.icon = Icons.thermostat,
  }) : super(key: key);

  final ThemeData theme;
  final double value; // Assuming it should be a double
  final String description;
  final double minValue, maxValue, currentValue;
  final IconData icon;

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.currentValue; // Initialize currentValue with widget's currentValue
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return SleekCircularSlider(
      innerWidget: (percentage) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            Text(
              widget.value.toStringAsFixed(1), // Convert double value to string
              style: theme.textTheme.titleMedium,
            )
          ],
        );
      },
      appearance: CircularSliderAppearance(
        customWidths: CustomSliderWidths(progressBarWidth: 10, trackWidth: 10),
        customColors: CustomSliderColors(
          trackColor: theme.primaryColor,
          progressBarColor: theme.colorScheme.primaryContainer,
        ),
        size: 98,
      ),
      min: widget.minValue,
      max: widget.maxValue,
      initialValue: currentValue,
      onChange: (newValue) {
        setState(() {
          currentValue = newValue;
        });
      },
    );
  }
}
