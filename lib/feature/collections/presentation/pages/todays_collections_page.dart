import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/user_data.dart';
import '../../../../core/utils/utils.dart';
import '../../../home/presentation/cubit/routes_cubit.dart';
import '../blocs/today_collection_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodayCollectionsPage extends StatefulWidget {
  const TodayCollectionsPage({super.key});

  @override
  State<TodayCollectionsPage> createState() => _TodayCollectionsPageState();
}

class _TodayCollectionsPageState extends State<TodayCollectionsPage> {

  @override
  void initState() {
    dispatchGetRoutes(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = getTodaysDate();
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TodayCollectionCubit>()
            ..getCollectionHistory(collectorId!, date),
        ),
        BlocProvider(
          create: (context) =>
              sl<RoutesCubit>()..getCollectorRoutes(getUserData().id!),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Today's Collections"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<TodayCollectionCubit, TodayCollectionState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          /*ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.exception!)));*/
          Fluttertoast.showToast(
              msg: state.exception ?? '',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.success) {
          if (state.collectionHistoryModel!.entity!.isEmpty) {
            return RefreshIndicator(
                onRefresh: () async {
                  final date = getTodaysDate();
                  final prefs = sl<SharedPreferences>();
                  final userData = prefs.getString("userData");
                  final user = LoginResponseDto.fromJson(jsonDecode(userData!));
                  final collectorId = user.id;
                  context
                      .read<TodayCollectionCubit>()
                      .getCollectionHistory(collectorId!, date);
                },
                child: const Center(child: Text("No collections today")));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                final date = getTodaysDate();
                final prefs = sl<SharedPreferences>();
                final userData = prefs.getString("userData");
                final user = LoginResponseDto.fromJson(jsonDecode(userData!));
                final collectorId = user.id;
                context
                    .read<TodayCollectionCubit>()
                    .getCollectionHistory(collectorId!, date);
              },
              child: ListView.builder(
                itemCount: state.collectionHistoryModel!.entity!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightColorScheme.primary
                              .withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 1), // changes position of shadow
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
                                "${state.collectionHistoryModel!.entity![index].quantity} Ltrs",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: AppColors.lightColorScheme.primary,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  " ${state.collectionHistoryModel!.entity![index].farmer!}",
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.numbers,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Farmer/No. ${state.collectionHistoryModel!.entity![index].farmerNo.toString()}",
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Date. ${state.collectionHistoryModel!.entity![index].collectionDate!.split('T').first}",
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              // Collection Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.route,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${state.collectionHistoryModel!.entity![index].route!} route",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.sell_outlined,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      (state.collectionHistoryModel!
                                                  .entity![index].session!) ==
                                              "Session 1"
                                          ? "Morning"
                                          : (state
                                                      .collectionHistoryModel!
                                                      .entity![index]
                                                      .session! ==
                                                  "Session 2"
                                              ? "Afternoon"
                                              : "Evening"),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
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
          return const SizedBox.shrink();
        }
      },
    );
  }

  void dispatchGetRoutes(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    BlocProvider.of<RoutesCubit>(context).getCollectorRoutes(collectorId!);
  }
}
