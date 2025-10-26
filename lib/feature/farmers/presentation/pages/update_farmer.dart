import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/user_data.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/farmer_card.dart';
import '../../../../feature/farmers/domain/model/farmers_response_model.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/domain/models/collector_routes_model.dart';
import '../../../../core/utils/utils.dart';
import '../../../collections/presentation/blocs/cubit/farmer_details_cubit.dart';
import '../../../home/presentation/cubit/routes_cubit.dart';
import '../../domain/model/farmer_details_model.dart';
import '../blocs/add_farmer_cubit.dart';

class FarmerUpdate extends StatefulWidget {
  final FarmersEntityModel farmersEntityModel;
  const FarmerUpdate({super.key, required this.farmersEntityModel});

  @override
  State<FarmerUpdate> createState() => _FarmerUpdateState();
}

class _FarmerUpdateState extends State<FarmerUpdate> {
  final routeController = TextEditingController();
  String? selectedRoute;
  int? routeId;
  String farmerRoute = "";
  late FarmersEntityModel farmer = const FarmersEntityModel();
  late FarmerDetailsEntityModel farmerInfo = const FarmerDetailsEntityModel();
  static bool loading = false;

  @override
  void initState() {
    super.initState();
    farmer = widget.farmersEntityModel;
    dispatchGetFarmerDetails(context, farmer.farmerNo!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<AddFarmerCubit>()),
          BlocProvider(create: (context) => sl<FarmerDetailsCubit>()),
          BlocProvider(create: (context) => sl<RoutesCubit>())
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Update Farmer Route"),
          ),
          body: Column(
            children: [
              farmerCard(farmer, farmerRoute),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<AddFarmerCubit, AddFarmerState>(
                  builder: (context, state) {
                    if (state.uiState == UIState.error) {
                      return Text(state.exception!);
                    } else {
                      return TextFormField(
                        controller: routeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: 'Select New Route'),
                        onTap: () {
                          getRoutes(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a Route';
                          }
                          return null;
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<AddFarmerCubit, AddFarmerState>(
                  listener: (context, state) {
                    if (state.uiState == UIState.loading) {
                      loading = true;
                    }
                    if (state.uiState == UIState.error) {
                      loading = false;
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.scale,
                        title: 'Error',
                        desc: "Failed to update farmer route",
                        btnOkOnPress: () {
                          Navigator.pop(context);
                        },
                      ).show();
                    } else if (state.uiState == UIState.success) {
                      loading = false;
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.scale,
                        title: 'Success',
                        desc: "Farmer route updated successfully",
                        btnOkOnPress: () {
                          Navigator.pop(context);
                        },
                      ).show();
                    }
                  },
                  builder: (context, state) {
                    return btn(
                        loading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text(
                                "Update Route",
                                style: TextStyle(color: Colors.black),
                              ), () {
                      loading = true;
                      context
                          .read<AddFarmerCubit>()
                          .updateRoute(farmer.farmerNo!, routeId!);
                    });
                  },
                ),
              )
            ],
          ),
        ));
  }

  void getRoutes(BuildContext context) {
    final collectorId = getUserData().id;

    final farmerCubit = context.read<RoutesCubit>();

    farmerCubit.getCollectorRoutes(collectorId!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: farmerCubit,
          child: AlertDialog(
            title: const Text('Select Route'),
            content: BlocBuilder<RoutesCubit, RoutesState>(
              builder: (context, state) {
                if (state.uiState == UIState.error) {
                  SnackBar snackBar = SnackBar(
                    content: Text(state.message!),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return Text(state.message!);
                } else {
                  return DropdownButtonFormField<CollectorRoutesEntityResponse>(
                    decoration: const InputDecoration(labelText: 'Route'),
                    items: state.routes?.map((center) {
                      return DropdownMenuItem<CollectorRoutesEntityResponse>(
                        value: center,
                        child: Text(center.route!),
                      );
                    }).toList(),
                    onChanged: (selectedSubCounty) {
                      routeController.text = selectedSubCounty!.route!;
                      routeId = selectedSubCounty.id!;
                      //routeId = null;
                    },
                  );
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // Handle selected county
                  selectedRoute = routeController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void dispatchGetFarmerDetails(BuildContext context, int farmerNo) async {
    final farmerBloc = sl<FarmerDetailsCubit>();

    await farmerBloc
        .getFarmerDetails(farmerNo /*, farmerNumber*/)
        .then((value) {
      final state = farmerBloc.state;

      if (state.uiState == UIState.success) {
        farmerInfo = state.farmerDetailsModel!;
        setState(() {
          farmerRoute = farmerInfo.route!;
        });
      }
    });
  }
}
