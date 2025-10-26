import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';

Widget button(BuildContext context, Color color, Widget child, double width,
    Function()? onPressed, double padding) {
  return Padding(
    padding: EdgeInsets.only(top: padding),
    child: SizedBox(
      height: 50,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: AppColors.teal,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: AppColors.teal))),
        child: child,
      ),
    ),
  );
}

Widget textButton(BuildContext context, TextEditingController resetPasswordController,text, Function()? pressed) {
  return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Forgot Password',style: TextStyle(
                  color: Colors.orange
                ),),
                content: TextFormField(
                  controller: resetPasswordController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 18.0,
                    ),
                    hintText: 'Email Address',
                    hintStyle: TextStyle(fontSize: 14.0),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Send code'),
                  ),
                ],
              );
            });
      },
      child: Text(text, style: const TextStyle(color: Colors.orange)));
}
