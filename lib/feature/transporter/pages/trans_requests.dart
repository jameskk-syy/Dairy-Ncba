import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector_container.dart';
import '../../../core/utils/user_data.dart';
import '../../../core/utils/utils.dart';
import '../../home/presentation/cubit/routes_cubit.dart';
import '../../totals/presentation/cubits/cubit/feeds_requests_cubit.dart';
import '../../totals/presentation/pages/products/feeds_requests.dart';
import '../../totals/presentation/pages/widgets/feeds.dart';

class TransporterRequests extends StatefulWidget {
  const TransporterRequests({super.key});

  @override
  State<TransporterRequests> createState() => _TransporterRequestsState();
}

class _TransporterRequestsState extends State<TransporterRequests>
    with TickerProviderStateMixin {
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
          BlocProvider(create: (context) => sl<FeedsRequestsCubit>())
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
                Tab(text: "Services")
              ]),
            ),
            body: TabBarView(children: [
              MyFeeds(
                locationId: getLocationId(),
              ),
              servicesBody(context)
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (tabController.index == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedsRequestsPage()));
                } else {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const ServicesRequestsPage()));
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
}
