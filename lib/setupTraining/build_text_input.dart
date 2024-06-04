import 'package:flutter/material.dart';

class BuildTextInput extends StatelessWidget {
  const BuildTextInput({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
  });

  final TextEditingController controller;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
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
