import 'package:dairytenantapp/feature/fieldofficer/inventory/ui/filter_options.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injector_container.dart';
import '../../../../../feature/totals/presentation/pages/widgets/cancel_request.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/requests_cards.dart';
import '../../../domain/model/feeds_requests_model.dart';
import '../../cubits/cubit/feeds_requests_cubit.dart';
import '../products/requests_approval.dart';

class MyFeeds extends StatefulWidget {
  final int locationId;
  const MyFeeds({super.key, required this.locationId});

  @override
  State<MyFeeds> createState() => _MyFeedsState();
}

class _MyFeedsState extends State<MyFeeds> {
  int month = 1;
  String year = "";
  String curMonth = "";

  @override
  void initState() {
    super.initState();
    month = getMonth();
    year = getYear();
    curMonth = DateFormat("MMMM").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<FeedsRequestsCubit>()
                ..getAllFeedsRequests(widget.locationId, month, year),
      child: Scaffold(
        body: feedsBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          AllocationsFilter(locationId: widget.locationId),
                ),
              ),
          child: const Icon(Icons.search, color: Colors.black),
        ),
      ),
    );
  }

  Widget feedsBody(BuildContext context) {
    return BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          const Center(child: CircularProgressIndicator());
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.loading ||
            state.uiState == UIState.initial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.feedsSuccess) {
          if (state.allFeedsRequests!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<FeedsRequestsCubit>(
                  context,
                ).getAllFeedsRequests(widget.locationId, month, year);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(state.message!),
                    Text("No product allocations for $curMonth"),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<FeedsRequestsCubit>(
                          context,
                        ).getAllFeedsRequests(widget.locationId, month, year);
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
                ).getAllFeedsRequests(widget.locationId, month, year);
              },
              child: ListView.builder(
                itemCount: state.allFeedsRequests!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: farmerRequest(
                      state.allFeedsRequests![index].farmerName ?? "",
                      (state.allFeedsRequests![index].farmerNo).toString(),
                      state.allFeedsRequests![index].productName ?? "",
                      state.allFeedsRequests![index].comments ?? "",
                      state.allFeedsRequests![index].quantity ?? 0,
                      state.allFeedsRequests![index].status ?? "",
                      state.allFeedsRequests![index].approvalDate ?? "",
                      submit(context, state.allFeedsRequests![index]),
                      cancel(context, state.allFeedsRequests![index]),
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
                const Text("No feed requests found"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<FeedsRequestsCubit>(
                      context,
                    ).getAllFeedsRequests(widget.locationId, month, year);
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

Widget cancel(BuildContext context, FeedsRequestModel requestModel) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder:
            //         (context) => CancelRequest(feedsRequestModel: requestModel),
            //   ),
            // );
          },
          //Cancel
          child: const Text(""),
        ),
      ],
    ),
  );
}

Widget submit(BuildContext context, FeedsRequestModel requestModel) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder:
            //         (context) =>
            //             RequestApproval(feedsRequestModel: requestModel),
            //   ),
            // );
          },
          //Approval
          child: const Text(""),
        ),
      ],
    ),
  );
}
