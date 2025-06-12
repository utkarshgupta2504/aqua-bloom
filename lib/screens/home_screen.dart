import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hydration_provider.dart';
import '../widgets/water_button.dart';
import '../widgets/water_progress.dart';
import '../widgets/water_adjustment_dialog.dart';
import '../constants/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AquaBloom'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Consumer<HydrationProvider>(
        builder: (context, hydration, child) {
          final progress = hydration.progress;
          final progressPercentage = '${(progress * 100).toInt()}%';
          final currentIntake = '${hydration.formattedCurrentIntake}ml';
          final targetIntake = '${hydration.formattedTargetIntake}ml';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                WaterProgress(
                  progress: progress,
                  currentIntake: currentIntake,
                  targetIntake: targetIntake,
                  progressPercentage: progressPercentage,
                ),
                const SizedBox(height: 32),
                if (hydration.lastIntake != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      onPressed: () => hydration.undoLastIntake(),
                      icon: const Icon(Icons.undo),
                      label: Text('Undo ${hydration.lastIntake!.toInt()}ml'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightBlue,
                        foregroundColor: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                _buildQuickAddButtons(context, hydration),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => WaterAdjustmentDialog(
              onAdjust: (amount) {
                if (amount > 0) {
                  context.read<HydrationProvider>().logWater(amount);
                }
              },
            ),
          );
        },
        icon: const Icon(Icons.water_drop),
        label: const Text('Add Water'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  Widget _buildQuickAddButtons(
    BuildContext context,
    HydrationProvider hydration,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quick Add',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: WaterButton(
                amount: 150,
                label: 'Small',
                onPressed: () => hydration.logWater(150),
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: WaterButton(
                amount: 250,
                label: 'Medium',
                onPressed: () => hydration.logWater(250),
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: WaterButton(
                amount: 500,
                label: 'Large',
                onPressed: () => hydration.logWater(500),
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
