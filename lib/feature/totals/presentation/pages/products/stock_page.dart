import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dairytenantapp/feature/totals/presentation/cubits/cubit/feeds_requests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injector_container.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/requests_cards.dart';

class MyStock extends StatefulWidget {
  const MyStock({super.key});

  @override
  State<MyStock> createState() => _MyStockState();
}

class _MyStockState extends State<MyStock> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<FeedsRequestsCubit>()..getAllProducts(getLocationId()),
      child: stockBody(context, getLocationId()),
    );
  }

  Widget stockBody(BuildContext context, int locationId) {
    return BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.success) {
          if (state.products!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<FeedsRequestsCubit>(
                  context,
                ).getAllProducts(locationId);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message ?? "No feed allocations found"),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<FeedsRequestsCubit>(
                          context,
                        ).getAllProducts(locationId);
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
                BlocProvider.of<FeedsRequestsCubit>(
                  context,
                ).getAllProducts(locationId);
              },
              child: ListView.builder(
                itemCount: state.products!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8,
                      left: 15,
                      right: 15,
                    ),
                    child: feedsAllocation(
                      state.products![index].category!,
                      state.products![index].name!,
                      (state.products![index].stock).toString(),
                      () => null,
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
                const Text("No feed allocations found"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<FeedsRequestsCubit>(
                      context,
                    ).getAllProducts(getLocationId());
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
