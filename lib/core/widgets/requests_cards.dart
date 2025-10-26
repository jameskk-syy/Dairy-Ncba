import 'package:dairytenantapp/core/utils/constants.dart';
import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/totals/domain/model/feeds_requests_model.dart';
import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';

Widget farmerRequest(
  String farmerName,
  String farmerNumber,
  String productName,
  String comments,
  int quantity,
  String status,
  String approvedOn,
  Widget widget,
  Widget cancelWidget,
) {
  return Container(
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Farmer: "),
              const Spacer(),
              Text(farmerName),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Farmer No: "),
              const Spacer(),
              Text(farmerNumber),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: Row(
            children: [
              const Text("item"),
              const Spacer(),
              Text(
                productName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: Row(
            children: [
              const Text("quantity"),
              const Spacer(),
              Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 1.0, right: 8, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status: "),
              const Spacer(),
              Text(
                status,
                style: TextStyle(
                  color:
                      status == Constants.pending ? Colors.amber : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        status == Constants.approved
            ? Padding(
              padding: const EdgeInsets.only(top: 1.0, right: 8.0, left: 8.0),
              child: Row(
                children: [
                  const Text("Approved on:"),
                  const Spacer(),
                  Text(
                    formatDateTime(approvedOn),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
            : const SizedBox(),
        userRole() == "MILK_COLLECTOR"
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                status == Constants.pending ? cancelWidget : const SizedBox(),
                const Spacer(),
                status == Constants.pending ? widget : const SizedBox(),
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: AppColors.teal),
                //     onPressed: onPressed,
                //     child: const Text("Approve", style: TextStyle(color: Colors.black),))
              ],
            )
            : const SizedBox(),
      ],
    ),
  );
}

Widget feedRequestApproval(FeedsRequestModel request) {
  return Container(
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Farmer: "),
              const Spacer(),
              Text(request.farmerName!),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Farmer No: "),
              const Spacer(),
              Text((request.farmerNo).toString()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: Row(
            children: [
              const Text("item"),
              const Spacer(),
              Text(
                request.productName!,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: Row(
            children: [
              const Text("quantity"),
              const Spacer(),
              Text(
                (request.quantity).toString(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: Row(
            children: [
              const Text("Requested On"),
              const Spacer(),
              Text(
                formatDateTime(request.requestedOn!),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 1.0,
            bottom: 4,
            right: 8,
            left: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status: "),
              const Spacer(),
              Text(
                request.status!,
                style: TextStyle(
                  color:
                      request.status == Constants.pending
                          ? Colors.amber
                          : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 2.0, right: 8, left: 8),
          child: Text(
            "Comments",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Text(request.comments ?? ""),
        ),
      ],
    ),
  );
}

Widget feedsAllocation(
  String category,
  String productName,
  String quantity,
  Function()? onPressed,
) {
  return Container(
    padding: const EdgeInsets.only(top: 8, bottom: 12),
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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Product Category: "),
              const Spacer(),
              Text(category),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Product: "),
              const Spacer(),
              Text(productName),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Quantity: "),
              const Spacer(),
              Text(quantity),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget productPriceCard(String price, String description) {
  return Container(
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [const Text("Price"), const Spacer(), Text("$price KSH")],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [const Text("Info"), const Spacer(), Text(description)],
          ),
        ),
      ],
    ),
  );
}

Widget routeSubTotal(String route, double quantity) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    child: Row(
      children: [
        Text(
          route,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const Spacer(),
        Text(
          quantity.toStringAsFixed(2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
