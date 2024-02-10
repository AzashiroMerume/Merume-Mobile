import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';

class StepIndicator extends StatelessWidget {
  final int coloredStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.coloredStep,
    required this.totalSteps,
  });

  Widget _buildStepCircle(int step) {
    bool isColored = step <= coloredStep - 1;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isColored ? AppColors.royalPurple : Colors.grey,
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      height: 2,
      width: 50,
      color: coloredStep >= 1 ? AppColors.lavenderHaze : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(totalSteps * 2 - 1, (index) {
          if (index.isOdd) {
            // Add step line
            return _buildStepLine();
          } else {
            // Add step circle
            final stepIndex = index ~/ 2;
            return _buildStepCircle(stepIndex);
          }
        }),
      ),
    );
  }
}
