import 'dart:convert';
import 'package:dairytenantapp/core/data/dto/login_response_dto.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/collections/presentation/blocs/collector_daily_cubit.dart';
import 'package:dairytenantapp/feature/collections/presentation/blocs/cubit/collector_supply_cubit.dart';
import 'package:dairytenantapp/feature/collections/presentation/widgets/bottom.dart';
import 'package:dairytenantapp/feature/collections/presentation/widgets/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injector_container.dart';
import '../../../home/presentation/widgets/dots.dart';

class CollectorsStats extends StatelessWidget {
  const CollectorsStats({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString('userData');
    final user = LoginResponseDto.fromJson(json.decode(userData!));
    final collectorId = user.id;
    final year = (DateTime.now()).year;
    int month = (DateTime.now()).month;
    final date = DateTime.now();
    String formattedMonth = DateFormat.yMMM().format(date);

    changeMonth() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100),
      );

      debugPrint("$pickedDate");
      String formattedDate = DateFormat.yMMMd().format(pickedDate!);
      debugPrint(formattedDate);

      formattedMonth = DateFormat.yMMM().format(pickedDate);
      month = pickedDate.month;
        }

    return MultiBlocProvider(
      providers: [
        BlocProvider<CollectorDailyCubit>(
          create: (context) => sl<CollectorDailyCubit>(),
        ),
        BlocProvider<CollectorSupplyCubit>(
          create:
              (context) =>
                  sl<CollectorSupplyCubit>()
                    ..getCollectorsDailySupply(year, month, collectorId ?? 1),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daily Totals"),
          bottom: BottomBar(
            month: formattedMonth,
            pressed: () {
              // changeMonth();
              // filter(context, month);
            },
          ),
        ),
        body: SingleChildScrollView(child: body(context)),
      ),
    );
  }

  Widget body(BuildContext context) {
    return BlocConsumer<CollectorSupplyCubit, CollectorSupplyState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(
            msg: state.exception ?? '',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.initial) {
          return Center(child: spinkit());
        } else if (state.uiState == UIState.loading) {
          return Center(child: spinkit());
        } else if (state.uiState == UIState.success) {
          if (state.collectionTotalsModel!.entity!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                tryGettingCollectorsSupply(context);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No records available"),
                    TextButton(
                      onPressed: () async {
                        tryGettingCollectorsSupply(context);
                      },
                      child: const Text("Refresh"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                tryGettingCollectorsSupply(context);
              },
              child: dataTable(
                state.collectionTotalsModel!.entity!
                    .where((item) {
                      DateTime rdate = DateTime.parse(item.date!);
                      final date = DateTime.now().toLocal();
                      // DateTime date = DateTime.parse("2023-08-31");
                      return rdate.isBefore(date) ||
                          rdate.isAtSameMomentAs(date);
                    })
                    .toList()
                    // ..sort((a, b) {
                    //   DateTime dateA = DateTime.parse(a.date!);
                    //   DateTime dateB = DateTime.parse(b.date!);
                    //   return dateB.compareTo(dateA);
                    // })
                    .map((item) {
                      double quantity = item.quantity ?? 0.0;
                      double quantityd = item.quantityd ?? 0.0;
                      final result = quantityd - quantity;
                      // const result = 524877;
                      return DataRow(
                        cells: [
                          DataCell(Text(item.date!)),
                          DataCell(Text(item.quantity!.toString())),
                          DataCell(Text(item.quantityd.toString())),
                          DataCell(
                            Text(
                              result > 0 ? "+$result" : result.toString(),
                              style: TextStyle(
                                color:
                                    result > 0
                                        ? Colors.green
                                        : (result < 0
                                            ? Colors.red
                                            : Colors.black),
                              ),
                            ),
                          ),
                        ],
                      );
                    })
                    .toList(),
                context,
              ),
              // child: ListView.builder(
              //   itemCount: state.collectionTotalsModel!.entity!.length,
              //   itemBuilder: (context, index) {
              //     double quantity =
              //         state.collectionTotalsModel!.entity![index].quantity ?? 0;
              //     double quantityd =
              //         state.collectionTotalsModel!.entity![index].quantity ?? 0;
              //     double result = quantityd - quantity;

              //     return table(
              //         {state.collectionTotalsModel!.entity![index].date}
              //             .toString(),
              //         {state.collectionTotalsModel!.entity![index].quantity}
              //             .toString(),
              //         {state.collectionTotalsModel!.entity![index].quantity}
              //             .toString(),
              //         result.toString(),
              //         result > 0
              //             ? Colors.green
              //             : (result < 0 ? Colors.red : Colors.black));
              //   },
              // ),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No Internet Connection"),
                TextButton(
                  onPressed: () async {
                    tryGettingCollectorsSupply(context);
                  },
                  child: const Text("refresh"),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void tryGettingCollectorsSupply(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(json.decode(userData!));
    final collectorId = user.id;
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    BlocProvider.of<CollectorSupplyCubit>(
      context,
    ).getCollectorsDailySupply(year, month, collectorId!);
  }

  void filter(BuildContext context, int month) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(json.decode(userData!));
    final collectorId = user.id;
    final year = DateTime.now().year;
    BlocProvider.of<CollectorSupplyCubit>(
      context,
    ).getCollectorsDailySupply(year, month, collectorId!);
  }
}
