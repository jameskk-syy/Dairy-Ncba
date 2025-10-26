import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../config/theme/colors.dart';

Widget spinKit() {
  return const Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: SpinKitThreeBounce(
          color: AppColors.primaryText,
          size: 27,
          duration: Duration(milliseconds: 1200),
        ),
      )
    ],
  );
}