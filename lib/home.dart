import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class TrainingSettings {
  final int roundLength;
  final int breakLength;
  final int numberOfRounds;

  TrainingSettings(this.roundLength, this.breakLength, this.numberOfRounds);
}

class _HomeScreenState extends State<HomeScreen> {
  int _roundLength = 3;
  int _breakLength = 1;
  TextEditingController _roundsController = TextEditingController();

  @override
  void dispose() {
    _roundsController
        .dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<int>(
              value: _roundLength,
              onChanged: (int? newValue) {
                setState(() {
                  _roundLength = newValue!;
                });
              },
              items: <int>[3, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value minutes'),
                );
              }).toList(),
            ),
            DropdownButton<int>(
              value: _breakLength,
              onChanged: (int? newValue) {
                setState(() {
                  _breakLength = newValue!;
                });
              },
              items: <int>[1, 2, 3, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value minutes'),
                );
              }).toList(),
            ),
            TextField(
              controller: _roundsController,
              decoration: InputDecoration(
                labelText: 'Number of Rounds',
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final settings = TrainingSettings(
                  _roundLength,
                  _breakLength,
                  int.tryParse(_roundsController.text) ??
                      1, // Parse rounds or default to 1
                );

                // Navigate to the training screen with the settings as arguments
                Navigator.pushNamed(
                  context,
                  '/training',
                  arguments: settings,
                );
              },
              child: Text('Start Workout'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                child: Text('Settings'))
          ],
        ),
      ),
    );
  }
}
