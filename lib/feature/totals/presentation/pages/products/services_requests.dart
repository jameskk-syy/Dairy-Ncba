import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../config/theme/colors.dart';
import '../../../../../core/di/injector_container.dart';
import '../../../../../core/utils/user_data.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/farmer_info.dart';
import '../../../../../core/widgets/fields.dart';
import '../../../../collections/presentation/blocs/cubit/farmer_details_cubit.dart';
import '../../../../farmers/domain/model/farmer_details_model.dart';
import '../../cubits/cubit/feeds_requests_cubit.dart';

class ServicesRequestsPage extends StatefulWidget {
  const ServicesRequestsPage({super.key});

  @override
  State<ServicesRequestsPage> createState() => _ServicesRequestsPageState();
}

class _ServicesRequestsPageState extends State<ServicesRequestsPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> requestFormKey = GlobalKey();
  TextEditingController farmerNoCont = TextEditingController();
  bool farmerNoField = true;
  late FarmerDetailsEntityModel farmerDetails;
  List<DropDownValueModel> products = [];
  late SingleValueDropDownController productCont;
  final TextEditingController quantityCont = TextEditingController();
  final TextEditingController commentsCont = TextEditingController();
  static bool loading = false;
  int mccId = 0;

  @override
  void initState() {
    super.initState();
    getPickUpLocations(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<FeedsRequestsCubit>())
        ],
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Services Requests"),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
              child: farmerNoField
                  ? searchFarmer()
                  : Column(
                      children: [
                        farmerInfo(farmerDetails),
                        const SizedBox(
                          height: 5,
                        ),
                        Form(
                          key: requestFormKey,
                          child: Column(
                            children: [
                              dropdown(products, productCont,
                                  "Select a Service", "Services", (p0) => null),
                              // textField(
                              //   "Quantity",
                              //   TextInputType.number,
                              //   Icons.numbers,
                              //   quantityCont,
                              //   "quantity is needed",
                              // ),
                              txtField(
                                "Comments",
                                TextInputType.text,
                                Icons.abc,
                                commentsCont,
                              ),
                              btn(
                                  loading
                                      ? const CircularProgressIndicator()
                                      : const Text("Submit"), () {
                                if (requestFormKey.currentState!.validate()) {
                                  // submit request
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "All fields required");
                                }
                              })
                            ],
                          ),
                        )
                      ],
                    ),
            )));
  }

  Widget searchFarmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: farmerNoCont,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Farmer Number to Continue',
                hintText: 'Farmer Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter farmer number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            BlocConsumer<FarmerDetailsCubit, FarmerDetailsCubitState>(
              listener: (context, state) {
                if (state.uiState == UIState.error) {
                  Navigator.pop(context);
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.scale,
                    title: 'Not Found',
                    desc: state.exception ??
                        'The farmer number you entered does not exist',
                    btnOkOnPress: () {
                      Navigator.pop(context);
                    },
                  ).show();
                } else if (state.uiState == UIState.loading) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                } else if (state.uiState == UIState.success) {
                  Navigator.pop(context);
                  farmerDetails = state.farmerDetailsModel!;

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const WeighPage()));

                  setState(() {
                    farmerNoField = false;
                  });
                }
              },
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightColorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            AppColors.lightColorScheme.primary.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        getFarmerDetails(context);
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: AppColors.lightColorScheme.onPrimary),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void getFarmerDetails(BuildContext context) {
    // final prefs = sl<SharedPreferences>();
    // final userData = prefs.getString("userData");
    // final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    // final collectorId = user.id;
    final farmerNumberString = farmerNoCont.text.trim();
    final farmerNumber = int.parse(farmerNumberString);
    BlocProvider.of<FarmerDetailsCubit>(context)
        .getFarmerDetails(farmerNumber /*, farmerNumber*/);
  }

  void getPickUpLocations(BuildContext context) async {
    final cubit = sl<FeedsRequestsCubit>();

    await cubit.getCollectorPickupLocations(getUserData().id!).then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {
        mccId = state.locationId!;
        getServices(context);
      }
    });
  }

  void getServices(BuildContext context) async {
    final cubit = sl<FeedsRequestsCubit>();

    await cubit.getAllProducts(mccId).then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {

        final serviceList = state.products!
            .where((product) => product.type == "Service")
            .toList();

        products = serviceList.map((product) {
          return DropDownValueModel(
              name: product.name ?? "", value: product.id);
        }).toList();
      }
    });
  }
}
