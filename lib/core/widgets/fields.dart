import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../config/theme/colors.dart';


Widget textField(String label, TextInputType inputType, IconData icon,
    TextEditingController controller, String errorText) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: RequiredValidator(errorText: errorText).call,
      decoration: InputDecoration(
        filled: false,
        fillColor: AppColors.grey,
          label: Text(label),
          labelStyle: const TextStyle(color: AppColors.teal, fontSize: 16),
          prefixIcon: Icon(
            icon,
            color: AppColors.teal,
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.teal)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.teal)),
          errorStyle: const TextStyle(color: Colors.red),
          errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
              ),
    ),
  );
}

Widget searchField(TextEditingController controller, Function(String)? onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      validator: RequiredValidator(errorText: "").call,
      onChanged: onChanged,
      decoration: const InputDecoration(
        filled: false,
        fillColor: AppColors.grey,
          label: Text("Search Farmer"),
          labelStyle: TextStyle(color: AppColors.teal, fontSize: 16),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.teal)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.teal)),
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
              ),
    ),
  );
}

Widget txtField(String label, TextInputType inputType, IconData icon,
    TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      minLines: 2,
      maxLines: 3,
      decoration: InputDecoration(
        filled: false,
        fillColor: AppColors.grey,
          label: Text(label),
          labelStyle: const TextStyle(color: AppColors.teal, fontSize: 16),
          prefixIcon: Icon(
            icon,
            color: AppColors.teal,
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.teal)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.teal)),
          errorStyle: const TextStyle(color: Colors.red),
          errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
              ),
    ),
  );
}

Widget dropdown(List<DropDownValueModel> list,
    SingleValueDropDownController controller, String message, String hint, Function(dynamic)? onChanged, [Function()? onTap]) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: GestureDetector(
      onTap: onTap,
      child: DropDownTextField(
        dropDownList: list,
        controller: controller,
        listSpace: 22,
        listTextStyle: const TextStyle(fontSize: 18),
        listPadding: ListPadding(top: 12),
        enableSearch: true,
        textFieldDecoration: InputDecoration(
          // filled: true,
          // fillColor: AppColors.grey,
            label: Text(hint),
            labelStyle: const TextStyle(fontSize: 16),
            border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.teal)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.teal)),
            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.teal)),
            errorStyle: const TextStyle(color: Colors.red
            ),
      ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return message;
          } else {
            return null;
          }
        },
        onChanged: onChanged,
    ),
    ),
  );
}