import 'package:dairytenantapp/config/theme/colors.dart';
import 'package:dairytenantapp/core/presentation/widgets/forms/login_form.dart';
import 'package:dairytenantapp/feature/auth/presentation/pages/firsttimeotp.dart';
import 'package:dairytenantapp/feature/auth/presentation/pages/validateotp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/presentation/widgets/animations/spinkit.dart';
import '../../../../core/presentation/widgets/dialogs/snackbars.dart';
import '../../../../core/utils/utils.dart';
import '../bloc/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final resetPasswordController = TextEditingController();
  static bool _isLoading = false;

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => sl<LoginCubit>()),
      ],
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.uiState == UIState.success) {
            _toggleLoadingState();
        
            if (state.authLoginResponse?.entity?.firstLogin == "false") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ValidateOtp(username: userNameController.text),
                ),
              );
            } else if (state.authLoginResponse?.entity?.firstLogin == "true") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          FirstTimeOtp(username: userNameController.text),
                ),
              );
            }
            showSnackbar(context, "Login Successful");
          } else if (state.uiState == UIState.error) {
            _isLoading = false;
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
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // ===== TOP LOGO AND TEXT =====
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            SvgPicture.asset(
                              'assets/images/Layer.svg',
                              height: 100,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Welcome to Maziwa Solution",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Please Login Below",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ===== LOGIN FORM =====
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: loginForm(
                          context,
                          formKey,
                          userNameController,
                          passwordController,
                          resetPasswordController,
                          !state.isPasswordVisible,
                          () {
                            BlocProvider.of<LoginCubit>(
                              context,
                            ).obscurePassword(
                              !BlocProvider.of<LoginCubit>(
                                context,
                              ).state.isPasswordVisible,
                            );
                          },
                          !BlocProvider.of<LoginCubit>(
                                context,
                              ).state.isPasswordVisible
                              ? const Text(
                                "view",
                                style: TextStyle(color: AppColors.teal),
                              )
                              : const Text(
                                "hide",
                                style: TextStyle(color: AppColors.teal),
                              ),
                          state.uiState == UIState.loading
                              ? spinKit()
                              : const Text(
                                "SUBMIT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          () {
                            if (formKey.currentState!.validate()) {
                              _isLoading = !_isLoading;
                              login(context);
                            } else {
                              showSnackbar(context, "All fields are required");
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== PUSH TO BOTTOM =====
                      const Spacer(),

                      SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: SvgPicture.asset(
                          'assets/images/group.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Handle login process
  login(BuildContext context) {
    final email = userNameController.text.trim();
    final password = passwordController.text.trim();
    hideKeyboard(context);
    context.read<LoginCubit>().login(email, password);
  }

  void _toggleLoadingState() {
    _isLoading = !_isLoading;
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
