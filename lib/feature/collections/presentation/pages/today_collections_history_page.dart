import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/data/datasources/local/datasource/core_local_datasource.dart';
import 'package:dairytenantapp/core/data/dto/login_response_dto.dart';
import 'package:dairytenantapp/feature/auth/presentation/pages/login_page.dart';
import 'package:dairytenantapp/feature/collections/domain/model/collection_history_model.dart';
import 'package:dairytenantapp/feature/collections/presentation/blocs/cubit/farmer_details_cubit.dart';
import 'package:dairytenantapp/feature/collections/presentation/pages/add_collection_page.dart';
import 'package:dairytenantapp/feature/collections/presentation/pages/pending_collections.dart';
import 'package:dairytenantapp/feature/home/presentation/cubit/routes_cubit.dart';
import 'package:dairytenantapp/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/user_data.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../blocs/today_collection_cubit.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import 'filter_collections_by_date.dart';
import 'filtered_collections_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodaysCollectionsPage extends StatelessWidget {
  TodaysCollectionsPage({super.key});

  final TextEditingController farmerNumberTextFieldController =
      TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController farmerNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final FocusNode focusNodeFarmerNumber = FocusNode();
  final filterFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final bool isLoading = false;
  static bool isFarmerDetailsLoading = false;
  static DateTime? startDate;
  static DateTime? endDate;

  final List<String> sessions = [
    'All Sessions',
    'Session 1',
    'Session 2',
    'Session 3',
  ];
  static String selectedSession = 'All Sessions';

  @override
  Widget build(BuildContext context) {
    final date = getTodaysDate();
    final prefs = sl<SharedPreferences>();
    final CoreLocalDataSource localDataSource;
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;

    return MultiBlocProvider(
      providers: [
        /*BlocProvider<CollectionsCubit>(
          create: (_) => sl<CollectionsCubit>(),
        ),*/
        BlocProvider<RoutesCubit>(
          create:
              (context) => sl<RoutesCubit>()..getCollectorRoutes(collectorId!),
        ),
        BlocProvider<FarmerDetailsCubit>(
          create: (_) => sl<FarmerDetailsCubit>(),
        ),
        BlocProvider<TodayCollectionCubit>(
          create:
              (context) =>
                  sl<TodayCollectionCubit>()
                    ..getCollectionHistory(collectorId!, date),
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Today's Collections"),
            actions: [
              PopupMenuButton(
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'filter',
                        child: Text('Filter'),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ],
                onSelected: (value) async {
                  if (value == 'today') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodaysCollectionsPage(),
                      ),
                    );
                  } else if (value == 'logout') {
                    CoreLocalDataSource localDataSource =
                        sl<CoreLocalDataSource>();
                    localDataSource.setIsLoggedIn(false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Choose an option'),
                          content: SizedBox(
                            height: 120,
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text('Filter by farmer'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => Container(
                                            height: 300,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 100,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Material(
                                              child: Form(
                                                key: filterFormKey,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    const Text(
                                                      'Filter by date',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                          ),
                                                      child: TextFormField(
                                                        controller:
                                                            dateRangeController,
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText:
                                                                  'Date Range',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                        onTap: () async {
                                                          final dateRange =
                                                              await showDateRangePicker(
                                                                context:
                                                                    context,
                                                                firstDate:
                                                                    DateTime(
                                                                      2010,
                                                                    ),
                                                                lastDate:
                                                                    DateTime(
                                                                      2050,
                                                                    ),
                                                              );
                                                          startDate =
                                                              dateRange!.start;
                                                          endDate =
                                                              dateRange.end;
                                                          dateRangeController
                                                                  .text =
                                                              'From ${startDate!.year}-${startDate!.month}-${startDate!.day} To ${endDate!.year}-${endDate!.month}-${endDate!.day}';
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                          ),
                                                      child: TextFormField(
                                                        controller:
                                                            farmerNumberController,
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText:
                                                                  'Farmer Number',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter farmer number';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                          ),
                                                      child: DropdownButtonFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText:
                                                                  'Session',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                        value: selectedSession,
                                                        onChanged: (value) {
                                                          selectedSession =
                                                              value.toString();
                                                        },
                                                        items:
                                                            sessions.map((
                                                              session,
                                                            ) {
                                                              return DropdownMenuItem(
                                                                value: session,
                                                                child: Text(
                                                                  session,
                                                                ),
                                                              );
                                                            }).toList(),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (filterFormKey
                                                              .currentState!
                                                              .validate()) {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            final prefs =
                                                                sl<
                                                                  SharedPreferences
                                                                >();
                                                            final userData =
                                                                prefs.getString(
                                                                  "userData",
                                                                );
                                                            final user =
                                                                LoginResponseDto.fromJson(
                                                                  jsonDecode(
                                                                    userData!,
                                                                  ),
                                                                );
                                                            final collectorId =
                                                                user.id;

                                                            final startDateFormatted =
                                                                '${startDate!.year}-${startDate!.month}-${startDate!.day}';
                                                            final endDateFormatted =
                                                                '${endDate!.year}-${endDate!.month}-${endDate!.day}';
                                                            final farmerNo =
                                                                farmerNumberController
                                                                    .text
                                                                    .trim();

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => FilteredCollectionsPage(
                                                                      startDate:
                                                                          startDateFormatted,
                                                                      endDate:
                                                                          endDateFormatted,
                                                                      farmerNo:
                                                                          farmerNo,
                                                                      session:
                                                                          selectedSession,
                                                                      collectorId:
                                                                          collectorId!,
                                                                    ),
                                                              ),
                                                            );

                                                            farmerNumberController
                                                                .clear();
                                                            dateRangeController
                                                                .clear();
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Apply Filter',
                                                        ),
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
                                ListTile(
                                  title: const Text('Filter by date only'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => Container(
                                            height: 300,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 100,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Material(
                                              child: Form(
                                                key: filterFormKey,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    const Text(
                                                      'Filter by date',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                          ),
                                                      child: TextFormField(
                                                        controller:
                                                            dateController,
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText: 'Date',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                        onTap: () async {
                                                          final date =
                                                              await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime.now(),
                                                                firstDate:
                                                                    DateTime(
                                                                      2010,
                                                                    ),
                                                                lastDate:
                                                                    DateTime(
                                                                      2050,
                                                                    ),
                                                              );

                                                          dateController.text =
                                                              '${date!.year}-${date.month}-${date.day}';

                                                          /*final dateRange = await showDatePicker(
                                                          context: context,

                                                        );*/

                                                          //dateRangeController.text = 'From ${startDate!.year}-${startDate!.month}-${startDate!.day} To ${endDate!.year}-${endDate!.month}-${endDate!.day}';
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                          ),
                                                      child: DropdownButtonFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText:
                                                                  'Session',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                        value: selectedSession,
                                                        onChanged: (value) {
                                                          selectedSession =
                                                              value.toString();
                                                        },
                                                        items:
                                                            sessions.map((
                                                              session,
                                                            ) {
                                                              return DropdownMenuItem(
                                                                value: session,
                                                                child: Text(
                                                                  session,
                                                                ),
                                                              );
                                                            }).toList(),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (filterFormKey
                                                              .currentState!
                                                              .validate()) {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            final prefs =
                                                                sl<
                                                                  SharedPreferences
                                                                >();
                                                            final userData =
                                                                prefs.getString(
                                                                  "userData",
                                                                );
                                                            final user =
                                                                LoginResponseDto.fromJson(
                                                                  jsonDecode(
                                                                    userData!,
                                                                  ),
                                                                );
                                                            final collectorId =
                                                                user.id;

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => FilterCollectionByDatePage(
                                                                      date:
                                                                          dateController
                                                                              .text,
                                                                      collectorId:
                                                                          collectorId!,
                                                                    ),
                                                                /*FilteredCollectionsPage(
                                                                      startDate:
                                                                      startDateFormatted,
                                                                      endDate:
                                                                      endDateFormatted,
                                                                      farmerNo: farmerNo,
                                                                      session:
                                                                      selectedSession,
                                                                      collectorId: collectorId!
                                                                  ),*/
                                                              ),
                                                            );

                                                            //farmerNumberController.clear();
                                                            //dateController.clear();
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Apply Filter',
                                                        ),
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
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [Tab(text: 'Uploaded'), Tab(text: 'Pending')],
            ),
          ),
          floatingActionButton: _buildFab1(context),
          body: TabBarView(
            children: [_buildBody(context), const PendingCollectionsPage()],
          ),
        ),
      ),
    );
  }

  Widget _buildFab1(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final cubit = sl<RoutesCubit>();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCollectionPage()),
        );

        await cubit.getCollectorRoutes(getUserData().id!).then((value) {
          final state = cubit.state;

          if (state.uiState == UIState.loading) {
            showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state.uiState == UIState.success) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const AddCollectionPage()));
          }
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const AddCollectionPage(
        //       visible: true,
        //     ),
        //   ),
        // );
      },
      child: const Icon(Icons.add, color: Colors.black),
    );
  }

  Widget _buildFab(BuildContext context) {
    return BlocConsumer<FarmerDetailsCubit, FarmerDetailsCubitState>(
      listener: (context, state) {
        _toggleLoadingState();
        if (state.uiState == UIState.success) {
          _toggleLoadingState();
          final farmerDetails = state.farmerDetailsModel;
          final log = Logger();
          log.i(farmerDetails);
          Navigator.pop(context);
          farmerNumberTextFieldController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => const AddCollectionPage(
                    visible: true,
                    //farmerDetailsModel: farmerDetails!,
                  ),
            ),
          );
          //_toggleLoadingState();
          // Show success message
        } else if (state.uiState == UIState.error) {
          _toggleLoadingState();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Not Found',
            desc: 'The farmer number you entered does not exist',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        }
      },
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            showNumberEntryDialog(context);
          },
          child: const Icon(Icons.add, color: Colors.black),
        );
      },
    );
  }

  void _toggleLoadingState() {
    isFarmerDetailsLoading = !isFarmerDetailsLoading;
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<TodayCollectionCubit, TodayCollectionState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          /*ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exception ?? ''),
              backgroundColor: Colors.red,
            ),
          );*/
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
        if (state.uiState == UIState.initial) {
          dispatchGetCollectionHistory(context);
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.success) {
          if (state.collectionHistoryModel!.entity!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                dispatchGetCollectionHistory(context);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You have no collections for today'),
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
                itemCount: state.collectionHistoryModel!.entity!.length,
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
                                "${state.collectionHistoryModel!.entity![index].quantity} Kgs",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: AppColors.lightColorScheme.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      " ${state.collectionHistoryModel!.entity![index].farmer!}",
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.numbers,
                                              color:
                                                  AppColors
                                                      .lightColorScheme
                                                      .primary,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "Farmer/No. ${state.collectionHistoryModel!.entity![index].farmerNo.toString()}",
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                              color:
                                                  AppColors
                                                      .lightColorScheme
                                                      .primary,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "Date. ${state.collectionHistoryModel!.entity![index].collectionDate!.split('T').first}",
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        // Collection Date
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.route,
                                              color:
                                                  AppColors
                                                      .lightColorScheme
                                                      .primary,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "${state.collectionHistoryModel!.entity![index].route!} route",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color:
                                                  AppColors
                                                      .lightColorScheme
                                                      .primary,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                (state
                                                            .collectionHistoryModel!
                                                            .entity![index]
                                                            .session!) ==
                                                        "Session 1"
                                                    ? "Morning"
                                                    : (state
                                                                .collectionHistoryModel!
                                                                .entity![index]
                                                                .session ==
                                                            "Session 2"
                                                        ? "Afternoon"
                                                        : "Evening"),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     returnDelivery(context,
                              //         state.collectionHistoryModel!.entity![index]),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        // Expanded(
                        //   flex: 2,
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.person,
                        //             color: AppColors.lightColorScheme.primary,
                        //             size: 15,
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Expanded(
                        //             child: Text(
                        //               " ${state.collectionHistoryModel!.entity![index].farmer!}",
                        //               style: const TextStyle(
                        //                   overflow: TextOverflow.ellipsis,
                        //                   fontSize: 10),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(
                        //         height: 5,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.numbers,
                        //             color: AppColors.lightColorScheme.primary,
                        //             size: 15,
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Expanded(
                        //             child: Text(
                        //               "Farmer/No. ${state.collectionHistoryModel!.entity![index].farmerNo.toString()}",
                        //               style: const TextStyle(
                        //                   overflow: TextOverflow.ellipsis,
                        //                   fontSize: 10,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(
                        //         height: 5,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.calendar_month,
                        //             color: AppColors.lightColorScheme.primary,
                        //             size: 15,
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Expanded(
                        //             child: Text(
                        //               "Date. ${state.collectionHistoryModel!.entity![index].collectionDate!.split('T').first}",
                        //               style: const TextStyle(
                        //                   overflow: TextOverflow.ellipsis,
                        //                   fontSize: 10,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Expanded(
                        //   flex: 2,
                        //   child: Column(
                        //     children: [
                        //       // Collection Date
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.route,
                        //             color: AppColors.lightColorScheme.primary,
                        //             size: 15,
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Expanded(
                        //             child: Text(
                        //               "${state.collectionHistoryModel!.entity![index].route!} route",
                        //               style: const TextStyle(
                        //                 fontSize: 10,
                        //                 fontWeight: FontWeight.bold,
                        //                 overflow: TextOverflow.ellipsis,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(
                        //         height: 5,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.attach_money_rounded,
                        //             color: AppColors.lightColorScheme.primary,
                        //             size: 15,
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Expanded(
                        //             child: Text(
                        //               '${state.collectionHistoryModel!.entity![index].amount!}Ksh',
                        //               style: const TextStyle(
                        //                 fontSize: 10,
                        //                 fontWeight: FontWeight.bold,
                        //                 overflow: TextOverflow.ellipsis,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(
                        //         height: 5,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.sell_outlined,
                        //             color: AppColors.lightColorScheme.primary,
                        //             size: 15,
                        //           ),
                        //           const SizedBox(
                        //             width: 5,
                        //           ),
                        //           Expanded(
                        //             child: Text(
                        //               state.collectionHistoryModel!
                        //                   .entity![index].session!,
                        //               style: const TextStyle(
                        //                 fontSize: 10,
                        //                 fontWeight: FontWeight.bold,
                        //                 overflow: TextOverflow.ellipsis,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    final date = getTodaysDate();
    BlocProvider.of<TodayCollectionCubit>(
      context,
    ).getCollectionHistory(collectorId!, date);
  }

  void dispatchGetFarmerDetails(BuildContext context) {
    final farmerNumberString = farmerNumberTextFieldController.text.trim();
    final farmerNumber = int.parse(farmerNumberString);
    _toggleLoadingState();
    BlocProvider.of<FarmerDetailsCubit>(
      context,
    ).getFarmerDetails(farmerNumber /*, farmerNumber*/);
  }

  Widget returnDelivery(
    BuildContext context,
    CollectionHistoryEntityModel collection,
  ) {
    return BlocConsumer<TodayCollectionCubit, TodayCollectionState>(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "returning delivery ...",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state.uiState == UIState.error) {
          // pop confirmation
          Navigator.pop(context);
          //Show error message
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Error',
            desc: state.exception ?? 'An error occurred. Please try again',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (state.uiState == UIState.success) {
          // pop confirmation
          Navigator.pop(context);
          // Show success message
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Success',
            desc: 'Delivery returned successfully',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  returnDialog(
                    context,
                    collection.farmer!,
                    collection.farmerNo.toString(),
                    collection.collectionDate!.split('T').first,
                    collection.quantity!,
                    collection.session!,
                    () {
                      BlocProvider.of<TodayCollectionCubit>(
                        context,
                      ).returnDelivery(collection.id!);
                    },
                  );
                },
                child: const Text("return"),
              ),
            ],
          ),
        );
      },
    );
  }

  void showNumberEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 3.7,
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Enter Farmer Number',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Material(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: farmerNumberTextFieldController,
                                focusNode: focusNodeFarmerNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.go,
                                style: const TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: const UnderlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.account_circle_sharp,
                                    color:
                                        AppColors
                                            .lightColorScheme
                                            .primaryContainer,
                                    size: 18.0,
                                  ),
                                  hintStyle: const TextStyle(fontSize: 14.0),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter farmer number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RawMaterialButton(
                      shape: const CircleBorder(),
                      onPressed: () {
                        if (farmerNumberTextFieldController.text.isNotEmpty) {
                          isFarmerDetailsLoading
                              ? null
                              : dispatchGetFarmerDetails(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please enter farmer number",
                                style: TextStyle(
                                  color: AppColors.lightColorScheme.onError,
                                ),
                              ),
                              backgroundColor: AppColors.lightColorScheme.error,
                            ),
                          );
                        }
                      },
                      elevation: 2.0,
                      fillColor: AppColors.lightColorScheme.primary,
                      padding: const EdgeInsets.all(15.0),
                      child:
                          isFarmerDetailsLoading
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20.0,
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
