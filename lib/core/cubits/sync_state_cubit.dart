

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/collections/domain/repository/collections_repository.dart';

/*
class SyncStateCubit extends Cubit<bool> {
  final  CollectionsRepository collectionsRepository;
  SyncStateCubit(this.collectionsRepository) : super(false);

  Future<void> checkDataSync() async {
    final result = await collectionsRepository.getPendingCollections();
    result.fold(
      (failure) => emit(false),
      (collections) => emit(collections.isNotEmpty)
    );
  }
}*/

class SyncStateCubit extends Cubit<bool> {
  final CollectionsRepository collectionsRepository;

  SyncStateCubit(this.collectionsRepository) : super(false);

  Future<void> checkDataSync() async {
    final result = await collectionsRepository.getPendingCollections();
    result.fold(
          (failure) => emit(false),
          (collections) => emit(collections.isNotEmpty),
    );
  }
}
