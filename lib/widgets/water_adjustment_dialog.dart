import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';

class WaterAdjustmentDialog extends StatefulWidget {
  final Function(double) onAdjust;

  const WaterAdjustmentDialog({super.key, required this.onAdjust});

  @override
  State<WaterAdjustmentDialog> createState() => _WaterAdjustmentDialogState();
}

class _WaterAdjustmentDialogState extends State<WaterAdjustmentDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdjust() {
    final value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() => _error = 'Please enter a valid number');
      return;
    }
    widget.onAdjust(value);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adjust Water Intake'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter amount in ml (use negative values to reduce)',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: 'Amount (ml)',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAdjust,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Adjust'),
        ),
      ],
    );
  }
}
