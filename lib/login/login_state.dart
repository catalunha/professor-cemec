import 'package:firebase_auth/firebase_auth.dart';

enum StatusFirebaseAuth {
  unInitialized,
  authenticating,
  authenticated,
  unAuthenticated,
}

class LoginState {
  final User? userFirebaseAuth;
  final StatusFirebaseAuth statusFirebaseAuth;

  LoginState({
    required this.userFirebaseAuth,
    required this.statusFirebaseAuth,
  });
  factory LoginState.initialState() => LoginState(
        userFirebaseAuth: null,
        statusFirebaseAuth: StatusFirebaseAuth.unInitialized,
      );
  LoginState copyWith({
    User? userFirebaseAuth,
    StatusFirebaseAuth? statusFirebaseAuth,
  }) =>
      LoginState(
        userFirebaseAuth: userFirebaseAuth ?? this.userFirebaseAuth,
        statusFirebaseAuth: statusFirebaseAuth ?? this.statusFirebaseAuth,
      );
  @override
  int get hashCode => userFirebaseAuth.hashCode ^ statusFirebaseAuth.hashCode;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginState &&
        runtimeType == other.runtimeType &&
        other.userFirebaseAuth == userFirebaseAuth &&
        other.statusFirebaseAuth == statusFirebaseAuth;
  }
}
