import 'package:boxing_app/training.dart';
import 'package:flutter/material.dart';

class SetupTraining extends StatefulWidget {
  const SetupTraining({super.key});

  @override
  State<SetupTraining> createState() => _SetupTrainingState();
}

class _SetupTrainingState extends State<SetupTraining> {
  final TextEditingController roundLengthController = TextEditingController();
  final TextEditingController breakLengthController = TextEditingController();
  final TextEditingController roundAmountController = TextEditingController();

  // late List<Color> currentColors;
  // //break colors
  // final List<Color> breakColors = [
  //   Color(0xFF2F4F4F),
  //   const Color.fromRGBO(192, 174, 74, 1),
  //   const Color.fromRGBO(0, 0, 0, 1),
  // ];

  @override
  Widget build(BuildContext context) {
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
            builder: (context) =>
                Training(roundLength, breakLength, roundAmount),
          ));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          const Color.fromRGBO(68, 138, 255, 1),
          Color.fromRGBO(0, 0, 0, 1)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Configure your workout:",
                // style: Theme.of(context).textTheme.titleLarge,
                style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              buildTextField(
                controller: roundLengthController,
                icon: Icons.timer,
                label: "Round length (min)",
              ),
              const SizedBox(
                height: 10,
              ),
              buildTextField(
                  controller: breakLengthController,
                  icon: Icons.pause_circle_filled,
                  label: "Break length (min)"),
              const SizedBox(
                height: 10,
              ),
              buildTextField(
                  controller: roundAmountController,
                  icon: Icons.repeat,
                  label: "Amount of rounds"),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  backgroundColor: const Color(0xFF00BCD4),
                ),
                onPressed: setupWorkOutButton,
                child: const Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.cyanAccent, width: 1), // Underline thickness
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 24, color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.cyanAccent),
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 23,
              fontWeight: FontWeight.bold),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
