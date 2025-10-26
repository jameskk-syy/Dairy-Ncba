import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/feature/collections/presentation/pages/qc_page.dart';
import '../../../../core/presentation/navigation/navigation_container.dart';
import '../../../../core/utils/user_data.dart';
import '../../../../core/utils/utils.dart';
import '../../../../feature/collections/presentation/blocs/cubit/location_cubit.dart';
import '../../../../feature/collections/presentation/pages/weigh_page.dart';
import '../../../../feature/home/presentation/cubit/routes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/add_collection_dto.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/domain/models/can_response_model.dart';
import '../../../../core/presentation/widgets/dialogs/snackbars.dart';
import '../../../farmers/domain/model/farmer_details_model.dart';
import '../blocs/add_collection_cubit.dart';
import '../blocs/cubit/can_cubit.dart';
import '../blocs/cubit/farmer_details_cubit.dart';

class AddCollectionPage extends StatefulWidget {
  // final FarmerDetailsModel farmerDetailsModel;
  final bool? visible;

  const AddCollectionPage({
    super.key,
    /*required this.farmerDetailsModel*/
    this.visible = true,
  });

  @override
  State<AddCollectionPage> createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends State<AddCollectionPage> {
  final TextEditingController quantityTextFieldController =
      TextEditingController();
  final TextEditingController quantityTextFieldCan = TextEditingController();
  final FocusNode focusNodeQuantity = FocusNode();
  final FocusNode focusNodeCan = FocusNode();
  static List<CanResponseEntityModel> cans = [];
  static String? selectedCan;
  static String? selectedCanId;
  final session = getSession();
  final sessionTextFieldController = TextEditingController(text: getSession());
  final farmerNumberTextFieldController = TextEditingController();
  static double? latitude;
  static double? longitude;
  final formKey = GlobalKey<FormState>();
  final farmerDetailFormKey = GlobalKey<FormState>();
  static int? selectedRouteId;
  static int? farmerId;
  static bool? boolIsFarmerNumberContainerVisible;
  late FarmerDetailsEntityModel farmerDetails;

  // New variables for farmer dropdown functionality
  List<int> availableFarmerNumbers = [];
  bool showDropdown = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  //weight deduction.
  int activeWeightBtnIndex = -1;
  final List<double> deductWeights = [0.2, 0.3, 0.4, 0.5];
  double selectedWeight = 0.0;

  List<double> weights = [];
  double totalWeight = 0.0;

  @override
  void initState() {
    super.initState();
    boolIsFarmerNumberContainerVisible = widget.visible;
    farmerDetails = const FarmerDetailsEntityModel();
    setInitialWeight();
    // Load available farmer numbers when the widget initializes
    loadAvailableFarmerNumbers();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  // Method to load available farmer numbers
  // You might need to modify this based on your actual data source
  void loadAvailableFarmerNumbers() {
    // This is a placeholder - replace with your actual method to get farmer numbers
    // You might want to add a method to your FarmerDetailsCubit to get all farmer numbers
    setState(() {
      // Example farmer numbers - replace with actual data from your backend/database
      availableFarmerNumbers = [1235, 6890, 1111, 2222, 3333, 4444, 5555];
    });
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      showDropdown = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      showDropdown = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width - 32, // Account for horizontal margin
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(
                0.0,
                60.0,
              ), // Adjust based on your text field height
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: availableFarmerNumbers.length,
                    itemBuilder: (context, index) {
                      final farmerNumber = availableFarmerNumbers[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          farmerNumber.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          farmerNumberTextFieldController.text =
                              farmerNumber.toString();
                          _removeOverlay();
                          // Automatically proceed to get farmer details
                          if (farmerDetailFormKey.currentState!.validate()) {
                            dispatchGetFarmerDetails(context);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
    );
  }

  List<int> _getFilteredFarmerNumbers(String query) {
    if (query.isEmpty) {
      return availableFarmerNumbers;
    }
    return availableFarmerNumbers
        .where((number) => number.toString().contains(query))
        .toList();
  }

  setInitialWeight() {
    if (userRole() == "TRANSPORTER") {
      quantityTextFieldController.text = totalWeight.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CanCubit>()..getCanLists()),
        BlocProvider(
          create: (context) => sl<LocationCubit>()..getCurrentLocation(),
        ),
        BlocProvider(create: (context) => sl<AddCollectionCubit>()),
        BlocProvider<FarmerDetailsCubit>(
          create: (_) => sl<FarmerDetailsCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Record New Collection'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavigationContainer(),
                ),
                (route) => false,
              );
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            // Hide dropdown when tapping outside
            if (showDropdown) {
              _removeOverlay();
            }
          },
          child: SingleChildScrollView(
            child:
                boolIsFarmerNumberContainerVisible == true
                    ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: MediaQuery.of(context).size.height,
                      child: Form(
                        key: farmerDetailFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            CompositedTransformTarget(
                              link: _layerLink,
                              child: TextFormField(
                                controller: farmerNumberTextFieldController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Enter Farmer Number to Continue',
                                  hintText: 'Farmer Number',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      showDropdown
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                    ),
                                    onPressed: () {
                                      if (showDropdown) {
                                        _removeOverlay();
                                      } else {
                                        _showDropdown();
                                      }
                                    },
                                  ),
                                ),
                                onTap: () {
                                  if (!showDropdown) {
                                    _showDropdown();
                                  }
                                },
                                onChanged: (value) {
                                  if (showDropdown) {
                                    _removeOverlay();
                                    if (value.isNotEmpty) {
                                      final filtered =
                                          _getFilteredFarmerNumbers(value);
                                      if (filtered.isNotEmpty) {
                                        setState(() {
                                          availableFarmerNumbers = filtered;
                                        });
                                        _showDropdown();
                                      }
                                    } else {
                                      loadAvailableFarmerNumbers();
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter farmer number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            BlocConsumer<
                              FarmerDetailsCubit,
                              FarmerDetailsCubitState
                            >(
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
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                } else if (state.uiState == UIState.success) {
                                  Navigator.pop(context);
                                  farmerDetails = state.farmerDetailsModel!;

                                  setState(() {
                                    boolIsFarmerNumberContainerVisible = false;
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
                                        color: AppColors
                                            .lightColorScheme
                                            .primary
                                            .withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (farmerDetailFormKey.currentState!
                                          .validate()) {
                                        dispatchGetFarmerDetails(context);
                                      }
                                    },
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                        color:
                                            AppColors
                                                .lightColorScheme
                                                .onPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    : Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 220,
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors
                                            .lightColorScheme
                                            .primary
                                            .withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/farmer.png',
                                          width: 150,
                                          height: 95,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Farmer Name:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              farmerDetails.username ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Farmer No:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              farmerDetails.farmerNo.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Route:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              farmerDetails.route ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          userRole() == "TRANSPORTER"
                              ? weightsList()
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          buildContainer(context),
                          buildSubmitButton(context),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    return BlocConsumer<AddCollectionCubit, AddCollectionState>(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state.uiState == UIState.error) {
          //Show error message
          // final log = Logger();

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Error',
            desc: state.exception ?? 'An error occurred. Please try again',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (state.uiState == UIState.success) {
          //Show success message
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Success',
            desc: 'Collection recorded successfully',
            btnOkOnPress: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => Receipt(
              //             collectionNumber:
              //                 state.collectionResponse!.collectionNumber ??
              //                     "")));
            },
          ).show();
        }
      },
      builder: (context, state) {
        return BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            //Check if location state is success
            if (state.position != null) {
              //Show success message
              latitude = state.position!.latitude;
              longitude = state.position!.longitude;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Your Location has been saved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state.errorMessage != null) {
              //Show error message
              final log = Logger();
              log.e(state.errorMessage);

              Fluttertoast.showToast(
                msg: 'Device offline! Cannot get location',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          builder: (context, state) {
            return MaterialButton(
              minWidth: double.infinity,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                if (double.parse(quantityTextFieldController.text.trim()) <=
                    0) {
                  showWarningAlert(
                    context,
                    "Quantity Alert",
                    "Quantity cannot be 0 or less",
                  );
                  return;
                }
                if (formKey.currentState!.validate()) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.scale,
                    title: 'Confirmation',
                    body: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Are you sure you want to submit this collection?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
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
                            'Quantity: ${quantityTextFieldController.text}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Session: ${sessionTextFieldController.text}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    btnOk: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // DateTime now = DateTime.now();
                        String formattedDateTime = DateFormat(
                          "yyyy-MM-ddTHH:mm:ss.SSS'Z'",
                        ).format(DateTime.now());
                        // DateFormat("yyyy-MM-ddHH:mm:ss.SSS'EAT'")
                        //     .format(now.toLocal());
                        /*// Create a formatter for EAT timezone
                        DateFormat eatFormat = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_EAT');
                        // Format the date in the specified timezone and locale
                        String formattedDateTime = eatFormat.format(now);*/

                        final collection = AddCollectionDto(
                          farmerNumber: farmerDetails.farmerNo!,
                          //canNumber: selectedCanId!,
                          status: 'N',
                          updatedStatus: 'N',
                          paymentStatus: 'N',
                          collectorId: collectorId!,
                          quantity: double.parse(
                            quantityTextFieldController.text,
                          ),
                          latitude: latitude.toString(),
                          longitude: longitude.toString(),
                          routeId: farmerDetails.routeId!,
                          session: sessionTextFieldController.text.trim(),
                          event: "Collection",
                          collectionDate: formattedDateTime,
                        );
                        BlocProvider.of<AddCollectionCubit>(
                          context,
                        ).addCollection(collection);
                      },
                      color: AppColors.lightColorScheme.primary,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: AppColors.lightColorScheme.onPrimary,
                        ),
                      ),
                    ),
                    btnCancel: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: AppColors.lightColorScheme.error,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.lightColorScheme.onError,
                        ),
                      ),
                    ),
                  ).show();
                }
              },
              color: AppColors.lightColorScheme.primary,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            );
          },
        );
      },
    );
  }

  Widget buildContainer(BuildContext context) {
    return BlocConsumer<CanCubit, CanState>(
      listener: (context, state) {
        if (state.uiState == UIState.success) {
          final cansList = state.cansModel!.entity!;
          cans = cansList;
        } else if (state.uiState == UIState.error) {
          cans = [];
        }
      },
      builder: (context, state) {
        return Container(
          height: 280,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightColorScheme.primary.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  userRole() == "TRANSPORTER"
                      ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.fadeTeal,
                              ),
                              onPressed: () {
                                showWeightBottomSheet();
                              },
                              child: const Text(
                                'Measure Weight',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.fadeTeal,
                              ),
                              onPressed: () {
                                showQCBottomSheet();
                              },
                              child: const Text(
                                'Check Quality',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox(),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Quantity(Ltrs)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            focusNode: focusNodeQuantity,
                            controller: quantityTextFieldController,
                            keyboardType: TextInputType.number,
                            readOnly:
                                userRole() == "TRANSPORTER" ? true : false,
                            style: const TextStyle(fontSize: 14.0),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter quantity';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Session.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: sessionTextFieldController,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            style: const TextStyle(fontSize: 14.0),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter session';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showWeightBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: const WeighPage(),
        );
      },
    );

    if (result != null) {
      setState(() {
        addWeight(result.toString());
      });
    }
  }

  void showQCBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: const QualityPage(),
        );
      },
    );

    if (result != null) {
      setState(() {
        addWeight(result.toString());
      });
    }
  }

  Widget weightsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width / 1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightColorScheme.primary.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text("Weights"),
          ...weights.map(
            (weight) => weightRow(weights.indexOf(weight), weight),
          ),
          // ListView.builder(
          //   itemCount: weights.length,
          //   itemBuilder: (context, index) {
          //     return weightRow(index, weights[index]);
          //   },
          // )
        ],
      ),
    );
  }

  Widget weightRow(int index, double weight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('w${index + 1}'),
          const SizedBox(width: 4),
          Text(weight.toString()),
          const Spacer(),
          IconButton(
            onPressed: () => removeWeight(index),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void addWeight(String weight) {
    setState(() {
      double weightValue = double.parse(weight);
      weights.add(weightValue);
      totalWeight = totalWeight += weightValue;
      quantityTextFieldController.text = totalWeight.toStringAsFixed(2);
    });
  }

  void removeWeight(int index) {
    setState(() {
      totalWeight -= weights[index];
      weights.removeAt(index);
      quantityTextFieldController.text = totalWeight.toStringAsFixed(2);
    });
  }

  void dispatchGetFarmerDetails(BuildContext context) {
    // final prefs = sl<SharedPreferences>();
    // final userData = prefs.getString("userData");
    // final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    // final collectorId = user.id;
    final farmerNumberString = farmerNumberTextFieldController.text.trim();
    final farmerNumber = int.parse(farmerNumberString);
    print("farmerno $farmerNumber");
    BlocProvider.of<FarmerDetailsCubit>(
      context,
    ).getFarmerData(farmerNumber /*, farmerNumber*/);
  }

  void dispatchGetRoutes(BuildContext context) {
    BlocProvider.of<RoutesCubit>(context).getCollectorRoutes(getUserData().id!);
  }

  void activeWeightButton(int index) {
    setState(() {
      activeWeightBtnIndex = index;
    });
  }
}
