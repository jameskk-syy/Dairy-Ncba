import '../../../../core/widgets/fields.dart';
import '../../../../feature/fieldofficer/home/cubit/fohome_cubit.dart';
import '../../../../feature/fieldofficer/home/ui/farmer_stmt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';

class RouteFarmers extends StatefulWidget {
  final int routeId;
  const RouteFarmers({super.key, required this.routeId});

  @override
  State<RouteFarmers> createState() => _RouteFarmersState();
}

class _RouteFarmersState extends State<RouteFarmers> {
  bool searching = false;
  final TextEditingController searchCont = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FohomeCubit>()..getFarmers(widget.routeId),
      child: BlocConsumer<FohomeCubit, FohomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: searching
                  ? SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 1.0,
                      child: searchField(searchCont, (query) {
                        context.read<FohomeCubit>().searchFarmer(query);
                      }),
                    )
                  : const Text("Farmers"),
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
                        context.read<FohomeCubit>().searchFarmer('');
                      }
                      searching = !searching;
                    });
                  },
                )
              ],
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            body: body(context),
          );
        },
      ),
    );
  }

  Widget body(BuildContext context) {
    return BlocConsumer<FohomeCubit, FohomeState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(
              msg: 'An error occurred',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.initial) {
          context.read<FohomeCubit>().getFarmers(widget.routeId);
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.uiState == UIState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.uiState == UIState.success) {
          if (state.filteredFarmers!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FohomeCubit>().getFarmers(widget.routeId);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No farmers data found'),
                    IconButton(
                        onPressed: () {
                          context.read<FohomeCubit>().getFarmers(widget.routeId);
                        },
                        icon: const Icon(Icons.refresh))
                  ],
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FohomeCubit>().getFarmers(widget.routeId);
              },
              child: ListView.builder(
                itemCount: state.filteredFarmers!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FarmerStatement(farmersEntityModel: state.filteredFarmers![index])));
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                            const SizedBox(
                              width: 10,
                            ),
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
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        state.filteredFarmers![index]
                                                .username ??
                                            '',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.numbers,
                                        size: 15,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'F/No. ${state.filteredFarmers![index].farmerNo ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 15,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Phone. ${state.filteredFarmers![index].mobileNo ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.insert_drive_file_outlined,
                                        size: 15,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'ID No. ${state.filteredFarmers![index].idNumber ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
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
                      context.read<FohomeCubit>().getFarmers(widget.routeId);
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
          );
        }
      },
    );
  }
}
