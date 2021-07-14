import 'package:async_redux/async_redux.dart';
import 'package:professor/course/course_model.dart';
import 'package:professor/teacher/teacher_action.dart';
import 'package:flutter/material.dart';

import 'package:professor/app_state.dart';
import 'package:professor/course/course_action.dart';
import 'package:professor/module/module_action.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/module/module_page.dart';

class ModuleConnector extends StatelessWidget {
  final String courseId;
  const ModuleConnector({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ModuleViewModel>(
      onInit: (store) async {
        store.dispatch(SetCourseCurrentCourseAction(id: courseId));
        await store.dispatch(ReadDocsTeacherAction());
        store.dispatch(StreamDocsModuleAction());
      },
      vm: () => ModuleFactory(this),
      builder: (context, vm) => ModulePage(
        courseModel: vm.courseModel,
        moduleModelList: vm.moduleModelList,
        onChangeModuleOrder: vm.onChangeModuleOrder,
      ),
    );
  }
}

class ModuleFactory extends VmFactory<AppState, ModuleConnector> {
  ModuleFactory(widget) : super(widget);
  ModuleViewModel fromStore() => ModuleViewModel(
        courseModel: state.courseState.courseModelCurrent!,
        moduleModelList: state.moduleState.moduleModelList!,
        onChangeModuleOrder: (List<String> moduleOrder) {
          CourseModel courseModel = state.courseState.courseModelCurrent!;
          courseModel = courseModel.copyWith(moduleOrder: moduleOrder);
          dispatch(UpdateDocCourseAction(courseModel: courseModel));
        },
      );
}

class ModuleViewModel extends Vm {
  final CourseModel courseModel;
  final List<ModuleModel> moduleModelList;
  final Function(List<String>) onChangeModuleOrder;
  ModuleViewModel({
    required this.courseModel,
    required this.moduleModelList,
    required this.onChangeModuleOrder,
  }) : super(equals: [
          courseModel,
          moduleModelList,
        ]);
}
