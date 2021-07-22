import 'package:professor/app_state.dart';
import 'package:professor/course/controller/course_model.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class CourseState {
  final CourseModel? courseModelCurrent;
  final List<CourseModel>? courseModelList;
  static CourseModel? selectCourse(AppState state, String courseId) =>
      state.courseState.courseModelList!
          .firstWhereOrNull((element) => element.id == courseId);
  CourseState({
    this.courseModelCurrent,
    this.courseModelList,
  });
  factory CourseState.initialState() => CourseState(
        courseModelCurrent: null,
        courseModelList: [],
      );
  CourseState copyWith({
    CourseModel? courseModelCurrent,
    List<CourseModel>? courseModelList,
  }) {
    return CourseState(
      courseModelCurrent: courseModelCurrent ?? this.courseModelCurrent,
      courseModelList: courseModelList ?? this.courseModelList,
    );
  }

  @override
  String toString() =>
      'CourseState(courseModelCurrent: $courseModelCurrent, courseModelList: $courseModelList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseState &&
        other.courseModelCurrent == courseModelCurrent &&
        listEquals(other.courseModelList, courseModelList);
  }

  @override
  int get hashCode => courseModelCurrent.hashCode ^ courseModelList.hashCode;
}
