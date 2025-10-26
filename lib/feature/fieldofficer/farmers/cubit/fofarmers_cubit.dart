import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';

part 'fofarmers_state.dart';

class FofarmersCubit extends Cubit<FofarmersState> {
  FofarmersCubit() : super(const FofarmersState());
}
