part of 'toggle_password_cubit.dart';

class TogglePasswordState extends Equatable {
  final bool isPasswordVisible;
  const TogglePasswordState({this.isPasswordVisible = false});

  @override
  List<Object> get props {
    return [isPasswordVisible];
  }

  TogglePasswordState copyWith({
    bool? isPasswordVisible,
}){
    return TogglePasswordState(
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible
    );
  }
}


