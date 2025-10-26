import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils.dart';
import '../../../data/datasources/local/entity/collections_entity.dart';
import '../../../domain/repository/collections_repository.dart';

part 'pending_collections_state.dart';

class PendingCollectionsCubit extends Cubit<PendingCollectionsState> {
  final CollectionsRepository repository;

  PendingCollectionsCubit(this.repository) : super(const PendingCollectionsState());

  Future<void> getPendingCollections() async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await repository.getPendingCollections();
      result.fold(
              (failure) => emit(state.copyWith(uiState: UIState.error,exception: mapFailureToMessage(failure))),
            (collections) => emit(state.copyWith(uiState: UIState.success,collections: collections))
      );
    } on Exception catch (e){
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

}
