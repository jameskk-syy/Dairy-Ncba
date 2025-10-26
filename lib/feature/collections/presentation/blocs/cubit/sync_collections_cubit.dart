import 'package:bloc/bloc.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasources/local/entity/collections_entity.dart';
import '../../../domain/repository/collections_repository.dart';

part 'sync_collections_state.dart';

class SyncCollectionsCubit extends Cubit<SyncCollectionsState> {
  final CollectionsRepository collectionsRepository;
  SyncCollectionsCubit(this.collectionsRepository)
    : super(const SyncCollectionsState());

  Future<bool> syncCollections() async {
    bool isSynced = false;
    try {
      emit(state.copyWith(uiState: UIState.loading));
      final result = await collectionsRepository.syncCollection();
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure),
            ),
          );
        },
        (success) {
          emit(
            state.copyWith(uiState: UIState.success, message: success.message),
          );
          isSynced = true;
        },
      );
      return isSynced;
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
      return false;
    }
  }
}
