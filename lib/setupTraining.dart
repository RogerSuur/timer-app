import 'package:boxing_timer_app/training.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please enter valid numbers for all fields.')));
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
      backgroundColor: Color(0xFF2F4F4F),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Configure your workout:",
              // style: Theme.of(context).textTheme.titleLarge,
              style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildTextField(
              controller: roundLengthController,
              icon: Icons.timer,
              label: "Round length (minutes)",
            ),
            // TextField(
            //   controller: roundLenghtController,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       prefixIcon: Icon(Icons.timer),
            //       labelText: 'Round length'),
            // ),
            SizedBox(
              height: 10,
            ),
            // TextField(
            //   controller: breakLengthController,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       prefixIcon: Icon(Icons.pause_circle_filled),
            //       labelText: "Break length"),
            // ),
            buildTextField(
                controller: breakLengthController,
                icon: Icons.pause_circle_filled,
                label: "Break length (minutes)"),
            SizedBox(
              height: 10,
            ),
            // TextField(
            //   controller: roundAmountController,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       prefixIcon: Icon(Icons.repeat),
            //       labelText: "Amount of rounds"),
            // ),
            buildTextField(
                controller: roundAmountController,
                icon: Icons.repeat,
                label: "Amount of rounds"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Icon(
                Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: setupWorkOutButton,
            ),
          ],
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
      width: 220,
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.cyanAccent, width: 2), // Underline thickness
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 18, color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.cyanAccent),
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
