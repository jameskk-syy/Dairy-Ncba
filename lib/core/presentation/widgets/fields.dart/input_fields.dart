import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../../config/theme/colors.dart';

Widget textField(String label, TextInputType inputType, IconData icon,
    TextEditingController controller, String errorText) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: RequiredValidator(errorText: errorText).call,
      decoration: InputDecoration(
          filled: true,
          label: Text(label),
          labelStyle: const TextStyle(color: AppColors.primaryText, fontSize: 16),
          // prefixIcon: Icon(
          //   icon,
          //   color: AppColors.teal,
          // ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
              borderSide: BorderSide(color: AppColors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
              borderSide: BorderSide(color: AppColors.appgreen))),
    ),
  );
}

Widget passField(String label, bool obscure, Function()? pressed,
    TextEditingController controller, Widget widget) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: RequiredValidator(errorText: "password is required").call,
      decoration: InputDecoration(
          filled: true,
          label: Text(
            label,
            style: const TextStyle(color: AppColors.primaryText),
          ),
          labelStyle: const TextStyle(color: AppColors.primaryText),
          // prefixIcon: const Icon(
          //   Icons.password,
          //   color: AppColors.teal,
          // ),
          suffixIcon: TextButton(onPressed: pressed, child: widget),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
              borderSide: BorderSide(color: AppColors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
              borderSide: BorderSide(color: AppColors.appgreen))),
    ),
  );
}

Widget emailField(
  TextEditingController cont,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: cont,
      keyboardType: TextInputType.text,
      validator: MultiValidator([
        RequiredValidator(errorText: "Username is required"),
        // EmailValidator(errorText: "Enter a correct email")
      ]).call,
      decoration: const InputDecoration(
        filled: true,
        label: Text("Enter your username"),
        labelStyle: TextStyle(color: AppColors.primaryText, fontSize: 16),
        // prefixIcon: Icon(
        //   Icons.email_outlined,
        //   color: AppColors.teal,
        // ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
            borderSide: BorderSide(color: AppColors.grey)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(9.0)),
          borderSide: BorderSide(color: AppColors.appgreen),
        ),
      ),
    ),
  );
}

