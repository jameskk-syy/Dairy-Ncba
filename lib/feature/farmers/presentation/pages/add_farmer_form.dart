import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/domain/models/counties_model.dart';
import 'package:dairytenantapp/core/domain/models/sub_counties_model.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/farmers/presentation/blocs/add_farmer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/domain/models/collector_routes_model.dart';
import '../../../../core/domain/models/pickup_location_model.dart';
import '../../../home/presentation/cubit/routes_cubit.dart';
import '../../domain/model/onboard_farmer_details.dart';
import '../../domain/repository/farmers_repository.dart';

class AddFarmerForm extends StatefulWidget {
  const AddFarmerForm({super.key});

  @override
  State<AddFarmerForm> createState() => _AddFarmerFormState();
}

class _AddFarmerFormState extends State<AddFarmerForm> {
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final nikIdNumberController = TextEditingController();
  final nikRelationshipController = TextEditingController();
  final nikNameController = TextEditingController();
  final nikTelController = TextEditingController();
  final nikPhoneController = TextEditingController();
  final nikAddressController = TextEditingController();
  final phoneNoController = TextEditingController();
  final altPhoneController = TextEditingController();

  //final noOfCowsController = TextEditingController();
  final categoryController = TextEditingController();
  final genderController = TextEditingController();

  final countyController = TextEditingController();
  bool isLoading = false;

  //final subcountyController = TextEditingController();
  final wardController = TextEditingController();
  final locationController = TextEditingController();
  final sublocationController = TextEditingController();
  final villageController = TextEditingController();
  final pickupLocationController = TextEditingController();
  final routeController = TextEditingController();
  final subCountyTextController = TextEditingController();

  //final bankNameController = TextEditingController();
  final bankAccController = TextEditingController();
  final bankAccNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final alternativeController = TextEditingController();
  final otherPaymentDetailsController = TextEditingController();
  final subCountyController = TextEditingController();
  final mpesaNoController = TextEditingController();
  final altMpesaTextInputController = TextEditingController();

  final GlobalKey<FormState> detailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> centerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> paymentsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> nextOfKinFormKey = GlobalKey<FormState>();

  final FarmersRepository farmersRepository = sl<FarmersRepository>();

  String? selectedCounty;

  String? selectedSubCounty;
  String? selectedWard;
  String? selectedPickUpCenter;
  String? selectedRoute;

  String? selectedGender;
  String? selectedCategory;
  int? pickUpCenterId;
  String? selectedBankName;
  String? selectedChoice;
  String? selectedPaymentMeans;
  String? selectedPaymentFreq;
  String? selectedTransportMeans;
  String? selectedPaymentDate;
  String? altMeansOfPayment;
  String? altPaymentMeans;

  int? wardId;
  int? routeId;
  int? subCountyId;
  int? countyId;

  List<String> genderDropdownItems = ['Female', 'Male'];

  List<String> memberCategoryDropdownItems = [
    // 'SPECIAL',
    'STANDARD',
  ];

  List<String> altDropdownItems = ['Yes', 'No'];

  List<String> paymentMeansDropdownItems = ['Bank', 'Sacco', 'Mpesa'];
  List<String> altPaymentMeansDropdownItems = ['Mpesa'];

  List<String> bankNameDropdownItems = [
    'Equity Bank',
    'KCB',
    'Cooperative Bank',
    'Family Bank',
    'Barclays Bank',
    'Standard Chartered Bank',
    'Stanbic Bank',
    'Kingdom Bank',
    'GoodWays Sacco',
    'Bingwa Sacco',
    'Fortune Sacco',
    'Ollin Sacco',
  ];

  List<String> saccoNameDropdownItems = [
    'GoodWays Sacco',
    'Bingwa Sacco',
    'Fortune Sacco',
    'Ollin Sacco',
  ];

  List<String> paymentFreqDropdownItems = ['Daily', 'Monthly', 'Weekly'];

  List<String> transportMeansDropdownItems = ['Truck', 'Motorbike', 'Bicycle'];

  List<String> paymentDateDropdownItems = [
    for (int i = 1; i <= 31; i++) i.toString(),
  ];

