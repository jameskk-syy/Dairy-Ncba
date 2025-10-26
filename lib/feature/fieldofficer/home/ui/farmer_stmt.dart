import 'package:dairytenantapp/config/theme/colors.dart';
import 'package:dairytenantapp/feature/fieldofficer/home/ui/stmt_download.dart';

import '../../../../core/widgets/cards.dart';
import '../../../../core/widgets/farmer_card.dart';
import '../../../../feature/farmers/domain/model/farmer_details_model.dart';
import '../../../../feature/farmers/domain/model/farmers_response_model.dart';
import '../../../../feature/fieldofficer/home/cubit/fohome_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../../../collections/presentation/blocs/cubit/farmer_details_cubit.dart';

class FarmerStatement extends StatefulWidget {
  final FarmersEntityModel farmersEntityModel;
  const FarmerStatement({super.key, required this.farmersEntityModel});

  @override
  State<FarmerStatement> createState() => _FarmerStatementState();
}

class _FarmerStatementState extends State<FarmerStatement> {
  String farmerRoute = "";
  late FarmersEntityModel farmer = const FarmersEntityModel();
  late FarmerDetailsEntityModel farmerInfo = const FarmerDetailsEntityModel();
  String from = "";
  String to = "";

  @override
  void initState() {
    super.initState();
    farmer = widget.farmersEntityModel;
    getFarmerDetails(context, farmer.farmerNo!);
    from = getFirstDay();
    to = getLastDay();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<FohomeCubit>()..getDeliveries(farmer.farmerNo!, from, to),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Farmer Deliveries"),
          actions: [getStatement(context)],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                farmerBody(),
                const SizedBox(height: 4),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: deliveries(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget farmerBody() {
    return farmerCard(farmer, farmerRoute);
  }

  Widget deliveries() {
    return BlocConsumer<FohomeCubit, FohomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.error) {
          return emptyCard(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text("unable to get deliveries"),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<FohomeCubit>(
                        context,
                      ).getDeliveries(farmer.farmerNo!, from, to);
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
          );
        } else if (state.uiState == UIState.success) {
          if (state.deliveries!.isEmpty) {
            return const Center(child: Text("No deliveries found"));
          } else {
            return emptyCard(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Row(
                      children: [Text("Quantity"), Spacer(), Text("Date")],
                    ),
                    const SizedBox(height: 6),
                    ...state.deliveries!.map(
                      (delivery) => Row(
                        children: [
                          Text((delivery.quantity).toString()),
                          const Spacer(),
                          Text(delivery.date ?? ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(
            child: Column(
              children: [
                const Text("try again"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<FohomeCubit>(
                      context,
                    ).getDeliveries(farmer.farmerNo!, from, to);
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

  Widget getStatement(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width / 1.3,
                child: StatementDownload(farmerNo: farmer.farmerNo!),
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.cloud_download, color: AppColors.teal),
    );
  }

  void getFarmerDetails(BuildContext context, int farmerNo) async {
    final farmerBloc = sl<FarmerDetailsCubit>();

    await farmerBloc.getFarmerDetails(farmerNo /*, farmerNumber*/).then((
      value,
    ) {
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
