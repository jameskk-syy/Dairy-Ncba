import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/utils/utils.dart';
import '../../../totals/presentation/cubits/cummulator_stats_cubit.dart';

class SalesStatsWidget extends StatelessWidget {
  const SalesStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final date = getTodaysDateFormatted();
    return BlocConsumer<CummulatorStatsCubit, CummulatorStatsState>(
      listener: (context, state) {},
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
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.6,
                // Adjust the width as needed
                child: Image.asset(
                  'assets/images/milk_logo.png', // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.4,
                // Adjust the positioning as needed
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  // Replace with your container background color
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const Text(
                              'Overview',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              date,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Total Collection',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 1,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.lightColorScheme.tertiary
                                        .withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                             Text(
                              state.collections.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Total Routes',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 1,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.lightColorScheme.tertiary
                                        .withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                                state.routes.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Total Ltrs',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 1,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.lightColorScheme.tertiary
                                        .withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                                state.totalMilk.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      /*Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Weekly Sales', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                        Container(
                          height: 1,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors
                                    .lightColorScheme.tertiary
                                    .withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const Text('0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Monthly sales', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                        Container(
                          height: 1,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors
                                    .lightColorScheme.tertiary
                                    .withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const Text('0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  )*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
