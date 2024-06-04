import 'package:boxing_app/setupTraining/build_text_input.dart';
import 'package:boxing_app/setupTraining/handle_setup_workout.dart';
import 'package:flutter/material.dart';

class SetupTraining extends StatefulWidget {
  const SetupTraining({super.key});

  @override
  State<SetupTraining> createState() => _SetupTrainingState();
}

class _SetupTrainingState extends State<SetupTraining> {
  late final TextEditingController roundLengthController;
  late final TextEditingController breakLengthController;
  late final TextEditingController roundAmountController;

  // late List<Color> currentColors;
  // //break colors
  // final List<Color> breakColors = [
  //   Color(0xFF2F4F4F),
  //   const Color.fromRGBO(192, 174, 74, 1),
  //   const Color.fromRGBO(0, 0, 0, 1),
  // ];
  @override
  void initState() {
    super.initState();
    roundLengthController = TextEditingController();
    breakLengthController = TextEditingController();
    roundAmountController = TextEditingController();
  }

  @override
  void dispose() {
    roundLengthController.dispose();
    breakLengthController.dispose();
    roundAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(68, 138, 255, 1),
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
              BuildTextInput(
                  controller: roundLengthController,
                  icon: Icons.timer,
                  label: "Round length (min)"),
              const SizedBox(
                height: 10,
              ),
              BuildTextInput(
                  controller: breakLengthController,
                  icon: Icons.pause_circle_filled,
                  label: "Break length (min)"),
              const SizedBox(
                height: 10,
              ),
              BuildTextInput(
                  controller: roundAmountController,
                  icon: Icons.repeat,
                  label: "Amount of rounds"),
              const SizedBox(
                height: 20,
              ),
              HandleSetupWorkout(
                context: context,
                roundLengthController: roundLengthController,
                breakLengthController: breakLengthController,
                roundAmountController: roundAmountController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
