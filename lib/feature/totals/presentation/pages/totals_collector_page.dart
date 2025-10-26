import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/widgets/sales_stats_widget.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../cubits/cummulator_stats_cubit.dart';
import 'add_totals_collections_page.dart';

class TotalsCollectorHomePage extends StatelessWidget {
  const TotalsCollectorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    // final roles = user.roles!.map((e) => e.name).toList();
    // final role = roles[0];
    final collectorId = user.id;
    final userName = user.username;
    final date = getTodaysDate();

    return BlocProvider(
      create: (context) => sl<CummulatorStatsCubit>()
        ..getTotalRoutes(collectorId!, date)
        ..getTotalMilkCollection(collectorId, date)
        ..getTotalMilks(collectorId, date)
        ..getMilkCollections(collectorId, date),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Bahati's Milk"),
              Text(
                "${getGreetingsMessage()}, $userName",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 2,
                                width: 30,
                                color: Colors.black,
                                child: const Center(child: Text("Menu")),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.account_circle_sharp),
                                  title: const Text('Profile'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()));
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, bottom: 5),
                                child: ListTile(
                                  leading: const Icon(Icons.logout),
                                  title: const Text('Logout'),
                                  onTap: () async {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LoginPage()),
                                        (route) => false);
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.account_circle_sharp,
                  size: 30,
                ))
          ],
        ),
        body: _buildBody(context),
        floatingActionButton: _buildFab(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // final prefs = sl<SharedPreferences>();
        // final userData = prefs.getString("userData");
        // final user = LoginResponseDto.fromJson(jsonDecode(userData!));
        // final roles = user.roles!.map((e) => e.name).toList();
        // final role = roles[0];
        // final collectorId = user.id;
        // final date = getTodaysDate();

        /*context.read<CummulatorStatsCubit>().getTotalRoutes(collectorId!, date);
        context.read<CummulatorStatsCubit>().getTotalMilkCollection(collectorId, date);
        context.read<CummulatorStatsCubit>().getTotalMilks(collectorId, date);*/
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SalesStatsWidget(),
              Expanded(child:
                  BlocBuilder<CummulatorStatsCubit, CummulatorStatsState>(
                builder: (context, state) {
                  if (state.uiState == UIState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.uiState == UIState.success) {
                    if (state.collectionsList?.isEmpty ?? true) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.collectionsList!.length > 5
                            ? 5
                            : state.collectionsList!.length,
                        itemBuilder: (context, index) {
                          final collection = state.collectionsList![index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
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
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
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
                                        "${collection.milkQuantity} Ltrs",
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
                                            Icons.monetization_on_outlined,
                                            color: AppColors
                                                .lightColorScheme.primary,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "KES ${collection.amount!}",
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                            color: AppColors
                                                .lightColorScheme.primary,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Collector/No. ${collection.collectorId.toString()}",
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                            color: AppColors
                                                .lightColorScheme.primary,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Date. ${collection.collectionDate!.split('T').first}",
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
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
                  } else if (state.uiState == UIState.error) {
                    return const Center(
                      child: Text("No Data"),
                    );
                  } else {
                    return const Center(
                      child: Text("No Data"),
                    );
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddTotalCollectionsPage()));
      },
      child: const Icon(Icons.add),
    );
  }
}
