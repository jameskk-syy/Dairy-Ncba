import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/core/widgets/button.dart';
import 'package:dairytenantapp/feature/fieldofficer/home/cubit/fohome_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector_container.dart';

class StatementDownload extends StatefulWidget {
  final int farmerNo;
  const StatementDownload({super.key, required this.farmerNo});

  @override
  State<StatementDownload> createState() => _StatementDownloadState();
}

class _StatementDownloadState extends State<StatementDownload> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController date = TextEditingController();
  static DateTime? from;
  static DateTime? to;
  static bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FohomeCubit>(),
      child: BlocConsumer<FohomeCubit, FohomeState>(
        listener: (context, state) {
          if (state.uiState == UIState.loading) {
            setState(() {
              loading = true;
            });
          } else if (state.uiState == UIState.error) {
            loading = false;
            // Navigator.pop(context);
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: "Error",
              desc: "Unable to generate statement",
              btnOkOnPress: () {
                Navigator.pop(context);
              },
            ).show();
          } else if (state.uiState == UIState.success) {
            loading = false;
            // Navigator.pop(context);
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: "Success",
              desc: "Statement retrieved successfully",
              btnOkOnPress: () {
                Navigator.pop(context);
              },
            ).show();
            BlocProvider.of<FohomeCubit>(
              context,
            ).saveFile(state.statement!, "statement_${widget.farmerNo}.pdf");
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    'Enter statement period',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: date,
                    decoration: InputDecoration(
                      label: const Text("Date Range"),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final dateRange = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                          );
                          from = dateRange!.start;
                          to = dateRange.end;
                          date.text =
                              "${formatDate(from!)} to ${formatDate(to!)}";
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Spacer(),
                  btn(
                    loading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                          "get statement",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                    () {
                      BlocProvider.of<FohomeCubit>(context).getStatement(
                        widget.farmerNo,
                        formatDate(from!),
                        formatDate(to!),
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
