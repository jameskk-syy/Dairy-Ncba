import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:external_path/external_path.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/services/notification.dart';
import '../../../../feature/fieldofficer/home/data/fo_home_repository.dart';
import '../../../../core/utils/utils.dart';
import '../../../farmers/domain/model/deliveries_dto.dart';
import '../../../farmers/domain/model/farmers_response_model.dart';
import '../../../farmers/domain/repository/farmers_repository.dart';

part 'fohome_state.dart';

class FohomeCubit extends Cubit<FohomeState> {
  final FarmersRepository farmersRepository;
  final FOHomeRepository foHomeRepository;
  FohomeCubit(this.farmersRepository, this.foHomeRepository)
      : super(const FohomeState());

  Future<void> getFarmers(int routeId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await farmersRepository.getAllRouteFarmers(routeId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success,
            farmersResponseModel: data,
            filteredFarmers: data));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getDeliveries(int farmerNo, String from, String to) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await foHomeRepository.getDeliveries(farmerNo, from, to);

      result.fold(
          (error) => emit(state.copyWith(
              uiState: UIState.error, exception: error.toString())), (data) {
        emit(state.copyWith(
            uiState: UIState.success, deliveries: data.deliveries));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> searchFarmer(String query) async {
    emit(state.copyWith(searching: true));
    emit(state.copyWith(uiState: UIState.loading));
    if (query.isEmpty) {
      emit(state.copyWith(
          uiState: UIState.success,
          filteredFarmers: state.farmersResponseModel));
    } else {
      final filteredList = state.farmersResponseModel!.where((farmer) {
        return farmer.firstName!.toLowerCase().contains(query.toLowerCase()) ||
            farmer.idNumber!.toLowerCase().contains(query.toLowerCase()) ||
            farmer.farmerNo
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
      emit(state.copyWith(
          uiState: UIState.success,
          filteredFarmers: filteredList,
          searching: false));
    }
  }

  Future<void> getStatement(int farmerNo, String from, String to) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final response = await foHomeRepository.getStatement(farmerNo, from, to);

      response
          .fold((error) => emit(state.copyWith(exception: error.toString())),
              (data) async {
        final contentType = data.headers['content-type'];

        final saveDir = await getApplicationDocumentsDirectory();
        final ext = contentType!.contains('application/pdf') ? 'pdf' : 'xlsx';
        final path = '${saveDir.path}/${farmerNo}statement.$ext';

        final file = File(path);
        await file.writeAsBytes(data.bodyBytes);

        emit(state.copyWith(uiState: UIState.success, statement: file));
      });
    } on Exception catch (e) {
      emit(state.copyWith(exception: e.toString()));
    }
  }

  Future<void> getAllocationHistory(int month, String year) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final response = await foHomeRepository.getAllocationHistory(month, year);

      response.fold(
          (error) => emit(state.copyWith(
              uiState: UIState.error,
              exception: error.toString())), (data) async {
        final saveDir = await getApplicationDocumentsDirectory();

        final file = File("${saveDir.path}/allocations_$month.xlsx");
        await file.writeAsBytes(data.bodyBytes);
        emit(state.copyWith(uiState: UIState.success, allocationReport: file));
        saveFile(file, "allocations_$month.xlsx");
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getRouteSummaryReport(
      int routeId, int month, String year, String curMonth) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final response =
          await foHomeRepository.getRouteSummaryReport(routeId, month, year);

      response.fold(
          (error) => emit(state.copyWith(
              uiState: UIState.error,
              exception: error.toString())), (data) async {
        final saveDir = await getApplicationDocumentsDirectory();

        final file = File("${saveDir.path}/summary_$month.xlsx");
        await file.writeAsBytes(data.bodyBytes);
        emit(state.copyWith(uiState: UIState.success, routeReport: file));
        saveFile(file, "summary_$curMonth.xlsx");
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> saveFile(File file, String fileName) async {
    final Logger logger = Logger();

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        // Use the correct constant
        final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD,
        );
        final Directory dir = Directory(downloadsPath);
        // Create directory if it doesn't exist
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        // Define the new path
        final newPath = '${dir.path}/$fileName';
        // Copy file
        await file.copy(newPath);
        logger.i('File saved to $newPath');
        await showDownloadNotification();
      } else {
        logger.w('Storage permission denied');
      }
    } else {
      logger.w('Unsupported platform: ${Platform.operatingSystem}');
    }
  }
}
