import 'package:async_redux/async_redux.dart';
import 'package:professor/login/login_state.dart';
import 'package:professor/upload/upload_state.dart';
import 'package:professor/user/user_state.dart';

class AppState {
  final Wait wait;
  final LoginState loginState;
  final UserState userState;
  final UploadState uploadState;
  AppState({
    required this.wait,
    required this.loginState,
    required this.userState,
    required this.uploadState,
  });

  static AppState initialState() => AppState(
        wait: Wait(),
        loginState: LoginState.initialState(),
        userState: UserState.initialState(),
        uploadState: UploadState.initialState(),
      );
  AppState copyWith({
    Wait? wait,
    LoginState? loginState,
    UserState? userState,
    UploadState? uploadState,
  }) {
    return AppState(
      wait: wait ?? this.wait,
      loginState: loginState ?? this.loginState,
      userState: userState ?? this.userState,
      uploadState: uploadState ?? this.uploadState,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppState &&
        other.uploadState == uploadState &&
        other.loginState == loginState &&
        other.userState == userState &&
        other.wait == wait;
  }

  @override
  int get hashCode {
    return uploadState.hashCode ^
        loginState.hashCode ^
        userState.hashCode ^
        wait.hashCode;
  }
}
