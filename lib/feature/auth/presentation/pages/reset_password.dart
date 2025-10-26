import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/config/theme/colors.dart';
import 'package:dairytenantapp/core/di/injector_container.dart';
import 'package:dairytenantapp/core/presentation/widgets/animations/spinkit.dart';
import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/auth/presentation/cubit/reset%20password/cubit/reset_password_cubit.dart';
import 'package:dairytenantapp/feature/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:core';

class ResetPasswordPage extends StatefulWidget {
  final String resetPasswordToken;
  const ResetPasswordPage({super.key, required this.resetPasswordToken});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=\-{};:"<>,.?~]).{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ResetPasswordDartCubit>(
          create: (context) => sl<ResetPasswordDartCubit>(),
        ),
      ],
      child: BlocConsumer<ResetPasswordDartCubit, ResetPasswordDartState>(
        listener: (context, state) {
          if (state.uiState == UIState.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
            showSnackbar(context, "password reset was successfully");
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
                          SizedBox(height: 120),
                          const Text(
                            "Rest Password Here",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "set new password for login here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // 🔹 Password Field
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                            },
                          ),
                          const SizedBox(height: 20),

                          // 🔹 Confirm Password Field
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

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
                                final password = _passwordController.text.trim();
                                final confirmPassword =
                                    _confirmPasswordController.text.trim();

                                if (!_isPasswordValid(password)) {
                                  showSnackbar(context,
                                      "Password must include uppercase, number, and special character");
                                  return;
                                }

                                if (password != confirmPassword) {
                                  showSnackbar(
                                      context, "Passwords do not match");
                                  return;
                                }

                                context
                                    .read<ResetPasswordDartCubit>()
                                    .resetFirstTimeLoginPassword(widget.resetPasswordToken, _passwordController.text.trim());
                              },
                              child: state.uiState == UIState.loading
                                  ? spinKit()
                                  : const Text(
                                      "Reset Password",
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
