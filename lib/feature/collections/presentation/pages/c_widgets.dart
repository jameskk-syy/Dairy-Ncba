import 'package:flutter/material.dart';

Widget milkPropertiesWidget(String title, String label) {
  return Row(
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.green,
        ),
      ),
      const Spacer(),
      Text(
        label,
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
        ),
      ),
    ],
  );
}
