import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/coordinator/coordinator_state.dart';
import 'package:professor/course/course_model.dart';
import 'package:professor/course/course_state.dart';
import 'package:professor/module/module_action.dart';
import 'package:professor/module/module_card.dart';
import 'package:professor/module/module_model.dart';
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
        onArchiveModule: vm.onArchiveModule,
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
        onArchiveModule: () {
          ModuleModel moduleModel = widget!.moduleModel;
          moduleModel = moduleModel.copyWith(isArchivedByProf: true);
          dispatch(UpdateDocModuleAction(moduleModel: moduleModel));
        },
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
  final VoidCallback onArchiveModule;
  ModuleCardViewModel({
    required this.coordinator,
    required this.courseModel,
    required this.onArchiveModule,
  }) : super(equals: [
          coordinator,
          courseModel,
        ]);
}
