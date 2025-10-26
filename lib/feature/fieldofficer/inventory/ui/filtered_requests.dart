import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/config/theme/colors.dart';
import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/feature/fieldofficer/home/cubit/fohome_cubit.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/fields.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/requests_cards.dart';
import '../../../totals/presentation/cubits/cubit/feeds_requests_cubit.dart';

class FilteredRequests extends StatefulWidget {
  final int locationId;
  final int month;
  final String year;
  final String curMonth;
  const FilteredRequests({
    super.key,
    required this.locationId,
    required this.month,
    required this.year,
    required this.curMonth,
  });

  @override
  State<FilteredRequests> createState() => _FilteredRequestsState();
}

class _FilteredRequestsState extends State<FilteredRequests> {
  GlobalKey<FormState> formKey = GlobalKey();
  int month = 1;
  String year = "";
  String curMonth = "";
  SingleValueDropDownController monthCont = SingleValueDropDownController();
  SingleValueDropDownController yearCont = SingleValueDropDownController();

  @override
  void initState() {
    super.initState();
    month = widget.month;
    year = widget.year;
    curMonth = widget.curMonth;
    // downloadReport();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<FeedsRequestsCubit>()
                ..getAllFeedsRequests(widget.locationId, month, year),
      child: BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
        listener: (context, state) {
          if (state.uiState == UIState.loading) {
            const Center(child: CircularProgressIndicator());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("$curMonth Summary"),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.teal,
                          ),
                        );
                      },
                    );
                    downloadReport(context);
                  },
                  icon: const Icon(
                    Icons.cloud_download_outlined,
                    color: AppColors.teal,
                  ),
                ),
              ],
            ),
            body: feedsBody(context),
          );
        },
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
                      const SizedBox(),
                      const SizedBox(),
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

  Widget filterDialog(BuildContext context) {
    return BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  actions: const [],
                  icon: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.close_rounded, color: Colors.red),
                        SizedBox(width: 5),
                        Text("Close"),
                      ],
                    ),
                  ),
                  content: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text("Select Period"),
                          dropdown(
                            Constants.months
                                .map(
                                  (month) => DropDownValueModel(
                                    name: month,
                                    value: Constants.months.indexOf(month) + 1,
                                  ),
                                )
                                .toList(),
                            monthCont,
                            "month is needed",
                            "month",
                            (p0) {
                              setState(() {
                                curMonth = monthCont.dropDownValue!.name;
                                month = int.parse(
                                  monthCont.dropDownValue!.value.toString(),
                                );
                              });
                            },
                          ),
                          dropdown(
                            Constants.years
                                .map(
                                  (year) => DropDownValueModel(
                                    name: year,
                                    value: year,
                                  ),
                                )
                                .toList(),
                            yearCont,
                            "year is needed",
                            "year",
                            (p0) => setState(() {
                              year = yearCont.dropDownValue!.name;
                            }),
                          ),
                          btn(
                            const Text(
                              "submit",
                              style: TextStyle(color: Colors.black),
                            ),
                            () async {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                final feedsCubit = sl<FeedsRequestsCubit>();
                                await feedsCubit.getAllFeedsRequests(
                                  widget.locationId,
                                  month,
                                  year,
                                );
                                final homeCubit = sl<FohomeCubit>();
                                await homeCubit.getAllocationHistory(
                                  month,
                                  year,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.calendar_month, color: AppColors.teal),
        );
      },
    );
  }

  void downloadReport(BuildContext context) async {
    final homeCubit = sl<FohomeCubit>();
    await homeCubit.getAllocationHistory(month, year).then((value) {
      if (homeCubit.state.uiState == UIState.error) {
        showSnackbar(context, "Unable to download report");
        return;
      }
      Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Report generated successfully',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    });
  }
}
