import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/config/theme/colors.dart';
import 'package:dairytenantapp/core/domain/models/routes_model.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector_container.dart';
import '../../../../core/presentation/widgets/dialogs/snackbars.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/cards.dart';
import '../../../../core/widgets/fields.dart';
import '../../home/cubit/fohome_cubit.dart';
import '../cubit/mcc_cubit.dart';

class RouteSummary extends StatefulWidget {
  final RoutesEntityModel route;
  final int month;
  final String year;
  final String curMonth;
  const RouteSummary({
    super.key,
    required this.route,
    required this.month,
    required this.year,
    required this.curMonth,
  });

  @override
  State<RouteSummary> createState() => _RouteSummaryState();
}

class _RouteSummaryState extends State<RouteSummary> {
  RoutesEntityModel routeModel = RoutesEntityModel();
  GlobalKey<FormState> formKey = GlobalKey();
  int month = int.parse(DateFormat("MM").format(DateTime.now()));
  String year = DateTime.now().year.toString();
  String curMonth = "";
  SingleValueDropDownController monthCont = SingleValueDropDownController();
  SingleValueDropDownController yearCont = SingleValueDropDownController();

  @override
  void initState() {
    super.initState();
    routeModel = widget.route;
    month = widget.month;
    year = widget.year;
    curMonth = widget.curMonth;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<MccCubit>()..getRouteSummary(routeModel.id!, month, year),
      child: Scaffold(
        appBar: AppBar(
          title: Text("${routeModel.route} $curMonth Summary"),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.teal),
                    );
                  },
                );
                saveFile(context);
              },
              icon: const Icon(
                Icons.cloud_download_outlined,
                color: AppColors.teal,
              ),
            ),
          ],
        ),
        body: body(context, routeModel.id!),
      ),
    );
  }

  Widget body(BuildContext context, int routeId) {
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
          if (state.routeSummary!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<MccCubit>(
                  context,
                ).getRouteSummary(routeId, month, year);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No deliveries for $curMonth"),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<MccCubit>(
                          context,
                        ).getRouteSummary(routeId, month, year);
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
                BlocProvider.of<MccCubit>(
                  context,
                ).getRouteSummary(routeId, month, year);
              },
              child: ListView.builder(
                itemCount: state.routeSummary!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: emptyCard(
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text("Quantity (kgs)"),
                                const Spacer(),
                                Text(
                                  (state.routeSummary![index].quantity!)
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Date"),
                                const Spacer(),
                                Text(state.routeSummary![index].date!),
                              ],
                            ),
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
                const Text("No route delivery data found"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<MccCubit>(
                      context,
                    ).getRouteSummary(routeId, month, year);
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
    return BlocConsumer<MccCubit, MccState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
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
                          const Text("Select Duration"),
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
                                  (monthCont.dropDownValue!.value).toString(),
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
                            (p0) => {year = yearCont.dropDownValue!.name},
                          ),
                          btn(
                            const Text(
                              "submit",
                              style: TextStyle(color: Colors.black),
                            ),
                            () async {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                final mccCubit = sl<MccCubit>();
                                mccCubit.getRouteSummary(
                                  widget.route.id!,
                                  month,
                                  year,
                                );
                                await mccCubit.getRouteSummary(
                                  widget.route.id!,
                                  month,
                                  year,
                                );
                                final homeCubit = sl<FohomeCubit>();
                                await homeCubit.getRouteSummaryReport(
                                  widget.route.id!,
                                  month,
                                  year,
                                  widget.curMonth,
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

  void saveFile(BuildContext context) async {
    final homeCubit = sl<FohomeCubit>();
    await homeCubit
        .getRouteSummaryReport(widget.route.id!, month, year, widget.curMonth)
        .then((value) {
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

  Widget downloadBtn(BuildContext context) {
    return BlocConsumer<FohomeCubit, FohomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            if (state.uiState == UIState.success) {
              BlocProvider.of<FohomeCubit>(
                context,
              ).saveFile(state.routeReport!, "${curMonth}_summary.xlsx");
            }
          },
          icon: const Icon(Icons.calendar_month),
        );
      },
    );
  }
}
