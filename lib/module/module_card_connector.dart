import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/coordinator/coordinator_state.dart';
import 'package:professor/course/course_model.dart';
import 'package:professor/course/course_state.dart';
import 'package:professor/module/module_card.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/teacher/teacher_state.dart';
import 'package:professor/user/user_model.dart';
import 'package:flutter/material.dart';

class ModuleCardConnector extends StatelessWidget {
  final ModuleModel moduleModel;

  const ModuleCardConnector({Key? key, required this.moduleModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ModuleCardViewModel>(
      vm: () => ModuleCardFactory(this),
      builder: (context, vm) => ModuleCard(
        moduleModel: moduleModel,
        coordinator: vm.coordinator,
        courseModel: vm.courseModel,
      ),
    );
  }
}

class ModuleCardFactory extends VmFactory<AppState, ModuleCardConnector> {
  ModuleCardFactory(widget) : super(widget);
  @override
  ModuleCardViewModel fromStore() => ModuleCardViewModel(
        coordinator: selectCoordinator(),
        courseModel:
            CourseState.selectCourse(state, widget!.moduleModel.courseId),
      );

  selectCoordinator() {
    CourseModel? courseModel =
        CourseState.selectCourse(state, widget!.moduleModel.courseId);
    if (courseModel != null) {
      return CoordinatorState.selectCoordinator(
          state, courseModel.coordinatorUserId);
    }
    return null;
  }
}

class ModuleCardViewModel extends Vm {
  final UserModel? coordinator;
  final CourseModel? courseModel;
  ModuleCardViewModel({
    required this.coordinator,
    required this.courseModel,
  }) : super(equals: [
          coordinator,
          courseModel,
        ]);
}
