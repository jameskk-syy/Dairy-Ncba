import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/data/dto/collectors_response_dto.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/domain/models/routes_model.dart';
import '../../data/dto/total_milk_accumulation_dto.dart';
import '../cubits/add_accumulative_collection_cubit.dart';
import '../cubits/milk_collectors_cubit.dart';

class AddTotalCollectionsPage extends StatelessWidget {
  AddTotalCollectionsPage({super.key});
  final session = getSession();
  final TextEditingController collectorNameController = TextEditingController();
  final TextEditingController routeNameController = TextEditingController();
  final TextEditingController milkQuantityController = TextEditingController();
  final TextEditingController sessionController = TextEditingController(
    text: getSession(),
  );
  final formKey = GlobalKey<FormState>();

  final List<UserData> collectorList = [];
  final List<RoutesEntityModel> routesList = [];
  static int? collectorId;
  static int? selectedCollectorId;
  static int? routeId;
  static bool isTapped = false;
  static int tappedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MilkCollectorsCubit>()..getMilkCollectors(),
        ),
        BlocProvider(create: (context) => sl<AddAccumulativeCollectionCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Record New")),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<MilkCollectorsCubit, MilkCollectorsState>(
      builder: (context, state) {
        switch (state.uiState) {
          case UIState.loading:
            return const Center(child: CircularProgressIndicator());
          case UIState.success:
            collectorList.addAll(state.userData ?? []);
            final log = Logger();
            routesList.addAll(state.routes ?? []);
            log.i('routesList: $routesList');
            log.i('collectorList: $collectorList');
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Text('Fill in the details below'),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Select Collector',
                                            ),
                                            content: SizedBox(
                                              height: 300,
                                              width: 300,
                                              child: ListView.builder(
                                                itemCount: collectorList.length,
                                                itemBuilder: (
                                                  BuildContext context,
                                                  int index,
                                                ) {
                                                  return ListTile(
                                                    title: Text(
                                                      'Name: ${collectorList[index].username}',
                                                    ),
                                                    subtitle: Text(
                                                      'Collector No: ${collectorList[index].id}',
                                                    ),
                                                    trailing: Icon(
                                                      tappedIndex == index
                                                          ? Icons.check
                                                          : null,
                                                      color:
                                                          tappedIndex == index
                                                              ? AppColors
                                                                  .lightColorScheme
                                                                  .primary
                                                              : null,
                                                    ),
                                                    onTap: () {
                                                      tappedIndex = index;
                                                      selectedCollectorId =
                                                          collectorList[index]
                                                              .id;
                                                      collectorNameController
                                                              .text =
                                                          '${collectorList[index].username}, $selectedCollectorId';
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        controller: collectorNameController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          hintText: 'Select Collector',
                                          labelText: 'Collector',
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter total litres';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Select Route'),
                                            content: SizedBox(
                                              height: 300,
                                              width: 250,
                                              child: ListView.builder(
                                                itemCount: routesList.length,
                                                itemBuilder: (
                                                  BuildContext context,
                                                  int index,
                                                ) {
                                                  if (routesList.isEmpty) {
                                                    return const Center(
                                                      child: Text(
                                                        'No routes found',
                                                      ),
                                                    );
                                                  } else {
                                                    return ListTile(
                                                      title: Text(
                                                        'Name: ${routesList[index].route}',
                                                      ),
                                                      subtitle: Text(
                                                        'Route Code: ${routesList[index].routeCode}',
                                                      ),
                                                      trailing: Icon(
                                                        tappedIndex == index
                                                            ? Icons.check
                                                            : null,
                                                        color:
                                                            tappedIndex == index
                                                                ? AppColors
                                                                    .lightColorScheme
                                                                    .primary
                                                                : null,
                                                      ),
                                                      onTap: () {
                                                        tappedIndex = index;
                                                        routeId =
                                                            routesList[index]
                                                                .id;
                                                        routeNameController
                                                                .text =
                                                            '${routesList[index].route}';
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter total litres';
                                          }
                                          return null;
                                        },
                                        controller: routeNameController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          hintText: 'Select Route',
                                          labelText: 'Route',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: milkQuantityController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter Total Litres',
                                      labelText: 'Total Litres',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter total litres';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    controller: sessionController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Session',
                                      labelText: 'Session',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildSubmitButton(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          case UIState.error:
            return Center(child: Text(state.exception ?? 'Error'));
          default:
            return const SizedBox.shrink();
        }
      },
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.exception ?? 'Error')));
        }
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    // final date = getTodaysDate();
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    return BlocConsumer<
      AddAccumulativeCollectionCubit,
      AddAccumulativeCollectionState
    >(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state.uiState == UIState.error) {
          //Show error message
          final log = Logger();
          log.e(state.exception);
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Error',
            desc: state.exception!,
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (state.uiState == UIState.success) {
          //Show success message
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Success',
            desc: 'Collection recorded successfully',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        }
      },
      builder: (context, state) {
        return MaterialButton(
          color: AppColors.lightColorScheme.primary,
          minWidth: double.infinity,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.scale,
                title: 'Confirmation',
                body: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Are you sure you want to submit this collection?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Collector: ${collectorNameController.text.split(',').first.trim()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Collector No: ${collectorNameController.text.split(', ').last.trim()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Quantity: ${milkQuantityController.text.trim()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Session: ${sessionController.text}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                btnOk: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    DateTime now = DateTime.now();
                    String formattedDateTime = DateFormat(
                      "yyyy-MM-ddTHH:mm:ss.SSS'Z'",
                    ).format(now.toUtc());

                    final collection = MilkTotalsAccumulationDto(
                      collectorId: selectedCollectorId,
                      collectionDate: formattedDateTime,
                      routeFk: routeId,
                      session: sessionController.text,
                      milkQuantity: int.parse(milkQuantityController.text),
                      accumulatorId: collectorId!,
                    );
                    final log = Logger();
                    log.i(
                      "Logs: "
                      "${collection.toJson()}",
                    );
                    BlocProvider.of<AddAccumulativeCollectionCubit>(
                      context,
                    ).addAccumulativeCollection(collection);
                  },
                  color: AppColors.lightColorScheme.primary,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: AppColors.lightColorScheme.onPrimary,
                    ),
                  ),
                ),
                btnCancel: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: AppColors.lightColorScheme.error,
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.lightColorScheme.onError),
                  ),
                ),
              ).show();
            } else {
              return;
            }
          },
        );
      },
    );
  }
}
