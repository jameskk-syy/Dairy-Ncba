import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../network/network.dart';

part 'connection_state.dart';

class ConnectionCubit extends Cubit<AppConnectionState> {
  final NetworkInfo networkInfo;
  ConnectionCubit(this.networkInfo) : super(const AppConnectionState());

  Future<void> checkConnection() async {
    final isConnected = await networkInfo.isConnected();
    emit(state.copyWith(isConnected: isConnected));
  }

  /*Stream<AppConnectionState> checkConnection() async* {
    final isConnected = await networkInfo.isConnected();
    yield state.isConnected ? AppConnectionState(isConnected) : AppConnectionState(state.isConnected);
  }*/
}
