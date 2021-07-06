import 'package:professor/user/user_model.dart';

enum StatusFirestoreUser {
  unInitialized,
  checkingInFirestore,
  inFirestore,
  outFirestore,
}

class UserState {
  final UserModel? userCurrent;
  final StatusFirestoreUser statusFirestoreUser;

  UserState({
    required this.userCurrent,
    required this.statusFirestoreUser,
  });

  factory UserState.initialState() => UserState(
        userCurrent: null,
        statusFirestoreUser: StatusFirestoreUser.unInitialized,
      );
  UserState copyWith({
    UserModel? userCurrent,
    StatusFirestoreUser? statusFirestoreUser,
  }) =>
      UserState(
        userCurrent: userCurrent ?? this.userCurrent,
        statusFirestoreUser: statusFirestoreUser ?? this.statusFirestoreUser,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserState &&
        other.userCurrent == userCurrent &&
        other.statusFirestoreUser == statusFirestoreUser;
  }

  @override
  int get hashCode => statusFirestoreUser.hashCode ^ userCurrent.hashCode;
}
