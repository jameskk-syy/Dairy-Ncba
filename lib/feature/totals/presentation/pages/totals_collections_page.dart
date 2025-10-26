import 'dart:convert';

import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../cubits/accumulation_history_cubit.dart';

class TotalsCollectionsHistory extends StatelessWidget {
  const TotalsCollectionsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // final date = getTodaysDate();
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    return BlocProvider(
      create:
          (context) =>
              sl<AccumulationHistoryCubit>()
                ..getMilkAccumulationHistory(collectorId!),
      child: Scaffold(
        appBar: AppBar(title: const Text("Collections History")),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<AccumulationHistoryCubit, AccumulationHistoryState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(
            msg: state.exception ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.success) {
          if (state.data.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                // dispatchGetCollectionHistory(context);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You have no collection history'),
                    IconButton(
                      onPressed: () {
                        dispatchGetCollectionHistory(context);
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                dispatchGetCollectionHistory(context);
              },
              child: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightColorScheme.primary.withOpacity(
                            0.2,
                          ),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/milk_placeholder.png",
                                height: 90,
                                width: 50,
                              ),
                              Text(
                                "${state.data[index].milkQuantity} Ltrs",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.monetization_on_outlined,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "KES ${state.data[index].amount!}",
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.numbers,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "Collector/No. ${state.data[index].collectorId.toString()}",
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "Date. ${state.data[index].collectionDate!.split('T').first}",
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No Internet connection"),
                IconButton(
                  onPressed: () {
                    dispatchGetCollectionHistory(context);
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void dispatchGetCollectionHistory(BuildContext context) {
    // final date = getTodaysDate();
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    BlocProvider.of<AccumulationHistoryCubit>(
      context,
    ).getMilkAccumulationHistory(collectorId!);
  }
}
