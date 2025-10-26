import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/core/widgets/button.dart';
import 'package:dairytenantapp/feature/fieldofficer/inventory/ui/allocate_page.dart';
import 'package:dairytenantapp/feature/fieldofficer/mccs/cubit/mcc_cubit.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/domain/models/pickup_location_model.dart';
import '../../../../core/widgets/fields.dart';

class ProductsSource extends StatefulWidget {
  final PickupLocationEntityModel mccModel;
  const ProductsSource({super.key, required this.mccModel});

  @override
  State<ProductsSource> createState() => _ProductsSourceState();
}

class _ProductsSourceState extends State<ProductsSource> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late PickupLocationEntityModel selectedMcc = PickupLocationEntityModel();
  final SingleValueDropDownController mccController =
      SingleValueDropDownController();
  List<PickupLocationEntityModel> mccList = [];
  static bool visible = true;

  @override
  void initState() {
    super.initState();
    visible = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MccCubit>()..getPickupLocations(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Products Source")),
        body: mccOptions(),
      ),
    );
  }

  Widget mccOptions() {
    return BlocConsumer<MccCubit, MccState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.error) {
          return Center(
            child: Column(
              children: [
                const Text("Unable to get centers"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<MccCubit>(context).getPickupLocations();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        } else if (state.uiState == UIState.success) {
          mccList = state.pickUpLocationModel!;
          if (visible) {
            return options();
          } else {
            return mccDropDown(context);
          }
        } else {
          return Center(
            child: Column(
              children: [
                const Text("try again"),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<MccCubit>(context).getPickupLocations();
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

  Widget options() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select products source"),
          const SizedBox(height: 5),
          btn(
            const Text(
              "Main Inventory",
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AllocatePage(
                        mccModel: widget.mccModel,
                        sourceMccModel: widget.mccModel,
                        source: "inventory",
                      ),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "or",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          btn(
            const Text(
              "Another Mcc",
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            () {
              setState(() {
                visible = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget mccDropDown(BuildContext context) {
    return BlocConsumer<MccCubit, MccState>(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state.uiState == UIState.success) {
          // Navigator.pop(context);
        } else if (state.uiState == UIState.error) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 15,
            right: 15,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                dropdown(
                  mccList
                      .map(
                        (mcc) => DropDownValueModel(
                          name: mcc.name ?? "",
                          value: mcc.id ?? "",
                        ),
                      )
                      .toList(),
                  mccController,
                  "collection center required",
                  "select center",
                  (p0) {
                    if (mccController.dropDownValue != null) {
                      selectedMcc = state.pickUpLocationModel!.firstWhere(
                        (mcc) => mcc.id! == mccController.dropDownValue!.value,
                      );
                    }
                  },
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightColorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightColorScheme.primary.withOpacity(
                          0.2,
                        ),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          // mccField = false;
                        });
                        if (widget.mccModel.id == selectedMcc.id) {
                          showWarningAlert(
                            context,
                            "Transfer error",
                            "Can't transfer from to same ${selectedMcc.name}. Choose diff mcc",
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AllocatePage(
                                  mccModel: widget.mccModel,
                                  mccId: selectedMcc.id!,
                                  source: "mcc",
                                  sourceMccModel: selectedMcc,
                                ),
                          ),
                        );
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.scale,
                          title: 'Mcc Required',
                          desc: state.exception ?? 'Milk center is required',
                          btnOkOnPress: () {
                            Navigator.pop(context);
                          },
                        ).show();
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: AppColors.lightColorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
