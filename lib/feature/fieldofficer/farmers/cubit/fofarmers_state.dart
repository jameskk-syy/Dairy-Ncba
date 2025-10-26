part of 'fofarmers_cubit.dart';

class FofarmersState extends Equatable {
    final String? exception;
  final UIState? uiState;
  const FofarmersState({this.exception, this.uiState});

  @override
  List<Object?> get props => [exception, uiState];
}

 class FofarmersInitial extends FofarmersState {}