  int activeCurrentStep = 0;
  bool isPaymentModeMpesa = false;
  bool hasAlternativePaymentMeans = false;

  BuildContext? blocContext;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AddFarmerCubit>()),
        BlocProvider(create: (context) => sl<RoutesCubit>()),
      ],
      child: BlocConsumer<AddFarmerCubit, AddFarmerState>(
        listener: (context, state) {
          if (state.uiState == UIState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.exception!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add Farmers"),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Stepper(
              currentStep: activeCurrentStep,
              onStepContinue: () async {
                if (activeCurrentStep < (4 - 1)) {
                  if (activeCurrentStep == 0) {
                    if (detailsFormKey.currentState!.validate()) {
                      setState(() {
                        activeCurrentStep += 1;
                      });
                    }
                  } else if (activeCurrentStep == 1) {
                    if (centerFormKey.currentState!.validate()) {
                      setState(() {
                        activeCurrentStep += 1;
                      });
                    }
                  } else if (activeCurrentStep == 2) {
                    if (paymentsFormKey.currentState!.validate()) {
                      setState(() {
                        activeCurrentStep += 1;
                      });
                    }
                  }
                  /*else if (activeCurrentStep == 3) {
                      if (transportFormKey.currentState!.validate()) {
                        setState(() {
                          activeCurrentStep += 1;
                          final log  =Logger();
                          log.i('$activeCurrentStep');
                        });
                      }
                    }*/
                  else {
                    setState(() {
                      activeCurrentStep == activeCurrentStep;
                    });
                  }
                } else {
                  if (nextOfKinFormKey.currentState!.validate()) {
                    FarmerOnboardRequestModel farmer =
                        FarmerOnboardRequestModel(
                          firstName: firstNameController.text.trim(),
                          lastName: secondNameController.text.trim(),
                          idNo: idNumberController.text.trim(),
                          mobileNumber: phoneNoController.text,
                          countyFk: countyId!,
                          subcountyFk: subCountyId!,
                          wardFk: null,
                          routeFk: routeId!,
                          location: locationController.text.trim(),
                          gender: selectedGender!,
                          memberType: selectedCategory!,
                          //paymentDate: int.parse(selectedPaymentDate!),
                          //paymentFreequency: selectedPaymentFreq!,
                          paymentMode: selectedPaymentMeans!,
                          //transportMeans: selectedTransportMeans!,
                          subLocation: sublocationController.text.trim(),
                          bankDetails: BankDetailsModel(
                            bankName: selectedBankName ?? '',
                            accountName: bankAccNameController.text.trim(),
                            accountNumber: bankAccController.text.trim(),
                            branch: branchNameController.text.trim(),
                            otherMeansDetails:
                                otherPaymentDetailsController.text.trim(),
                            otherMeans:
                                hasAlternativePaymentMeans
                                    ? altPaymentMeans
                                    : null,
                          ),
                          nextOfKin: NextOfKinModel(
                            address: nikAddressController.text.trim(),
                            tel: nikPhoneController.text.trim(),
                            idNo: nikIdNumberController.text.trim(),
                            name: nikNameController.text.trim(),
                            relationship: nikRelationshipController.text.trim(),
                          ),
                        );

                    final log = Logger();
                    log.i(farmer.toJson());

                    showDialog(
                      context: context,
                      builder:
                          (context) =>
                              const Center(child: CircularProgressIndicator()),
                    );
                    final result = await farmersRepository.addFarmer(farmer);
                    result.fold(
                      (failure) {
                        Navigator.pop(context);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.scale,
                          title: 'Error',
                          desc: failure.toString(),
                          btnOkOnPress: () {
                            Navigator.pop(context);
                          },
                        ).show();
                        return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'An error occurred while adding farmer',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      (r) {
                        Navigator.pop(context);
                        debugPrint("New farmer no: ${r.entity!.farmerNo}");
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.scale,
                          title: 'Success',
                          desc:
                              "Farmer no ${r.entity!.farmerNo} added successfully",
                          btnOkOnPress: () {
                            Navigator.pop(context);
                          },
                        ).show();
                        return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Farmer added successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    );

                    /*BlocProvider.of<AddFarmerCubit>(context).addFarmer(farmer);
                      BlocBuilder<AddFarmerCubit, AddFarmerState>(
                        builder: (context, state) {
                          if (state.uiState == UIState.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state.uiState == UIState.initial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state.uiState == UIState.error) {
                            return  Center(
                              child: Container()
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );*/
                  }
                }
              },
              onStepCancel: () {
                if (activeCurrentStep == 0) {
                  return;
                }
                setState(() {
                  activeCurrentStep -= 1;
                });
              },
              onStepTapped: (step) {
                /*setState(() {
                    activeCurrentStep = step;
                  });*/
              },
              steps: [
                Step(
                  title: const Text('General Details'),
                  content: Form(
                    key: detailsFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: firstNameController,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  labelText: "First Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "First Name cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: secondNameController,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  labelText: "Second Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Second Name cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: idNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "ID Number",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "ID No. cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          maxLength: 10,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: phoneNoController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone Number cannot be empty";
                            } else if (value.length < 10) {
                              return "Phone Number cannot be less than 10 digits";
                            }
                            return null;
                          },
                        ),
                        /*const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: altPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                labelText: "Alt Phone Number",
                                border: OutlineInputBorder()),
                          ),*/
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                          items:
                              genderDropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Select Gender',
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Specify Gender";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                          items:
                              memberCategoryDropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Select Farmer/Member Category',
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Specify Category";
                            }
                            return null;
                          },
                        ),

                        /* const SizedBox(
                            height: 10,
                          ),*/
                        /*TextFormField(
                            controller: noOfCowsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Number of Cows",
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Number of cows cannot be empty";
                              }
                              return null;
                            },
                          ),*/
                      ],
                    ),
                  ),
                  isActive: activeCurrentStep == 0,
                ),
                Step(
                  title: const Text('Area of Residence & Collection Center'),
                  content: Form(
                    key: centerFormKey,
                    child: Column(
                      children: <Widget>[
                        BlocBuilder<AddFarmerCubit, AddFarmerState>(
                          builder: (context, state) {
                            if (state.uiState == UIState.error) {
                              return Text(state.exception!);
                            } else {
                              return TextFormField(
                                controller: countyController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'County',
                                ),
                                onTap: () {
                                  getCountiesList(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a county';
                                  }
                                  return null;
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<AddFarmerCubit, AddFarmerState>(
                          builder: (context, state) {
                            if (state.uiState == UIState.error) {
                              return Text(state.exception!);
                            } else {
                              return TextFormField(
                                controller: subCountyController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'SubCounty',
                                ),
                                onTap: () {
                                  getSubCountiesList(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a sub-county';
                                  }
                                  return null;
                                },
                              );
                            }
                          },
                        ),
                        /*const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<AddFarmerCubit, AddFarmerState>(
                            builder: (context, state) {
                              if (state.uiState == UIState.error) {
                                return Text(state.exception!);
                              } else {
                                return TextFormField(
                                  controller: wardController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Wards',
                                  ),
                                  onTap: () {
                                    getWardsList(context);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a Ward';
                                    }
                                    return null;
                                  },
                                );
                              }
                            },
                          ),*/
                        /*const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<AddFarmerCubit, AddFarmerState>(
                            builder: (context, state) {
                              if (state.uiState == UIState.error) {
                                return Text(state.exception!);
                              } else {
                                return TextFormField(
                                  controller: pickupLocationController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Pickup Center',
                                  ),
                                  onTap: () {
                                    getPicKupCenters(context);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a Pickup Center';
                                    }
                                    return null;
                                  },
                                );
                              }
                            },
                          ),*/
                        const SizedBox(height: 10),
                        BlocBuilder<AddFarmerCubit, AddFarmerState>(
                          builder: (context, state) {
                            if (state.uiState == UIState.error) {
                              return Text(state.exception!);
                            } else {
                              return TextFormField(
                                controller: routeController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Routes',
                                ),
                                onTap: () {
                                  getRoutes(context);
                                  /*f (pickupLocationController.text.isNotEmpty) {
                                      if (pickUpCenterId != null) {
                                        getRoutes(context, pickUpCenterId!);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Please select a pickup center first')));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Please select a pickup center first')));
                                    }*/
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a Route';
                                  }
                                  return null;
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: locationController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: "Location",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Location cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: sublocationController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: "Sub-Location",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Sub-Location cannot be empty";
                            }
                            return null;
                          },
                        ),
                        /*const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: villageController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                                labelText: "Village", border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Village cannot be empty";
                              }
                              return null;
                            },
                          ),*/
                      ],
                    ),
                  ),
                  isActive: activeCurrentStep == 1,
                ),
                Step(
                  title: const Text('Payment Details'),
                  content: Form(
                    key: paymentsFormKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedPaymentMeans,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPaymentMeans = newValue!;
                              if (selectedPaymentMeans == "Mpesa") {
                                isPaymentModeMpesa = true;
                              } else {
                                isPaymentModeMpesa = false;
                              }
                            });
                          },
                          items:
                              paymentMeansDropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Means of Payment',
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a Means of Payment';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: isPaymentModeMpesa,
                          child: TextFormField(
                            controller: mpesaNoController,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: "Mpesa Number",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (isPaymentModeMpesa && value!.isEmpty) {
                                return "M-pesa Number cannot be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: !isPaymentModeMpesa,
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: selectedBankName,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedBankName = newValue!;
                                  });
                                },
                                items:
                                    bankNameDropdownItems.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                decoration: const InputDecoration(
                                  labelText: 'Bank/Sacco Name',
                                  border: UnderlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a Bank Name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: bankAccController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: "Bank/Sacco Account number",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Bank Account cant be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: bankAccNameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: "Bank/Sacco Account Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Bank/Sacco Account Name cant be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: branchNameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: "Branch Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Branch Name cant be empty";
                                  }
                                  return null;
                                },
                              ),
                              /*const SizedBox(
                            height: 10,
                          ),*/
                              /*DropdownButtonFormField<String>(
                            value: selectedChoice,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedChoice = newValue!;
                              });
                            },
                            items: altDropdownItems.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Alternative Means of Payment?',
                              border: UnderlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                          ),*/
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: otherPaymentDetailsController,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  labelText: "Other Payment Details",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: altMeansOfPayment,
                          onChanged: (String? newValue) {
                            setState(() {
                              altMeansOfPayment = newValue!;
                              if (altMeansOfPayment == "Yes") {
                                hasAlternativePaymentMeans = true;
                              } else {
                                hasAlternativePaymentMeans = false;
                              }
                            });
                          },
                          items:
                              altDropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Alternative Means of Payment?',
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a value';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: hasAlternativePaymentMeans,
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: altPaymentMeans,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    altPaymentMeans = newValue!;
                                  });
                                },
                                items:
                                    altPaymentMeansDropdownItems.map((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                decoration: const InputDecoration(
                                  labelText: 'Alternative Means of Payment',
                                  border: UnderlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select an option';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                maxLength: 10,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                controller: altMpesaTextInputController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Enter Mpesa number",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Other Payment Details cant be empty";
                                  } else if (value.length < 10) {
                                    return "Mpesa number must be 10 digits";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isActive: activeCurrentStep == 2,
                ),
                Step(
                  title: const Text('Next of Kin'),
                  content: Form(
                    key: nextOfKinFormKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        /*DropdownButtonFormField<String>(
                            value: selectedPaymentFreq,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPaymentFreq = newValue!;
                              });
                            },
                            items: paymentFreqDropdownItems.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Payment Frequency',
                              border: UnderlineInputBorder(),
                            ),
                          ),*/
                        TextFormField(
                          controller: nikNameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Name cannot be empty";
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nikIdNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "ID Number",
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "ID Number cannot be empty";
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nikRelationshipController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: "Relationship",
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Specify your relationship with them";
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nikPhoneController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Cannot be empty";
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nikAddressController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Address",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isActive: activeCurrentStep == 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void getCountiesList(BuildContext context) {
    final addFarmerCubit = context.read<AddFarmerCubit>();
    addFarmerCubit.getCounties();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: addFarmerCubit,
          child: AlertDialog(
            title: const Text('Select County'),
            content: BlocBuilder<AddFarmerCubit, AddFarmerState>(
              builder: (context, state) {
                if (state.uiState == UIState.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.exception!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return DropdownButtonFormField<CountiesEntityModel>(
                    decoration: const InputDecoration(labelText: 'County'),
                    items:
                        state.countiesResponseModel?.entity?.map((county) {
                          return DropdownMenuItem<CountiesEntityModel>(
                            value: county,
                            child: Text(county.name!),
                          );
                        }).toList(),
                    onChanged: (selectedCounty) {
                      countyController.text = selectedCounty!.name!;
                      countyId = selectedCounty.id!;
                    },
                  );
                } else {
                  return DropdownButtonFormField<CountiesEntityModel>(
                    decoration: const InputDecoration(labelText: 'County'),
                    items:
                        state.countiesResponseModel?.entity?.map((county) {
                          return DropdownMenuItem<CountiesEntityModel>(
                            value: county,
                            child: Text(county.name!),
                          );
                        }).toList(),
                    onChanged: (selectedCounty) {
                      countyController.text = selectedCounty!.name!;
                      countyId = selectedCounty.id!;
                    },
                  );
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // Handle selected county
                  selectedCounty = countyController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void getSubCountiesList(BuildContext context) {
    final addFarmerCubit = context.read<AddFarmerCubit>();
    addFarmerCubit.getSubCounties();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: addFarmerCubit,
          child: AlertDialog(
            title: const Text('Select Sub-County'),
            content: BlocBuilder<AddFarmerCubit, AddFarmerState>(
              builder: (context, state) {
                if (state.uiState == UIState.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.exception!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return Text(state.exception!);
                  /*return DropdownButtonFormField<SubCountiesEntityModel>(
                    decoration: const InputDecoration(labelText: 'Sub-County'),
                    items:
                    state.subCountiesResponseModel?.entity?.map((county) {
                      return DropdownMenuItem<SubCountiesEntityModel>(
                        value: county,
                        child: Text(county.subcounty!),
                      );
                    }).toList(),
                    onChanged: (selectedSubCounty) {
                      subCountyController.text = selectedSubCounty!.subcounty!;
                      subCountyId = selectedSubCounty.id!;
                    },
                  );*/
                } else {
                  return DropdownButtonFormField<SubCountiesEntityModel>(
                    decoration: const InputDecoration(labelText: 'Sub-County'),
                    items:
                        state.subCountiesResponseModel?.entity?.map((county) {
                          return DropdownMenuItem<SubCountiesEntityModel>(
                            value: county,
                            child: Text(county.subcounty!),
                          );
                        }).toList(),
                    onChanged: (selectedSubCounty) {
                      subCountyController.text = selectedSubCounty!.subcounty!;
                      subCountyId = selectedSubCounty.id!;
                    },
                  );
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // Handle selected county
                  selectedSubCounty = subCountyController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void getWardsList(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    final addFarmerCubit = context.read<AddFarmerCubit>();

    addFarmerCubit.getCollectorPickupLocations(collectorId!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: addFarmerCubit,
          child: AlertDialog(
            title: const Text('Select Ward'),
            content: BlocBuilder<AddFarmerCubit, AddFarmerState>(
              builder: (context, state) {
                if (state.uiState == UIState.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.exception!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return Text(state.exception!);
                } else {
                  return DropdownButtonFormField<PickupLocationEntityModel>(
                    decoration: const InputDecoration(labelText: 'Ward'),
                    items:
                        state.pickupLocationModel?.entity?.map((ward) {
                          return DropdownMenuItem<PickupLocationEntityModel>(
                            value: ward,
                            child: Text(ward.ward!),
                          );
                        }).toList(),
                    onChanged: (selectedSubCounty) {
                      wardController.text = selectedSubCounty!.ward!;
                      wardId = selectedSubCounty.id!;
                    },
                  );
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // Handle selected county
                  selectedWard = wardController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void getPicKupCenters(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    final addFarmerCubit = context.read<AddFarmerCubit>();

    addFarmerCubit.getCollectorPickupLocations(collectorId!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: addFarmerCubit,
          child: AlertDialog(
            title: const Text('Select Pick-up Center'),
            content: BlocBuilder<AddFarmerCubit, AddFarmerState>(
              builder: (context, state) {
                if (state.uiState == UIState.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.exception!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return Text(state.exception!);
                } else {
                  return DropdownButtonFormField<PickupLocationEntityModel>(
                    decoration: const InputDecoration(labelText: 'Center'),
                    items:
                        state.pickupLocationModel?.entity?.map((center) {
                          return DropdownMenuItem<PickupLocationEntityModel>(
                            value: center,
                            child: Text(center.name!),
                          );
                        }).toList(),
                    onChanged: (selectedSubCounty) {
                      pickupLocationController.text = selectedSubCounty!.name!;
                      final locationId = selectedSubCounty.id;
                      pickUpCenterId = locationId;
                      final log = Logger();
                      log.i("locationId: $locationId");
                    },
                  );
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // Handle selected county
                  selectedPickUpCenter = pickupLocationController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void getRoutes(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;

    final addFarmerCubit = context.read<RoutesCubit>();

    addFarmerCubit.getCollectorRoutes(collectorId!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: addFarmerCubit,
          child: AlertDialog(
            title: const Text('Select Route'),
            content: BlocBuilder<RoutesCubit, RoutesState>(
              builder: (context, state) {
                if (state.uiState == UIState.error) {
                  SnackBar snackBar = SnackBar(
                    content: Text(state.message!),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return Text(state.message!);
                } else {
                  return DropdownButtonFormField<CollectorRoutesEntityResponse>(
                    decoration: const InputDecoration(labelText: 'Route'),
                    items:
                        state.routes?.map((center) {
                          return DropdownMenuItem<
                            CollectorRoutesEntityResponse
                          >(value: center, child: Text(center.route!));
                        }).toList(),
                    onChanged: (selectedSubCounty) {
                      routeController.text = selectedSubCounty!.route!;
                      routeId = selectedSubCounty.id!;
                      //routeId = null;
                    },
                  );
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // Handle selected county
                  selectedRoute = routeController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void createFarmer() {
    // final createFarmerCubit = context.read<AddFarmerCubit>();
  }

  void addFarmer(BuildContext context) {
    FarmerOnboardRequestModel farmer = FarmerOnboardRequestModel(
      firstName: firstNameController.text.trim(),
      lastName: secondNameController.text.trim(),
      idNo: idNumberController.text.trim(),
      mobileNumber: phoneNoController.text.trim(),
      countyFk: countyId!,
      subcountyFk: subCountyId!,
      wardFk: null,
      routeFk: 1 /*routeId!*/,
      location: locationController.text.trim(),
      gender: selectedGender!,
      //memberType: selectedCategory!,
      //paymentDate: int.parse(selectedPaymentDate!),
      //paymentFreequency: selectedPaymentFreq!,
      paymentMode: selectedPaymentMeans!,
      //transportMeans: selectedTransportMeans!,
      subLocation: sublocationController.text.trim(),
      bankDetails: BankDetailsModel(
        bankName: selectedBankName!,
        accountName: bankAccNameController.text.trim(),
        accountNumber: bankAccController.text.trim(),
        branch: branchNameController.text.trim(),
        otherMeansDetails: otherPaymentDetailsController.text.trim(),
        otherMeans: selectedChoice!,
      ),
      nextOfKin: NextOfKinModel(
        address: nikAddressController.text.trim(),
        tel: nikPhoneController.text.trim(),
        idNo: nikIdNumberController.text.trim(),
        name: nikNameController.text.trim(),
        relationship: nikRelationshipController.text.trim(),
      ),
    );

    BlocProvider.of<AddFarmerCubit>(context).addFarmer(farmer);

    BlocConsumer<AddFarmerCubit, AddFarmerState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exception!),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.uiState == UIState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Farmer added successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
