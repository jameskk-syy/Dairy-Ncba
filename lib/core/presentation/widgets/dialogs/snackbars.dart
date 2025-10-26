import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../config/theme/colors.dart';

showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: snackbarContent(context, message),
    behavior: SnackBarBehavior.floating,
    elevation: 2.0,
    width: MediaQuery.of(context).size.width / 1.1,
    backgroundColor: AppColors.teal.shade400,
    duration: const Duration(seconds: 3),
    showCloseIcon: true,
    closeIconColor: AppColors.primaryText,
  ));
}

Widget snackbarContent(BuildContext context, String message) {
  return Row(
    children: [
      Text(
        message,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: AppColors.primaryText),
      ),
    ],
  );
}

showWarningDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    borderSide: const BorderSide(
      color: AppColors.teal,
      width: 2,
    ),
    width: 280,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    title: 'Warning',
    desc: 'Ordered quantity is higher than stock',
    showCloseIcon: true,
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      Navigator.pop(context);
    },
  ).show();
}

showWarningAlert(BuildContext context, String title, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
    title: title,
    text: message,
  );
}
