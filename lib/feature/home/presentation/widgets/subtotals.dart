import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/core/widgets/requests_cards.dart';
import 'package:dairytenantapp/feature/home/presentation/cubit/home_cubit.dart';
import 'package:dairytenantapp/feature/home/presentation/widgets/dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/theme/colors.dart';

class SubCollectorTotals extends StatelessWidget {
  const SubCollectorTotals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(msg: "An error occured");
        } else if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: spinkit()),
          );
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(3),
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Sub Route",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Quantity (kgs)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              if (state.uiState == UIState.loading)
                const Center(child: CircularProgressIndicator())
              else if (state.uiState == UIState.success)
                if (state.routeTotals != null && state.routeTotals!.isNotEmpty)
                  ...state.routeTotals!.map(
                    (routeTotal) => routeSubTotal(
                      routeTotal.route ?? "",
                      routeTotal.quantity ?? 0.0,
                    ),
                  )
                else
                  const Center(child: Text("No data found")),
            ],
          ),
        );
      },
    );
  }
}
