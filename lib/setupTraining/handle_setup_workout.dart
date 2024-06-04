import 'package:boxing_app/training/training.dart';
import 'package:flutter/material.dart';

class HandleSetupWorkout extends StatelessWidget {
  final BuildContext context;
  final TextEditingController roundLengthController;
  final TextEditingController breakLengthController;
  final TextEditingController roundAmountController;

  const HandleSetupWorkout({
    super.key,
    required this.context,
    required this.roundLengthController,
    required this.breakLengthController,
    required this.roundAmountController,
  });

  void setupWorkOutButton() {
    int? roundLength = int.tryParse(roundLengthController.text);
    int? breakLength = int.tryParse(breakLengthController.text);
    int? roundAmount = int.tryParse(roundAmountController.text);
    // Check if any of the conversions failed (i.e., if any are null)
    if (roundLength == null ||
        breakLength == null ||
        roundAmount == null ||
        roundLength == 0 ||
        breakLength == 0 ||
        roundAmount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please enter valid numbers for all fields.',
          style: TextStyle(fontSize: 20),
        ),
      ));
      return; // Early exit if validation fails
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Training(roundLength, breakLength, roundAmount),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        backgroundColor: const Color(0xFF00BCD4),
      ),
      onPressed: setupWorkOutButton,
      child: const Icon(
        Icons.play_arrow,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
