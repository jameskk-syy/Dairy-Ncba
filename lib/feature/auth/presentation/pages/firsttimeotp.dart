import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/config/theme/colors.dart';
import 'package:dairytenantapp/core/di/injector_container.dart';
import 'package:dairytenantapp/core/presentation/widgets/animations/spinkit.dart';
import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/auth/presentation/cubit/otp/first_time_login_otp_cubit.dart';
import 'package:dairytenantapp/feature/auth/presentation/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class FirstTimeOtp extends StatefulWidget {
  final String username;
  const FirstTimeOtp({super.key, required this.username});

  @override
  State<FirstTimeOtp> createState() => _ValidateOtpState();
}

class _ValidateOtpState extends State<FirstTimeOtp> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FirstTimeLoginOtpCubit>(
          create: (context) => sl<FirstTimeLoginOtpCubit>(),
        ),
      ],
      child: BlocConsumer<FirstTimeLoginOtpCubit,FirstTimeLoginOtpState >(
        listener: (context, state) {
          if (state.uiState == UIState.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordPage(resetPasswordToken: state.authLoginResponse!.entity.resetToken),
              ),
            );
            showSnackbar(context, "OTP Verified Successfully");
          } else if (state.uiState == UIState.error) {
            final exception = state.exception;
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              title: 'Error Message',
              desc: exception,
              btnOkOnPress: () {},
            ).show();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.lightColorScheme.primaryContainer,
                    AppColors.lightColorScheme.secondaryContainer,
                    AppColors.lightColorScheme.tertiaryContainer,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Top title
                          SizedBox(height: 120),
                          const Text(
                            "OTP Verification",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Sub text
                          const Text(
                            "We sent you an otp code",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // OTP input fields
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(12),
                                  fieldHeight: 60,
                                  fieldWidth: 50,
                                  activeFillColor: Colors.white,
                                  inactiveFillColor: Colors.white,
                                  selectedFillColor: Colors.white,
                                  activeColor: Colors.teal,
                                  selectedColor: Colors.teal,
                                  inactiveColor: Colors.grey.shade300,
                                ),
                                animationDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                enableActiveFill: true,
                                onCompleted: (v) {
                                  debugPrint("Completed: $v");
                                },
                                onChanged: (value) {
                                  debugPrint(value);
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Verify button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (otpController.text.length == 4) {
                                  context.read<FirstTimeLoginOtpCubit>().validateFirstTimeLoginOtp(
                                    widget.username,
                                    otpController.text,
                                  );
                                } else {
                                  showSnackbar(context, "Enter 4 digit OTP");
                                }
                              },
                              child:
                                  state.uiState == UIState.loading
                                      ? spinKit()
                                      : const Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
