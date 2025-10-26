import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/widgets/button.dart';
import 'package:dairytenantapp/core/widgets/requests_cards.dart';
import 'package:dairytenantapp/feature/totals/domain/model/feeds_requests_model.dart';
import 'package:dairytenantapp/feature/totals/presentation/cubits/cubit/feeds_requests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injector_container.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/confirm_dialog.dart';

class RequestApproval extends StatefulWidget {
  final FeedsRequestModel feedsRequestModel;
  const RequestApproval({super.key, required this.feedsRequestModel});

  @override
  State<RequestApproval> createState() => _RequestApprovalState();
}

class _RequestApprovalState extends State<RequestApproval> {
  FeedsRequestModel request = const FeedsRequestModel();

  @override
  void initState() {
    super.initState();
    request = widget.feedsRequestModel;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<FeedsRequestsCubit>())],
      child: BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
        listener: (context, state) {
          if (state.uiState == UIState.loading) {
            showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state.uiState == UIState.error) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              title: 'Error Message',
              desc: state.error ?? state.error ?? "An error occurred",
              btnOkOnPress: () {
                Navigator.pop(context);
              },
            ).show();
          } else if (state.uiState == UIState.success) {
            // pop confirmation
            Navigator.pop(context);
            // Show success message
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              title: 'Success',
              desc:
                  state.customResponse!.message ??
                  "Request Approved Successfully",
              btnOkOnPress: () {
                Navigator.pop(context);
              },
            ).show();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Request Approval")),
            body: Padding(
              padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
              child: Column(
                children: [
                  feedRequestApproval(request),
                  const SizedBox(height: 15),
                  btn(
                    const Text(
                      "Approve Request",
                      style: TextStyle(color: Colors.black),
                    ),
                    () {
                      confirmDialog(
                        context,
                        "Product Request",
                        "Confirm the below details",
                        Column(
                          children: [
                            Text(
                              'Farmer: ${request.farmerName}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Farmer No: ${request.farmerNo}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Product: ${request.productName}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Quantity: ${request.quantity}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        () {
                          BlocProvider.of<FeedsRequestsCubit>(
                            context,
                          ).confirmFeedsRequest(request.id!, "Approved");
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
