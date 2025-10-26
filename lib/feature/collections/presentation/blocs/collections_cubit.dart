import 'package:dairytenantapp/feature/collections/domain/model/collection_history_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../../farmers/domain/model/farmer_details_model.dart';
import '../../domain/repository/collections_repository.dart';

part 'collections_state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  final CollectionsRepository collectionsRepository;
  //final FarmersRepository farmersRepository;

  CollectionsCubit(this.collectionsRepository)
    : super(const CollectionsState());

  Future<void> getCollectionHistory(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await collectionsRepository.getCollectionHistory(
        collectorId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) => emit(
          state.copyWith(
            uiState: UIState.success,
            collectionHistoryModel: data,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
