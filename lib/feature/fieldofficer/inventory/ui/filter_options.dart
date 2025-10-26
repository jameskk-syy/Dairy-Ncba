import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/feature/fieldofficer/inventory/ui/filtered_requests.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/fields.dart';

class AllocationsFilter extends StatefulWidget {
  final int locationId;
  const AllocationsFilter({super.key, required this.locationId});

  @override
  State<AllocationsFilter> createState() => _AllocationsFilterState();
}

class _AllocationsFilterState extends State<AllocationsFilter> {
  GlobalKey<FormState> formKey = GlobalKey();
  int month = 1;
  String year = "";
  String curMonth = "";
  SingleValueDropDownController monthCont = SingleValueDropDownController();
  SingleValueDropDownController yearCont = SingleValueDropDownController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter Options")),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          children: [
            Form(
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
                          (year) => DropDownValueModel(name: year, value: year),
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
                    const Text("submit", style: TextStyle(color: Colors.black)),
                    () async {
                      if (formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FilteredRequests(
                                  locationId: widget.locationId,
                                  month: month,
                                  year: year,
                                  curMonth: curMonth,
                                ),
                          ),
                        );
                      } else {
                        showSnackbar(context, "All fields required");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
