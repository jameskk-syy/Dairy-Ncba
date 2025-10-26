import 'dart:convert';

import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dairytenantapp/core/widgets/fields.dart';
import 'package:dairytenantapp/feature/farmers/presentation/pages/update_farmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../blocs/farmers_cubit.dart';

class FarmersPage extends StatefulWidget {
  const FarmersPage({super.key});

  @override
  State<FarmersPage> createState() => _FarmersPageState();
}

class _FarmersPageState extends State<FarmersPage> {
  bool searching = false;
  final TextEditingController searchCont = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FarmersCubit>()..getFarmers(getUserData().id!),
      child: BlocConsumer<FarmersCubit, FarmersState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title:
                  searching
                      ? SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.0,
                        child: searchField(searchCont, (query) {
                          context.read<FarmersCubit>().searchFarmer(query);
                        }),
                      )
                      : const Text("Farmers Page"),
              actions: [
                IconButton(
                  icon: Icon(searching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      // searching = !searching;
                      // context
                      //     .read<FarmersCubit>()
                      //     .searchFarmer(searchCont.text.trim());
                      // if (searching) {
                      //   searchCont.clear();
                      //   context.read<FarmersCubit>().searchFarmer('');
                      // }
                      if (searching) {
                        searchCont.clear();
                        context.read<FarmersCubit>().searchFarmer('');
                      }
                      searching = !searching;
                    });
                  },
                ),
              ],
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            body: _buildBody(context),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<FarmersCubit, FarmersState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(
            msg: 'An error occurred',
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
        if (state.uiState == UIState.initial) {
          final prefs = sl<SharedPreferences>();
          final userData = prefs.getString("userData");
          final user = LoginResponseDto.fromJson(jsonDecode(userData!));
          final collectorId = user.id;
          context.read<FarmersCubit>().getFarmers(collectorId!);
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.success) {
          if (state.filteredFarmers!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                final prefs = sl<SharedPreferences>();
                final userData = prefs.getString("userData");
                final user = LoginResponseDto.fromJson(jsonDecode(userData!));
                final collectorId = user.id;
                context.read<FarmersCubit>().getFarmers(collectorId!);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No farmers data found'),
                    IconButton(
                      onPressed: () {
                        final prefs = sl<SharedPreferences>();
                        final userData = prefs.getString("userData");
                        final user = LoginResponseDto.fromJson(
                          jsonDecode(userData!),
                        );
                        final collectorId = user.id;
                        context.read<FarmersCubit>().getFarmers(collectorId!);
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
                final prefs = sl<SharedPreferences>();
                final userData = prefs.getString("userData");
                final user = LoginResponseDto.fromJson(jsonDecode(userData!));
                final collectorId = user.id;
                context.read<FarmersCubit>().getFarmers(collectorId!);
              },
              child: ListView.builder(
                itemCount: state.filteredFarmers!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (userRole() != "TRANSPORTER") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FarmerUpdate(
                                  farmersEntityModel:
                                      state.filteredFarmers![index],
                                ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
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
                              0,
                              1,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/farmer.png",
                                height: 100,
                                width: 50,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_2_outlined,
                                      size: 15,
                                      color: AppColors.lightColorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      state.filteredFarmers![index].username ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.numbers,
                                      size: 15,
                                      color: AppColors.lightColorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'F/No. ${state.filteredFarmers![index].farmerNo ?? ''}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 15,
                                      color: AppColors.lightColorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Phone. ${state.filteredFarmers![index].mobileNo ?? 'N/A'}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file_outlined,
                                      size: 15,
                                      color: AppColors.lightColorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'ID No. ${state.filteredFarmers![index].idNumber ?? 'N/A'}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                const Text("An error occurred"),
                IconButton(
                  onPressed: () {
                    final prefs = sl<SharedPreferences>();
                    final userData = prefs.getString("userData");
                    final user = LoginResponseDto.fromJson(
                      jsonDecode(userData!),
                    );
                    final collectorId = user.id;
                    context.read<FarmersCubit>().getFarmers(collectorId!);
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
}
