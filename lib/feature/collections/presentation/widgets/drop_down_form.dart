
import 'package:flutter/material.dart';

class DropdownFieldWithUnderline extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String?> onChanged;
  final String label;
  final IconData? icon;

  const DropdownFieldWithUnderline({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    required this.label,
     this.icon
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedOption,
      onChanged: onChanged,
      decoration:  const InputDecoration(
        enabledBorder: UnderlineInputBorder(
        ),
        focusedBorder: UnderlineInputBorder(
        ),
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(option)
            ],
          )
        );
      }).toList(),
    );
  }
}
