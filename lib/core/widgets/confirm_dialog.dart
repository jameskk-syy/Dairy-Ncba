import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';

void returnDialog(BuildContext context, String farmerName, String date,
    String farmerNo, double quantity, String session, void Function()? submit) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    animType: AnimType.scale,
    title: 'Delivery Return',
    body: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Are you sure you want to return this delivery?',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Farmer: $farmerName',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            'Farmer No: $farmerNo',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            'Delivery Date: $date',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            'Quantity: $quantity',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            'Session: $session',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
    btnOk: MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        submit!();
      },
      color: AppColors.lightColorScheme.primary,
      child: Text(
        'Submit',
        style: TextStyle(color: AppColors.lightColorScheme.onPrimary),
      ),
    ),
    btnCancel: MaterialButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: AppColors.lightColorScheme.error,
      child: Text(
        'Cancel',
        style: TextStyle(color: AppColors.lightColorScheme.onError),
      ),
    ),
  ).show();
}

 confirmDialog(BuildContext context, String title, String description,Widget widget, void Function()? submit) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    animType: AnimType.scale,
    title: title,
    body: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            description,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          widget
        ],
      ),
    ),
    btnOk: MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        submit!();
      },
      color: AppColors.lightColorScheme.primary,
      child: Text(
        'Submit',
        style: TextStyle(color: AppColors.lightColorScheme.onPrimary),
      ),
    ),
    btnCancel: MaterialButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: AppColors.lightColorScheme.error,
      child: Text(
        'Cancel',
        style: TextStyle(color: AppColors.lightColorScheme.onError),
      ),
    ),
  ).show();
}
