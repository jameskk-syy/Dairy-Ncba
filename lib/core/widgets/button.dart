import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';

Widget btn(Widget widget, Function()? pressed) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.lightColorScheme.primary,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: AppColors.lightColorScheme.primary.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: TextButton(
      onPressed: pressed,
      child: widget
    ),
  );
}
