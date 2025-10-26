import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/dto/add_collection_dto.dart';
import '../../../../core/data/dto/collection_response.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/repository/collections_repository.dart';

part 'add_collection_state.dart';

class AddCollectionCubit extends Cubit<AddCollectionState> {
  final CollectionsRepository repository;

  AddCollectionCubit(this.repository) : super(const AddCollectionState());

  Future<void> addCollection(AddCollectionDto collection) async {
    try {
      emit(state.copyWith(uiState: UIState.loading));
      final result = await repository.addCollection(collection);
      result.fold(
        (failure) => emit(state.copyWith(
            exception: mapFailureToMessage(failure), uiState: UIState.error)),
        (collectionResponse) {
          emit(state.copyWith(
              collectionResponse: collectionResponse,
              uiState: UIState.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(exception: e.toString(), uiState: UIState.error));
    }
  }
}
