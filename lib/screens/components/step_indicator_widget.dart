import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  Widget _buildStepCircle(int step) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: step <= currentStep ? Colors.green : Colors.grey,
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
      color: currentStep >= 1 ? AppColors.lavenderHaze : Colors.grey,
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
