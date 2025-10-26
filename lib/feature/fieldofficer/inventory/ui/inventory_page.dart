import '../../../../core/domain/models/pickup_location_model.dart';
import '../../../../core/widgets/requests_cards.dart';
import '../../../../feature/fieldofficer/inventory/cubit/inventory_cubit.dart';
import '../../../../feature/fieldofficer/inventory/ui/products_source.dart';
import '../../../../feature/totals/presentation/cubits/cubit/feeds_requests_cubit.dart';
import '../../../../feature/totals/presentation/pages/widgets/feeds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';

class InventoryPage extends StatefulWidget {
  final PickupLocationEntityModel mccModel;
  const InventoryPage({super.key, required this.mccModel});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  int index = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    index = tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<FeedsRequestsCubit>()..getAllProducts(widget.mccModel.id!),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Text(
                  "${widget.mccModel.name} Inventory",
                )),
            bottom: TabBar(controller: tabController, tabs: const [
              Tab(
                text: "Stock",
              ),
              Tab(
                text: "Allocations",
              )
            ]),
          ),
          body: TabBarView(controller: tabController, children: [
            Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductsSource(mccModel: widget.mccModel)),),
                child: const Icon(Icons.add, color: Colors.black,)
              ),
              body: body(context, widget.mccModel.id!),
            ),
            MyFeeds(locationId: widget.mccModel.id!)
          ]),
        ),
      ),
    );
  }

  Widget body(BuildContext context, int locationId) {
    return BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.uiState == UIState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.uiState == UIState.success) {
            if (state.products!.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<FeedsRequestsCubit>(context)
                      .getAllProducts(locationId);
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message ?? "No feed allocations found"),
                      IconButton(
                          onPressed: () {
                            BlocProvider.of<FeedsRequestsCubit>(context)
                                .getAllProducts(locationId);
                          },
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<FeedsRequestsCubit>(context)
                      .getAllProducts(locationId);
                },
                child: ListView.builder(
                    itemCount: state.products!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 15, right: 15),
                        child: feedsAllocation(
                            state.products![index].category!,
                            state.products![index].name!,
                            (state.products![index].stock).toString(),
                            () => null),
                      );
                    }),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No product allocations found"),
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<FeedsRequestsCubit>(context)
                            .getAllProducts(locationId);
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
            );
          }
        });
  }

  refreshPage(BuildContext context) {
    BlocProvider.of<InventoryCubit>(context).getAllFeedsRequests();
  }
}
