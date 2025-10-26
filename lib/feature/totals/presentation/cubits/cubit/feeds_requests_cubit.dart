import 'package:dairytenantapp/core/domain/repository/core_repository.dart';
import 'package:dairytenantapp/feature/totals/data/repository/feeds_request_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../collections/domain/model/custom_resp_model.dart';
import '../../../domain/model/feed_request_dto.dart';
import '../../../domain/model/feeds_requests_model.dart';
import '../../../domain/model/product_category.dart';
import '../../../domain/model/products_model.dart';

part 'feeds_requests_state.dart';

class FeedsRequestsCubit extends Cubit<FeedsRequestsState> {
  final FeedsRequestRepository feedsRequestRepository;
  final CoreRepository coreRepository;
  FeedsRequestsCubit(this.feedsRequestRepository, this.coreRepository)
    : super(const FeedsRequestsState());

  Future<void> getAllCategories() async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await feedsRequestRepository.getAllCategories();
      result.fold(
        (error) => emit(
          state.copyWith(uiState: UIState.error, error: error.toString()),
        ),
        (data) {
          emit(
            state.copyWith(
              uiState: UIState.success,
              productCategories: data.productCategory,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(uiState: UIState.error, error: e.toString()));
    }
  }

  Future<void> getAllProducts(int locationId) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await feedsRequestRepository.getAllProducts(locationId);

      result.fold(
        (error) => emit(
          state.copyWith(uiState: UIState.error, error: error.toString()),
        ),
        (data) {
          print("products data ${data.productsList}");
          emit(
            state.copyWith(
              uiState: UIState.success,
              products: data.productsList,
              message: data.message,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(uiState: UIState.error, error: e.toString()));
    }
  }

  //Get pickup locations
  Future<void> getCollectorPickupLocations(int collectorId) async {
    try {
      final results = await coreRepository.getCollectorPickupLocations(
        collectorId,
      );

      results.fold(
        (failure) {
          emit(
            state.copyWith(
              uiState: UIState.error,
              error: mapFailureToMessage(failure),
            ),
          );
        },
        (data) {
          print("fdghjgfdsa $data");

          // check if entity is null or empty
          if (data.entity == null || data.entity!.isEmpty) {
            emit(
              state.copyWith(
                uiState: UIState.error,
                error: data.message ?? "No pickup locations found",
              ),
            );
            return;
          }

          // safe to access first element now
          emit(
            state.copyWith(
              uiState: UIState.success,
              locationId: data.entity!.first.id,
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, error: e.toString()));
    }
  }

  Future<void> addFeedsRequest(FeedRequestDto feedRequestDto) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await feedsRequestRepository.addFeedsRequest(
        feedRequestDto,
      );

      result.fold(
        (error) => emit(
          state.copyWith(uiState: UIState.error, error: error.toString()),
        ),
        (data) {
          emit(state.copyWith(uiState: UIState.success, customResponse: data));
        },
      );
    } catch (e) {
      emit(state.copyWith(uiState: UIState.error, error: e.toString()));
    }
  }

  Future<void> confirmFeedsRequest(int id, String status) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await feedsRequestRepository.confirmFeedsRequest(
        id,
        status,
      );

      print("resultssssssssss $result");

      result.fold(
        (error) => emit(
          state.copyWith(uiState: UIState.error, error: error.toString()),
        ),
        (data) {
          emit(state.copyWith(uiState: UIState.success, customResponse: data));
        },
      );
    } catch (e) {
      emit(state.copyWith(uiState: UIState.error, error: e.toString()));
    }
  }

  Future<void> getAllFeedsRequests(
    int locationId,
    int month,
    String year,
  ) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await feedsRequestRepository.getAllFeedsRequests(
        locationId,
        month,
        year,
      );

      result.fold(
        (error) => emit(
          state.copyWith(uiState: UIState.error, error: error.toString()),
        ),
        (data) {
          emit(
            state.copyWith(
              uiState: UIState.feedsSuccess,
              allFeedsRequests: data.feedsRequestsList,
              message: data.message,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(uiState: UIState.error, error: e.toString()));
    }
  }
}
