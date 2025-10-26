import 'package:dairytenantapp/feature/fieldofficer/inventory/data/inventory_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../../collections/domain/model/custom_resp_model.dart';
import '../../../totals/domain/model/products_model.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepository inventoryRepository;
  InventoryCubit(this.inventoryRepository) : super(const InventoryState());

  Future<void> addFeedsRequest(int productId, int locationId, int stock) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await inventoryRepository.allocateFeeds(
        productId,
        locationId,
        stock,
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

  Future<void> transferStock(
    int sourceId,
    int destinationId,
    int productId,
    int stock,
  ) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await inventoryRepository.transferStock(
        sourceId,
        destinationId,
        productId,
        stock,
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

  Future<void> getAllProducts() async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await inventoryRepository.getAllProducts();

      result.fold(
        (error) => emit(
          state.copyWith(uiState: UIState.error, error: error.toString()),
        ),
        (data) {
          emit(
            state.copyWith(
              uiState: UIState.success,
              products: data.productsList,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(uiState: UIState.error, error: e.toString()));
    }
  }

  Future<void> getAllFeedsRequests() async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await inventoryRepository.getAllFeedAllocations();

      result.fold(
        (error) => emit(
          state.copyWith(uiState: UIState.error, error: error.toString()),
        ),
        (data) {
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
}
