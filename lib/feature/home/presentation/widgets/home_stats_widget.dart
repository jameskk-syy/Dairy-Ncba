// import 'dart:convert';

// import 'package:dairytenantapp/core/data/dto/login_response_dto.dart';
// import 'package:dairytenantapp/core/di/injector_container.dart';
// import 'package:dairytenantapp/core/utils/utils.dart';
// import 'package:dairytenantapp/feature/home/presentation/cubit/home_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../config/theme/colors.dart';

// class CollectionsQuickStatsWidget extends StatelessWidget {
//   const CollectionsQuickStatsWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final prefs = sl<SharedPreferences>();
//     final userData = prefs.getString("UserData");
//     final user = LoginResponseDto.fromJson(json.decode(userData!));
//     final collectorId = user.id;

//     return BlocConsumer<HomeCubit, HomeState>(
//       listener: (context, state) {
//         if (state.uiState == UIState.error) {
//           /*showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: Text(state.exception!),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, 'OK'),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );*/
//         } else if (state.uiState == UIState.loading) {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) => const Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           height: 220,
//           width: double.infinity,
//           padding: const EdgeInsets.all(3.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.lightColorScheme.primary.withOpacity(0.2),
//                 spreadRadius: 1,
//                 blurRadius: 1,
//                 offset: const Offset(0, 1), // changes position of shadow
//               ),
//             ],
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color:
//                             AppColors.lightColorScheme.primary.withOpacity(0.2),
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         offset: const Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: Image.asset(
//                     'assets/images/milk_logo.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   color: Colors
//                       .white, // Replace with your container background color
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Align(
//                         alignment: Alignment.center,
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           child: const Text(
//                             'Overview',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 20),
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               const Text(
//                                 'Total Farmers',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Container(
//                                 height: 1,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(
//                                       color: AppColors.lightColorScheme.tertiary
//                                           .withOpacity(0.3),
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 state.totalFarmers.toString(),
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               const Text(
//                                 'Today Collections',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Container(
//                                 height: 1,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(
//                                       color: AppColors.lightColorScheme.tertiary
//                                           .withOpacity(0.3),
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Text(state.totalCollections.toString(),
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               const Text(
//                                 'Today Ltrs',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Container(
//                                 height: 1,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(
//                                       color: AppColors.lightColorScheme.tertiary
//                                           .withOpacity(0.3),
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Text(state.totalLitres.toString(),
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                       collectorId == 8 ? Align(
//                         alignment: Alignment.topLeft,
//                         child: Container(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               const Text("Sub Collector Ltrs", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
//                               Container(
//                                 height: 1,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   border: Border(bottom: BorderSide(color: AppColors.lightColorScheme.tertiary.withOpacity(0.3), width: 2),)
//                                 ),
//                               ),
//                               Text(state.totalSubLitres.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
//                             ],
//                           ),
//                         ),
//                       ) : const SizedBox()
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/colors.dart';

class CollectionsQuickStatsWidget extends StatelessWidget {
  const CollectionsQuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          /*showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(state.exception!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );*/
        } else if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => const Center(child: CircularProgressIndicator()),
          );
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 220,
          width: double.infinity,
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightColorScheme.primary.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            color: Colors.white, // Replace with your container background color
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Overview',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Milk Center',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.centerName ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Farmers',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.totalFarmers.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today Collections',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.totalCollections.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Today Ltrs',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.totalLitres.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
