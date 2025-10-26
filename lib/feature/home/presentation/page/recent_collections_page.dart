import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../../../collections/presentation/blocs/collections_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecentCollectionsPage extends StatelessWidget {
  const RecentCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CollectionsCubit>(
      create: (_) => sl<CollectionsCubit>(),
      child: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<CollectionsCubit, CollectionsState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          /*ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exception!),
            ),
          );*/
          Fluttertoast.showToast(
              msg: state.exception!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.initial) {
          dispatchGetCollectionHistory(context);
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.uiState == UIState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.uiState == UIState.success) {
          if (state.collectionHistoryModel!.entity!.isEmpty) {
            return const Center(
              child: Text('You have no collections Recorded'),
            );
          } else {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.collectionHistoryModel!.entity!.length > 5
                  ? 5
                  : state.collectionHistoryModel!.entity!.length,
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
                        color:
                        AppColors.lightColorScheme.primary.withOpacity(0.2),
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
                              "${state.collectionHistoryModel!.entity![index]
                                  .quantity} Ltrs",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
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
                                  Icons.person,
                                  color: AppColors.lightColorScheme.primary,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    " ${state.collectionHistoryModel!
                                        .entity![index].farmer!}",
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10),
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
                                  Icons.numbers,
                                  color: AppColors.lightColorScheme.primary,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    "Farmer/No. ${state.collectionHistoryModel!
                                        .entity![index].farmerNo.toString()}",
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
                                    "Date. ${state.collectionHistoryModel!
                                        .entity![index].collectionDate!.split('T').first}",
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
                                  Icons.attach_money_rounded,
                                  color: AppColors.lightColorScheme.primary,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    '${state.collectionHistoryModel!
                                        .entity![index]
                                        .amount!}Ksh',
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
                                    state.collectionHistoryModel!
                                        .entity![index]
                                        .session!,
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
            );
          }
        } else {
          return Center(
            child: TextButton(
              onPressed: () {
                dispatchGetCollectionHistory(context);
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.signal_wifi_connected_no_internet_4),
                  Text('Retry'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void dispatchGetCollectionHistory(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    BlocProvider.of<CollectionsCubit>(context)
        .getCollectionHistory(collectorId!);
  }
}
