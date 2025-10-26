import 'package:dairytenantapp/feature/farmers/domain/model/farmers_response_model.dart';
import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';

Widget farmerCard(FarmersEntityModel farmer, String route) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/farmer.png", height: 100, width: 50),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_2_outlined,
                    size: 15,
                    color: AppColors.lightColorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    farmer.username ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.numbers,
                    size: 15,
                    color: AppColors.lightColorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'F/No. ${farmer.farmerNo ?? ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 15,
                    color: AppColors.lightColorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Phone. ${farmer.mobileNo ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.insert_drive_file_outlined,
                    size: 15,
                    color: AppColors.lightColorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'ID No. ${farmer.idNumber ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.insert_drive_file_outlined,
                    size: 15,
                    color: AppColors.lightColorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text('Route. $route', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
