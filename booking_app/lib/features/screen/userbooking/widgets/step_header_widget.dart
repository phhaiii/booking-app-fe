import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';

class StepHeaderWidget extends StatelessWidget {
  final String step;
  final String title;

  const StepHeaderWidget({
    super.key,
    required this.step,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: WColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
      ],
    );
  }
}
