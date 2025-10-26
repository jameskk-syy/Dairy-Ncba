// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'inventory_cubit.dart';

class InventoryState extends Equatable {
  final String? error;
  final String? message;
  final UIState? uiState;
  final List<ProductsModel>? products;
  final CustomResponse? customResponse;

  const InventoryState(
      {this.error, this.uiState, this.products, this.customResponse, this.message});

  @override
  List<Object?> get props => [error, uiState, products, customResponse];

  InventoryState copyWith({
    String? error,
    UIState? uiState,
    List<ProductsModel>? products,
    CustomResponse? customResponse,
    String? message
  }) {
    return InventoryState(
      error: error ?? this.error,
      message: message ?? message,
      uiState: uiState ?? this.uiState,
      products: products ?? this.products,
      customResponse: customResponse ?? this.customResponse,
    );
  }
}

class InventoryInitial extends InventoryState {}
