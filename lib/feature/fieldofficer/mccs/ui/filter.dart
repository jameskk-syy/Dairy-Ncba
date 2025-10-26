import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/feature/fieldofficer/mccs/ui/route_summary.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/models/routes_model.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/fields.dart';

class RouteSummaryFilter extends StatefulWidget {
  final RoutesEntityModel route;
  const RouteSummaryFilter({super.key, required this.route});

  @override
  State<RouteSummaryFilter> createState() => _RouteSummaryFilterState();
}

class _RouteSummaryFilterState extends State<RouteSummaryFilter> {
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
  }

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
                          (year) => DropDownValueModel(name: year, value: year),
                        )
                        .toList(),
                    yearCont,
                    "year is needed",
                    "year",
                    (p0) => {year = yearCont.dropDownValue!.name},
                  ),
                  btn(
                    const Text("submit", style: TextStyle(color: Colors.black)),
                    () async {
                      if (formKey.currentState!.validate()) {
                        yearCont.clearDropDown();
                        monthCont.clearDropDown();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RouteSummary(
                                  route: routeModel,
                                  month: month,
                                  year: year,
                                  curMonth: curMonth,
                                ),
                          ),
                        );
                      } else {
                        showSnackbar(context, "all fields required");
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
