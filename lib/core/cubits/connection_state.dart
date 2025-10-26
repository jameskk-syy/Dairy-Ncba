part of 'connection_cubit.dart';

 class AppConnectionState extends Equatable {
  final bool? isConnected;
  const AppConnectionState({this.isConnected});

  @override
  List<Object?> get props => [isConnected];

  AppConnectionState copyWith({
    bool? isConnected,
  }) {
    return AppConnectionState(
      isConnected: isConnected ?? this.isConnected
    );
  }

}


