import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget spinkit() {
  return const Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SpinKitThreeBounce(
              color: Colors.black,
              size: 27.0,
              duration: Duration(milliseconds: 1200),
              ),
            ),
        ],
  );
}
