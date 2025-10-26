import 'package:dairytenantapp/core/domain/models/pickup_location_model.dart';
import 'package:dairytenantapp/feature/fieldofficer/home/ui/route_farmers.dart';
import 'package:dairytenantapp/feature/fieldofficer/mccs/ui/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/cards.dart';
import '../cubit/mcc_cubit.dart';

class MccRoutes extends StatefulWidget {
  final PickupLocationEntityModel mccModel;
  final String request;
  const MccRoutes({super.key, required this.mccModel, required this.request});

  @override
  State<MccRoutes> createState() => _MccRoutesState();
}

class _MccRoutesState extends State<MccRoutes> {
  PickupLocationEntityModel selectedMcc = PickupLocationEntityModel();
  String request = "summary";

  @override
  void initState() {
    super.initState();
    request = widget.request;
    selectedMcc = widget.mccModel;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MccCubit>()..getMccRoutes(selectedMcc.id!),
      child: Scaffold(
        appBar: AppBar(title: Text("${selectedMcc.name} Routes")),
        body: body(context, selectedMcc.id!),
      ),
    );
  }

  Widget body(BuildContext context, int mccId) {
    return BlocConsumer<MccCubit, MccState>(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          const Center(child: CircularProgressIndicator());
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.loading ||
            state.uiState == UIState.initial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.success) {
          if (state.routesList!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<MccCubit>(context).getMccRoutes(mccId);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception!),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<MccCubit>(context).getMccRoutes(mccId);
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
                BlocProvider.of<MccCubit>(context).getMccRoutes(mccId);
              },
              child: ListView.builder(
                itemCount: state.routesList!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (request == "summary") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RouteSummaryFilter(
                                  route: state.routesList![index],
                                ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RouteFarmers(
                                  routeId: state.routesList![index].id ?? 0,
                                ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: emptyCard(
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text("Route"),
                                const Spacer(),
                                Text(
                                  state.routesList![index].route!,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     const Text("location"),
                            //     const Spacer(),
                            //     Text(state.routesList![index].route!)
                            //   ],
                            // )
                          ],
                        ),
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
                const Text("No routes found"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<MccCubit>(context).getMccRoutes(mccId);
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
