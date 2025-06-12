import 'package:flutter/material.dart';
import '../constants/theme.dart';

class WaterProgress extends StatelessWidget {
  final double progress;
  final String currentIntake;
  final String targetIntake;
  final String progressPercentage;

  const WaterProgress({
    super.key,
    required this.progress,
    required this.currentIntake,
    required this.targetIntake,
    required this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 20,
                  backgroundColor: AppTheme.lightBlue,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBlue,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    progressPercentage,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'of daily goal',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '$currentIntake / $targetIntake',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
