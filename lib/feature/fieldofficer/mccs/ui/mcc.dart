import 'package:dairytenantapp/core/widgets/cards.dart';
import 'package:dairytenantapp/feature/fieldofficer/mccs/ui/mcc_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../../../../feature/fieldofficer/mccs/cubit/mcc_cubit.dart';
import 'package:flutter/material.dart';

class MccPage extends StatefulWidget {
  const MccPage({super.key});

  @override
  State<MccPage> createState() => _MccPageState();
}

class _MccPageState extends State<MccPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<MccCubit>()..getPickupLocations()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("PickUpLocations")),
        body: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
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
          if (state.pickUpLocationModel!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<MccCubit>(context).getPickupLocations();
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception!),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<MccCubit>(context).getPickupLocations();
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
                BlocProvider.of<MccCubit>(context).getPickupLocations();
              },
              child: ListView.builder(
                itemCount: state.pickUpLocationModel!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MccRoutes(
                                  request: "summary",
                                  mccModel: state.pickUpLocationModel![index],
                                ),
                          ),
                        );
                      },
                      child: emptyCard(
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text("mcc"),
                                  const Spacer(),
                                  Text(
                                    state.pickUpLocationModel![index].name!,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("location"),
                                  const Spacer(),
                                  Text(state.pickUpLocationModel![index].ward!),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                // child: Padding(
                //   padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12, bottom: 10),
                //   child: Column(
                //     children: [
                //       ...state.pickUpLocationModel!
                //           .map((mcc) => Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: emptyCard(Column(
                //                   children: [
                //                     Row(
                //                       children: [
                //                         const Text("mcc"),
                //                         const Spacer(),
                //                         Text(mcc.name!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),)
                //                       ],
                //                     ),
                //                     Row(
                //                       children: [
                //                         const Text("location"),
                //                         const Spacer(),
                //                         Text(mcc.ward!)
                //                       ],
                //                     )
                //                   ],
                //                 )),
                //           ))
                //           .toList()
                //     ],
                //   ),
                // ),
              ),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No pick up locations found"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<MccCubit>(context).getPickupLocations();
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
