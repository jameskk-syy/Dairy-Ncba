import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/farmers/presentation/blocs/add_farmer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector_container.dart';

class AddFarmersPage extends StatefulWidget {
  const AddFarmersPage({super.key});

  @override
  State<AddFarmersPage> createState() => _AddFarmersPageState();
}

class _AddFarmersPageState extends State<AddFarmersPage> {
  BuildContext? blocContext;
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final phoneNoController = TextEditingController();
  final altPhoneController = TextEditingController();
  final noOfCowsController = TextEditingController();
  final categoryController = TextEditingController();
  final genderController = TextEditingController();

  final countyController = TextEditingController();
  final subcountyController = TextEditingController();
  final wardController = TextEditingController();
  final locationController = TextEditingController();
  final sublocationController = TextEditingController();
  final villageController = TextEditingController();
  final pickupLocationController = TextEditingController();
  final routeController = TextEditingController();

  //final bankNameController = TextEditingController();
  final bankAccController = TextEditingController();
  final bankAccNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final alternativeController = TextEditingController();

  //final altMeansController = TextEditingController();
  final otherPaymentDetailsController = TextEditingController();

  /*final otherPaymentDetailsController = TextEditingController();
  final otherPaymentDetailsController = TextEditingController();
  final otherPaymentDetailsController = TextEditingController();*/

  String? selectedGender;
  String? selectedCategory;

  String? selectedCounty;
  String? selectedSubCounty;

  List<String> genderDropdownItems = ['Female', 'Male'];

  List<String> memberCategoryDropdownItems = [
    'Individual',
    'Farmers Group',
    'Cooperative Society',
  ];

  List<String> altDropdownItems = ['Yes', 'No'];

  List<String> altPaymentMeansDropdownItems = ['Mpesa', 'Sacco', 'Cash'];

  List<String> bankNameDropdownItems = [
    'Equity Bank',
    'KCB',
    'Cooperative Bank',
    'Family Bank',
    'Barclays Bank',
    'Standard Chartered Bank',
    'Stanbic Bank',
    'Diamond Trust Bank',
    'National Bank',
    'Bank of Africa',
    'NIC Bank',
    'Kingdom Bank',
  ];

  List<String> paymentFreqDropdownItems = ['Daily', 'Monthly', 'Weekly'];

  List<String> transportMeansDropdownItems = ['Truck', 'Motorbike', 'Bicycle'];

  List<String> paymentDateDropdownItems = [
    for (int i = 1; i <= 31; i++) i.toString(),
  ];

  final GlobalKey<FormState> detailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> centerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> paymentsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> transportFormKey = GlobalKey<FormState>();

  List<Step> stepList() => [
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
              keyboardType: TextInputType.name,
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
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneNoController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Phone Number cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: altPhoneController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Alt Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
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
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: noOfCowsController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Number of Cows",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Number of cows cannot be empty";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    ),
    Step(
      title: const Text('Area of Residence & Collection Center'),
      content: Form(
        key: centerFormKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: countyController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "County",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "County cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    onTap: () {
                      BlocProvider.of<AddFarmerCubit>(
                        blocContext!,
                      ).getSubCounties();
                      showDialog(
                        context: context,
                        builder: (_) {
                          return BlocBuilder<AddFarmerCubit, AddFarmerState>(
                            builder: (context, state) {
                              blocContext = context;
                              if (state.uiState == UIState.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state.uiState == UIState.error) {
                                return const Center(child: Text("Error"));
                              } else if (state.uiState == UIState.success) {
                                return AlertDialog(
                                  title: const Text("Select SubCounty"),
                                  content: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: ListView.builder(
                                      itemCount:
                                          state
                                              .subCountiesResponseModel!
                                              .entity!
                                              .length,
                                      itemBuilder: (context, index) {
                                        final selected =
                                            state
                                                .subCountiesResponseModel!
                                                .entity![index]
                                                .subcounty;
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              selectedSubCounty = selected;
                                              subcountyController.text =
                                                  selectedSubCounty!;
                                            });
                                            Navigator.pop(context);
                                          },
                                          title: Text(selected!),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          );
                          // return const SizedBox();
                        },
                      );
                    },
                    controller: subcountyController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "SubCounty",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "SubCounty cannot be empty";
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
              keyboardType: TextInputType.name,
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
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneNoController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Phone Number cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: altPhoneController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Alt Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
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
                labelText: 'Select Category',
                border: UnderlineInputBorder(),
              ),
            ),
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
                labelText: 'Select gender',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: noOfCowsController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Number of Cows",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Number of cows cannot be empty";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    ),
    const Step(title: Text('Confirm'), content: Center(child: Text('Confirm'))),
  ];

  int activeCurrentStep = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddFarmerCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Farmers"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AddFarmerCubit, AddFarmerState>(
        builder: (context, state) {
          blocContext = context;
          if (state.uiState == UIState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.uiState == UIState.error) {
            return const Center(child: Text("Error"));
          } else if (state.uiState == UIState.success) {
            return const Center(child: Text("Success"));
          }
          return Stepper(
            type: StepperType.vertical,
            currentStep: activeCurrentStep,
            steps: stepList(),
            onStepContinue: () {
              if (activeCurrentStep < (stepList().length - 1)) {
                if (detailsFormKey.currentState!.validate()) {
                  setState(() {
                    activeCurrentStep += 1;
                  });
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
              setState(() {
                activeCurrentStep = step;
              });
            },
          );
        },
      ),
    );
  }
}
