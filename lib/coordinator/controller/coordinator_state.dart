import 'package:professor/app_state.dart';
import 'package:professor/user/controller/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class CoordinatorState {
  final UserModel? coordinatorCurrent;
  final List<UserModel>? coordinatorList;
  static UserModel? selectCoordinator(AppState state, String coordinatorId) =>
      state.coordinatorState.coordinatorList!
          .firstWhereOrNull((element) => element.id == coordinatorId);
  CoordinatorState({
    this.coordinatorCurrent,
    this.coordinatorList,
  });
  factory CoordinatorState.initialState() => CoordinatorState(
        coordinatorCurrent: null,
        coordinatorList: [],
      );

  CoordinatorState copyWith({
    UserModel? coordinatorCurrent,
    bool coordinatorCurrentNull = false,
    List<UserModel>? coordinatorList,
  }) {
    return CoordinatorState(
      coordinatorCurrent: coordinatorCurrentNull
          ? null
          : coordinatorCurrent ?? this.coordinatorCurrent,
      coordinatorList: coordinatorList ?? this.coordinatorList,
    );
  }

  @override
  String toString() =>
      'CoordinatorState(coordinatorCurrent: $coordinatorCurrent, coordinatorList: $coordinatorList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoordinatorState &&
        other.coordinatorCurrent == coordinatorCurrent &&
        listEquals(other.coordinatorList, coordinatorList);
  }

  @override
  int get hashCode => coordinatorCurrent.hashCode ^ coordinatorList.hashCode;
}
