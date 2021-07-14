import 'package:professor/app_state.dart';
import 'package:professor/user/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class TeacherState {
  final UserModel? teacherCurrent;
  final List<UserModel>? teacherList;
  static UserModel? selectTeacher(AppState state, String teacherId) =>
      state.teacherState.teacherList!
          .firstWhereOrNull((element) => element.id == teacherId);
  TeacherState({
    this.teacherCurrent,
    this.teacherList,
  });
  factory TeacherState.initialState() => TeacherState(
        teacherCurrent: null,
        teacherList: [],
      );

  TeacherState copyWith({
    UserModel? teacherCurrent,
    bool teacherCurrentNull = false,
    List<UserModel>? teacherList,
  }) {
    return TeacherState(
      teacherCurrent:
          teacherCurrentNull ? null : teacherCurrent ?? this.teacherCurrent,
      teacherList: teacherList ?? this.teacherList,
    );
  }

  @override
  String toString() =>
      'TeacherState(teacherCurrent: $teacherCurrent, teacherList: $teacherList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TeacherState &&
        other.teacherCurrent == teacherCurrent &&
        listEquals(other.teacherList, teacherList);
  }

  @override
  int get hashCode => teacherCurrent.hashCode ^ teacherList.hashCode;
}
