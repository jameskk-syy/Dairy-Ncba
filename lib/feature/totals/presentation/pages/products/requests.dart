import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../../feature/home/presentation/cubit/routes_cubit.dart';
import '../../../../../feature/totals/presentation/pages/products/stock_page.dart';
import '../../../../../feature/totals/presentation/pages/widgets/feeds.dart';
import '../../../../../feature/totals/domain/model/feeds_requests_model.dart';
import 'package:logger/logger.dart';

import '../../../../../core/utils/user_data.dart';
import '../../../../../core/utils/utils.dart';
import '../../cubits/cubit/feeds_requests_cubit.dart';
import 'feeds_requests.dart';
import 'services_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injector_container.dart';
import 'requests_approval.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> with TickerProviderStateMixin {
  late TabController tabController;
  int mccId = 0;

  @override
  void initState() {
    super.initState();
    // getFeedRequests(context);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                sl<RoutesCubit>()..getCollectorRoutes(getUserData().id!),
          ),
          BlocProvider(
            create: (context) =>
                sl<FeedsRequestsCubit>())
        ],
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Farmer Requests"),
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Feeds",
                ),
                Tab(text: "Inventory")
              ]),
            ),
            body: TabBarView(children: [MyFeeds(locationId: getLocationId(),), const MyStock()]),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (tabController.index == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedsRequestsPage()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServicesRequestsPage()));
                }
              },
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ));
  }

  Widget servicesBody(BuildContext context) {
    return BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.uiState == UIState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.uiState == UIState.feedsSuccess) {
            if (state.allFeedsRequests!.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {},
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No services requests found"),
                      IconButton(
                          onPressed: () {
                            // getFeedRequests(context);
                          },
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {},
                child: const Column(
                  children: [
                    // ...state.allFeedsRequests!
                    //     .map((request) => farmerRequest(
                    //             request.farmerName ?? "",
                    //             (request.farmerNo).toString(),
                    //             request.productName ?? "",
                    //             request.comments ?? "",
                    //             request.status ?? "",
                    //           submit(context, request)))
                    //     .toList()
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No services requests found"),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
                ],
              ),
            );
          }
        });
  }

  Widget submit(BuildContext context, FeedsRequestModel requestModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestApproval(
                              feedsRequestModel: requestModel,
                            )));
              },
              child: const Text("Approve"))
        ],
      ),
    );
  }

  confirmRequest(BuildContext context, int requestId, String status) async {
    final cubit = sl<FeedsRequestsCubit>();

    await cubit.confirmFeedsRequest(requestId, status).then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.error) {
        final log = Logger();
        log.e(state.error);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: state.error!,
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Success',
          desc: 'Request approved successfully',
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      }
    });
  }

  getFeedequests(BuildContext context) {
    final cubit = sl<FeedsRequestsCubit>();

    cubit.getCollectorPickupLocations(getUserData().id!).then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {
        setState(() {
          mccId = state.locationId!;
        });
        BlocProvider.of<FeedsRequestsCubit>(context)
            .getAllFeedsRequests(mccId, 8, "2024")
            .then((value) {});
      } else if (state.uiState == UIState.error) {}
    });
  }

  refreshPage(BuildContext context) {
    BlocProvider.of<FeedsRequestsCubit>(context)
        .getAllFeedsRequests(getLocationId(), 8, "2024");
  }
}
