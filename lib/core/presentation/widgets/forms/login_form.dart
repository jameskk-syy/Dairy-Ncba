import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../button/button.dart';
import '../fields.dart/input_fields.dart';

Widget loginForm(
  BuildContext context,
  GlobalKey formKey,
  TextEditingController emailCont,
  TextEditingController passCont,
  TextEditingController resetPasswordController,
  bool obscure,
  Function()? toggleFunc,
  Widget passWidget,
  Widget btnWidget,
  Function()? submitFunc,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          emailField(emailCont),
          passField('Enter Your Password', obscure, toggleFunc, passCont, passWidget),
           SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Center(
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.1,
                child: ElevatedButton(
                  onPressed: submitFunc,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appgreen,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    side: const BorderSide(color: AppColors.appgreen),
                  ),
                  child: btnWidget,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textButton(
                context,
                resetPasswordController,
                "Forgot Password?",
                () => null,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
