// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'feeds_requests_cubit.dart';

class FeedsRequestsState extends Equatable {
  final String? message;
  final UIState? uiState;
  final String? error;
  final List<ProductsModel>? products;
  final List<FeedsRequestModel>? allFeedsRequests;
  final FeedsRequestModel? feedsRequestModel;
  final List<ProductCategory>? productCategories;
  final CustomResponse? customResponse;
  final int? locationId;
  const FeedsRequestsState(
      {this.message,
      this.uiState,
      this.error,
      this.products,
      this.allFeedsRequests,
      this.feedsRequestModel,
      this.productCategories,
      this.customResponse,
      this.locationId});

  @override
  List<Object?> get props => [
        message,
        uiState,
        error,
        products,
        allFeedsRequests,
        feedsRequestModel,
        productCategories,
        locationId,
        customResponse
      ];

  FeedsRequestsState copyWith(
      {String? message,
      UIState? uiState,
      String? error,
      List<ProductsModel>? products,
      List<FeedsRequestModel>? allFeedsRequests,
      FeedsRequestModel? feedsRequestModel,
      int? locationId,
      CustomResponse? customResponse,
      List<ProductCategory>? productCategories}) {
    return FeedsRequestsState(
        message: message ?? this.message,
        uiState: uiState ?? this.uiState,
        error: error ?? this.error,
        products: products ?? this.products,
        allFeedsRequests: allFeedsRequests ?? this.allFeedsRequests,
        feedsRequestModel: feedsRequestModel ?? this.feedsRequestModel,
        locationId: locationId ?? this.locationId,
        customResponse: customResponse ?? this.customResponse,
        productCategories: productCategories ?? this.productCategories);
  }
}

class FeedsRequestsInitial extends FeedsRequestsState {}
