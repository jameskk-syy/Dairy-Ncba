import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/presentation/navigation/navigation_container.dart';
import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dairytenantapp/core/widgets/confirm_dialog.dart';
import 'package:dairytenantapp/core/widgets/requests_cards.dart';
import 'package:dairytenantapp/feature/totals/domain/model/feed_request_dto.dart';
import 'package:dairytenantapp/feature/totals/domain/model/product_category.dart';
import 'package:dairytenantapp/feature/totals/domain/model/products_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/data/dto/login_response_dto.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/cards.dart';
import '../../../../../core/widgets/farmer_info.dart';
import '../../../../../core/widgets/fields.dart';
import '../../cubits/cubit/feeds_requests_cubit.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/theme/colors.dart';
import '../../../../../core/di/injector_container.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../collections/presentation/blocs/cubit/farmer_details_cubit.dart';
import '../../../../farmers/domain/model/farmer_details_model.dart';
import '../../../../home/presentation/cubit/routes_cubit.dart';

class FeedsRequestsPage extends StatefulWidget {
  const FeedsRequestsPage({super.key});

  @override
  State<FeedsRequestsPage> createState() => _FeedsRequestsPageState();
}

class _FeedsRequestsPageState extends State<FeedsRequestsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> requestFormKey = GlobalKey();
  final TextEditingController farmerNoCont = TextEditingController();
  static bool farmerNoField = true;
  late FarmerDetailsEntityModel farmerDetails;
  late ProductsModel selectedProduct = const ProductsModel();
  List<ProductCategory> allCategories = [];
  List<DropDownValueModel> categories = [];
  List<ProductsModel> allProducts = [];
  List<DropDownValueModel> products = [];
  final SingleValueDropDownController categoryCont =
      SingleValueDropDownController();
  final SingleValueDropDownController productCont =
      SingleValueDropDownController();
  final TextEditingController quantityCont = TextEditingController();
  final TextEditingController commentsCont = TextEditingController();
  static bool productInfo = false;
  int mccId = 0;
  static bool noProducts = true;
  static bool loading = false;

  @override
  void initState() {
    super.initState();
    farmerNoField = true;
    loading = false;
    productInfo = false;
    allProducts;
    noProducts;
    farmerDetails = const FarmerDetailsEntityModel();
    dispatchGetRoutes(context);
    getProducts(context);
    getCategories(context);
    getPickUpLocations(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoutesCubit>(
          create:
              (context) =>
                  sl<RoutesCubit>()..getCollectorRoutes(getUserData().id!),
        ),
        BlocProvider(create: (context) => sl<FarmerDetailsCubit>()),
        BlocProvider(create: (context) => sl<FeedsRequestsCubit>()),
        BlocProvider(
          create:
              (context) =>
                  sl<RoutesCubit>()..getCollectorRoutes(getUserData().id!),
        ),
      ],
      child: BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            key: scaffoldKey,
            appBar: AppBar(title: const Text("Add Feeds Requests")),
            body:
                farmerNoField
                    ? searchFarmer()
                    : Column(
                      children: [
                        farmerInfo(farmerDetails),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0, right: 14),
                          child: Form(
                            key: requestFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dropdown(
                                  categories,
                                  categoryCont,
                                  "Select a category",
                                  "Category",
                                  (p0) {
                                    productCont.clearDropDown();
                                    if (categoryCont.dropDownValue != null) {
                                      final filteredProducts =
                                          allProducts.where((product) {
                                            return product.categoryId ==
                                                categoryCont
                                                    .dropDownValue!
                                                    .value;
                                          }).toList();

                                      setState(() {
                                        products =
                                            filteredProducts
                                                .map(
                                                  (product) =>
                                                      DropDownValueModel(
                                                        name: product.name!,
                                                        value: product.id!,
                                                      ),
                                                )
                                                .toList();
                                      });
                                    }
                                  },
                                ),
                                dropdown(
                                  products,
                                  productCont,
                                  "Select a product",
                                  "Products",
                                  (p0) {
                                    if (productCont.dropDownValue != null) {
                                      setState(() {
                                        productInfo = true;
                                      });
                                      selectedProduct = allProducts.firstWhere(
                                        (product) =>
                                            product.id ==
                                            productCont.dropDownValue!.value,
                                      );
                                    } else {
                                      setState(() {
                                        productInfo = false;
                                      });
                                    }
                                  },
                                ),
                                productInfo
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12.0,
                                      ),
                                      child: emptyCard(
                                        Row(
                                          children: [
                                            const Text("Stock Count"),
                                            const Spacer(),
                                            Text(
                                              (selectedProduct.stock)
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : const SizedBox(),
                                productInfo
                                    ? productPriceCard(
                                      (selectedProduct.salePrice).toString(),
                                      selectedProduct.description ?? "",
                                    )
                                    : const SizedBox(),
                                const SizedBox(height: 5),
                                noProducts
                                    ? const Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        "No products available",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                    : const SizedBox(),
                                const SizedBox(height: 7),
                                textField(
                                  "Quantity",
                                  TextInputType.number,
                                  Icons.numbers,
                                  quantityCont,
                                  "quantity is needed",
                                ),
                                txtField(
                                  "Comments",
                                  TextInputType.text,
                                  Icons.abc,
                                  commentsCont,
                                ),
                                submit(context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
          );
        },
      ),
    );
  }

  Widget submit(BuildContext context) {
    return BlocConsumer<FeedsRequestsCubit, FeedsRequestsState>(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          setState(() {
            loading = true;
          });
        } else if (state.uiState == UIState.error) {
          showSnackbar(
            context,
            state.error ?? 'An error occurred. Please try again',
          );
          setState(() {
            loading = false;
          });
        } else if (state.uiState == UIState.success) {
          setState(() {
            loading = false;
          });
          // Show success message
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationContainer(index: 2),
            ),
          );
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Success',
            desc: 'Request sent successfully',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        }
      },
      builder: (context, state) {
        return btn(
          loading
              ? const CircularProgressIndicator(color: Colors.black)
              : const Text("Submit", style: TextStyle(color: Colors.black)),
          () {
            if (requestFormKey.currentState!.validate()) {
              bool greater =
                  int.parse(quantityCont.text) > selectedProduct.stock!;
              if (!greater) {
                // submit request
                FeedRequestDto requestDto = FeedRequestDto(
                  farmerNo: farmerDetails.farmerNo,
                  farmerName: farmerDetails.username,
                  locationId: getLocationId(),
                  routeFk: farmerDetails.routeId,
                  productId: selectedProduct.id,
                  quantity: int.parse(quantityCont.text.trim()),
                  amount:
                      double.parse(quantityCont.text.trim()) *
                      selectedProduct.salePrice!,
                  price: (selectedProduct.salePrice)!.toDouble(),
                  productName: selectedProduct.name,
                  type: selectedProduct.type,
                  comments:
                      commentsCont.text.trim().isEmpty
                          ? ""
                          : commentsCont.text.trim(),
                );
                confirmDialog(
                  context,
                  "Product Request",
                  "Confirm the below details",
                  Column(
                    children: [
                      Text(
                        'Farmer: ${farmerDetails.username}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Farmer No: ${farmerDetails.farmerNo}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Product: ${selectedProduct.name}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Quantity: ${quantityCont.text}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  () {
                    setState(() {
                      loading = true;
                    });
                    context.read<FeedsRequestsCubit>().addFeedsRequest(
                      requestDto,
                    );
                  },
                );
              } else {
                showWarningAlert(
                  context,
                  "Warning",
                  "Quantity is more than stock",
                );
              }
            } else {
              showSnackbar(context, "All fields required");
            }
          },
        );
      },
    );
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
                    desc:
                        state.exception ??
                        'The farmer number you entered does not exist',
                    btnOkOnPress: () {
                      Navigator.pop(context);
                    },
                  ).show();
                } else if (state.uiState == UIState.loading) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                } else if (state.uiState == UIState.success) {
                  Navigator.pop(context);
                  farmerDetails = state.farmerDetailsModel!;

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
                        getFarmerDetails(context);
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: AppColors.lightColorScheme.onPrimary,
                      ),
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
    final farmerNumberString = farmerNoCont.text.trim();
    final farmerNumber = int.parse(farmerNumberString);
    BlocProvider.of<FarmerDetailsCubit>(
      context,
    ).getFarmerData(farmerNumber /*, farmerNumber*/);
  }

  void getMyRoutes(BuildContext context) {
    final farmerNumberString = farmerNoCont.text.trim();
    final farmerNumber = int.parse(farmerNumberString);
    BlocProvider.of<FarmerDetailsCubit>(
      context,
    ).getFarmerData(farmerNumber /*, farmerNumber*/);
  }

  void getPickUpLocations(BuildContext context) async {
    final cubit = sl<FeedsRequestsCubit>();

    await cubit.getCollectorPickupLocations(getUserData().id!).then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {
        mccId = state.locationId!;
        getProducts(context);
      }
    });
  }

  void dispatchGetRoutes(BuildContext context) async {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    final cubit = sl<RoutesCubit>();
    await cubit.getCollectorRoutes(collectorId!);
  }

  getProducts(BuildContext context) async {
    final cubit = sl<FeedsRequestsCubit>();
    print("mccid g etting  producr=ts $mccId");
    await cubit.getAllProducts(mccId).then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {
        allProducts =
            state.products!.where((product) => product.type == "Good").toList();

        if (allProducts.isNotEmpty) {
          setState(() {
            noProducts = false;
          });
        } else {
          setState(() {
            noProducts = true;
          });
        }
      }
    });
  }

  void getCategories(BuildContext context) async {
    print("mccid g etting  producr=ts $mccId");
    final cubit = sl<FeedsRequestsCubit>();
    await cubit.getAllCategories().then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {
        allCategories = state.productCategories ?? [];
        categories =
            allCategories.map((category) {
              return DropDownValueModel(
                name: category.name ?? "",
                value: category.id,
              );
            }).toList();
      }
    });
  }
}
