import 'package:async_redux/async_redux.dart';

import 'package:professor/app_state.dart';
import 'package:professor/coordinator/controller/coordinator_action.dart';
import 'package:professor/course/controller/course_model.dart';

class SetCourseCurrentCourseAction extends ReduxAction<AppState> {
  final String id;
  SetCourseCurrentCourseAction({
    required this.id,
  });
  @override
  AppState reduce() {
    print('--> SetCourseCurrentCourseAction $id');
    CourseModel courseModel = CourseModel(
      '',
      coordinatorUserId: '',
      title: '',
      description: '',
      syllabus: '',
      isArchivedByAdm: false,
      isArchivedByCoord: false,
      isDeleted: false,
      isActive: true,
    );
    if (id.isNotEmpty) {
      courseModel = state.courseState.courseModelList!
          .firstWhere((element) => element.id == id);
    }
    return state.copyWith(
      courseState: state.courseState.copyWith(
        courseModelCurrent: courseModel,
      ),
    );
  }

  void after() {
    dispatch(SetCoordinatorCurrentCoordinatorAction(
        id: store.state.courseState.courseModelCurrent!.coordinatorUserId));
  }
}
