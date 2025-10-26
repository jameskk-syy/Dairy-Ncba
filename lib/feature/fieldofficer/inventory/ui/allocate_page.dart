import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/domain/models/pickup_location_model.dart';
import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/core/widgets/button.dart';
import 'package:dairytenantapp/core/widgets/cards.dart';
import 'package:dairytenantapp/core/widgets/confirm_dialog.dart';
import 'package:dairytenantapp/core/widgets/fields.dart';
import 'package:dairytenantapp/feature/fieldofficer/inventory/cubit/inventory_cubit.dart';
import 'package:dairytenantapp/feature/fieldofficer/mccs/cubit/mcc_cubit.dart';
import 'package:dairytenantapp/feature/totals/domain/model/products_model.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector_container.dart';
import '../../../totals/presentation/cubits/cubit/feeds_requests_cubit.dart';

class AllocatePage extends StatefulWidget {
  final PickupLocationEntityModel mccModel;
  final PickupLocationEntityModel sourceMccModel;
  final String source;
  final int mccId;
  const AllocatePage({
    super.key,
    required this.mccModel,
    this.mccId = 0,
    required this.sourceMccModel,
    required this.source,
  });

  @override
  State<AllocatePage> createState() => _AllocatePageState();
}

class _AllocatePageState extends State<AllocatePage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> allocateForm = GlobalKey();
  late PickupLocationEntityModel selectedMcc = PickupLocationEntityModel();
  late PickupLocationEntityModel sourceMcc = PickupLocationEntityModel();
  final SingleValueDropDownController mccController =
      SingleValueDropDownController();
  List<PickupLocationEntityModel> mccList = [];
  // static bool mccField = true;
  static bool noProducts = true;

  final TextEditingController stockCont = TextEditingController();

  List<DropDownValueModel> categories = [];
  final SingleValueDropDownController categoryCont =
      SingleValueDropDownController();

  late ProductsModel selectedProduct = const ProductsModel();
  List<ProductsModel> allProducts = [];
  List<DropDownValueModel> products = [];
  List<DropDownValueModel> catProducts = [];
  final SingleValueDropDownController productCont =
      SingleValueDropDownController();
  static bool productInfo = false;
  static bool loading = false;
  String source = "inventory";

  @override
  void initState() {
    super.initState();
    getCategories(context);
    getProducts(context, widget.source, widget.mccId);
    productInfo = false;
    noProducts;
    loading;
    selectedMcc = widget.mccModel;
    source = widget.source;
    sourceMcc = widget.sourceMccModel;
    // mccField = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<InventoryCubit>()),
        BlocProvider(create: (context) => sl<MccCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Allocate Feeds")),
        body: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
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
            desc: state.customResponse!.message ?? "Allocation Successful",
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              emptyCard(
                Text(
                  selectedMcc.name ?? "",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Form(
                key: allocateForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dropdown(
                      categories,
                      categoryCont,
                      "category is needed",
                      "select product category",
                      (p0) {
                        productCont.clearDropDown();
                        if (allProducts.isEmpty) {
                          return;
                        }
                        if (categoryCont.dropDownValue != null) {
                          final filteredProducts =
                              allProducts.where((product) {
                                return product.categoryId ==
                                    categoryCont.dropDownValue!.value;
                              }).toList();

                          setState(() {
                            catProducts =
                                filteredProducts
                                    .map(
                                      (product) => DropDownValueModel(
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
                      catProducts,
                      productCont,
                      "product is required",
                      "select a product",
                      (p0) {
                        if (productCont.dropDownValue != null) {
                          setState(() {
                            productInfo = true;
                          });
                          selectedProduct = allProducts.firstWhere(
                            (product) =>
                                product.id == productCont.dropDownValue!.value,
                          );
                        } else {
                          setState(() {
                            productInfo = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    productInfo
                        ? emptyCard(
                          Row(
                            children: [
                              const Text("Stock Count"),
                              const Spacer(),
                              Text((selectedProduct.stock).toString()),
                            ],
                          ),
                        )
                        : const SizedBox(),
                    const SizedBox(height: 10),
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
                    textField(
                      "Quantity",
                      TextInputType.number,
                      Icons.numbers,
                      stockCont,
                      "number of items required",
                    ),
                    const SizedBox(height: 5),
                    btn(
                      Text(
                        source == "inventory"
                            ? "Allocate Feeds"
                            : "Stock Transfer",
                        style: const TextStyle(color: Colors.black),
                      ),
                      () {
                        if (double.parse(stockCont.text.trim()) <= 0) {
                          showWarningAlert(
                            context,
                            "Stock Alert",
                            "Quantity cannot be 0 or less",
                          );
                          return;
                        }

                        if (allocateForm.currentState!.validate()) {
                          confirmDialog(
                            context,
                            source == "inventory"
                                ? "Allocation Confirmation"
                                : "Transfer Confirmation",
                            source == "inventory"
                                ? "Do you want to allocate this product?"
                                : "Confirm transfer from ${sourceMcc.name}",
                            Column(
                              children: [
                                Text(
                                  'Milk Center: ${selectedMcc.name}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Product: ${selectedProduct.name}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Quantity: ${stockCont.text.trim()}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            () {
                              submit(context);
                            },
                          );
                        } else {
                          showSnackbar(context, "All fields are required");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  submit(BuildContext context) {
    if (widget.mccId == selectedMcc.id) {
      showWarningAlert(
        context,
        "Warning",
        "Cannot stransfer stock to the same center",
      );
      return;
    }
    if (allocateForm.currentState!.validate()) {
      if (int.parse(stockCont.text.trim()) > selectedProduct.stock!) {
        showSnackbar(context, "quantity exceeds available stock");
      } else {
        if (source == "inventory") {
          BlocProvider.of<InventoryCubit>(context).addFeedsRequest(
            selectedProduct.id!,
            selectedMcc.id!,
            int.parse(stockCont.text.trim()),
          );
        } else {
          BlocProvider.of<InventoryCubit>(context).transferStock(
            widget.mccId,
            selectedMcc.id!,
            selectedProduct.id!,
            int.parse(stockCont.text.trim()),
          );
        }
      }
    }
  }

  void getPickUpLocations() {
    BlocProvider.of<MccCubit>(context).getPickupLocations();
  }

  void getProducts(BuildContext context, String source, int mccId) async {
    loading = true;
    final cubit = sl<InventoryCubit>();

    if (source == "inventory") {
      await cubit.getAllProducts().then((value) {
        final state = cubit.state;

        if (state.uiState == UIState.success) {
          final availableProducts = state.products ?? [];
          allProducts =
              availableProducts
                  .where((product) => product.type == "Good")
                  .toList();
          if (allProducts.isNotEmpty) {
            setState(() {
              noProducts = false;
              products =
                  state.products!.map((product) {
                    return DropDownValueModel(
                      name: product.name ?? "",
                      value: product.id,
                    );
                  }).toList();
            });
          } else {
            setState(() {
              noProducts = true;
            });
          }
        }
      });
    } else {
      final feedsCubit = sl<FeedsRequestsCubit>();
      await feedsCubit.getAllProducts(mccId).then((value) {
        final state = feedsCubit.state;

        if (state.uiState == UIState.success) {
          final availableProducts = state.products ?? [];
          allProducts =
              availableProducts
                  .where((product) => product.type == "Good")
                  .toList();
          if (allProducts.isNotEmpty) {
            setState(() {
              noProducts = false;
            });
            products =
                state.products!.map((product) {
                  return DropDownValueModel(
                    name: product.name ?? "",
                    value: product.id,
                  );
                }).toList();
          } else {
            setState(() {
              noProducts = true;
            });
          }
        }
      });
    }
  }

  void getCategories(BuildContext context) async {
    final cubit = sl<FeedsRequestsCubit>();

    await cubit.getAllCategories().then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {
        final allCategories = state.productCategories ?? [];
        setState(() {
          categories =
              allCategories.map((category) {
                return DropDownValueModel(
                  name: category.name ?? "",
                  value: category.id,
                );
              }).toList();
        });
      }
    });
  }
}
