import 'dart:convert';

import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/home/presentation/cubit/home_cubit.dart';
import 'package:dairytenantapp/feature/home/presentation/widgets/dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';

class MonthlyStats extends StatelessWidget {
  const MonthlyStats({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    return BlocProvider<HomeCubit>(
      create:
          (context) =>
              sl<HomeCubit>()
                ..getMonthlyTotals(DateTime.now().month, collectorId ?? 1),
      child: Container(child: body()),
    );
  }

  Widget body() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(msg: "An error occured");
        } //else if (state.uiState == UIState.loading) {
        //   showDialog(
        //       context: context,
        //       builder: (context) => Center(
        //             child: spinkit(),
        //           ));
        // }
      },
      builder: (context, state) {
        double quantityc = state.monthlyTotalsModelEntity?.collected ?? 0.0;
        double quantityd = state.monthlyTotalsModelEntity?.supply ?? 0.0;
        double diff =
            double.parse(quantityd.toStringAsFixed(2)) -
            double.parse(quantityc.toStringAsFixed(2));
        double collected = double.parse(quantityc.toStringAsFixed(2));
        double supply = double.parse(quantityd.toStringAsFixed(2));
        if (state.uiState == UIState.initial) {
          tryGettingMonthlyStats(context);
          return Center(child: spinkit());
        } else if (state.uiState == UIState.loading) {
          return Center(child: spinkit());
        } else if (state.uiState == UIState.success) {
          if (state.monthlyTotalsModel!.entity!.isEmpty) {
            return const Center(child: Text("No records found!"));
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightColorScheme.onPrimary.withOpacity(
                      0.2,
                    ),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Monthly Intake Total",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "$collected Ltrs",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Text(
                        "Monthly Supply",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "$supply Ltrs",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Text(
                        "Difference",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        diff > 0 ? "+$diff Ltrs" : "$diff Ltrs",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              diff > 0
                                  ? Colors.green
                                  : (diff < 0 ? Colors.red : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: Column(
              children: [
                const Text("An error occurred"),
                TextButton(
                  onPressed: () {
                    tryGettingMonthlyStats(context);
                  },
                  child: const Text("retry"),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void tryGettingMonthlyStats(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    BlocProvider.of<HomeCubit>(
      context,
    ).getMonthlyTotals(DateTime.now().month, collectorId!);
  }
}
