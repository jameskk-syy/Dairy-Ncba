import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  LargeText(
      {super.key,
      required this.text,
       this.size,
        this.fontWeight});
  double? size = 30;
  String text;
  FontWeight? fontWeight = FontWeight.bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}

Widget richText(String text1, String text2, Function()? next) {
  return RichText(
    text: TextSpan(children: [
      TextSpan(text: text1, style: const TextStyle(color: Colors.black)),
      TextSpan(
        text: text2,
        // style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w300),
        recognizer: TapGestureRecognizer()..onTap = next,
      )
    ]),
  );
}
