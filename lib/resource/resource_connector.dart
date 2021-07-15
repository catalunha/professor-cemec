import 'package:async_redux/async_redux.dart';
import 'package:professor/course/course_model.dart';
import 'package:professor/module/module_action.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/resource/resource_action.dart';
import 'package:professor/resource/resource_model.dart';
import 'package:professor/resource/resource_page.dart';
import 'package:professor/user/user_model.dart';
import 'package:flutter/material.dart';

import 'package:professor/app_state.dart';

class ResourceConnector extends StatelessWidget {
  final String moduleId;
  const ResourceConnector({
    Key? key,
    required this.moduleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResourceViewModel>(
      onInit: (store) async {
        await store.dispatch(SetModuleCurrentModuleAction(id: moduleId));
        // por cascate in after segue SetCourseCurrentCourseAction e SetCoordinatorCurrentCoordinatorAction
        // await store.dispatch(SetCourseCurrentCourseAction(
        //     id: store.state.moduleState.moduleModelCurrent!.courseId));
        // store.dispatch(SetCoordinatorCurrentCoordinatorAction(
        //     id: store.state.courseState.courseModelCurrent!.coordinatorUserId));

        store.dispatch(StreamDocsResourceAction());
      },
      vm: () => ResourceFactory(this),
      builder: (context, vm) => ResourcePage(
        coordinator: vm.coordinator,
        courseModel: vm.courseModel,
        moduleModel: vm.moduleModel,
        resourceModelList: vm.resourceModelList,
        onChangeResourceOrder: vm.onChangeResourceOrder,
      ),
    );
  }
}

class ResourceFactory extends VmFactory<AppState, ResourceConnector> {
  ResourceFactory(widget) : super(widget);
  ResourceViewModel fromStore() => ResourceViewModel(
        moduleModel: state.moduleState.moduleModelCurrent!,
        resourceModelList: state.resourceState.resourceModelList!,
        coordinator: state.coordinatorState.coordinatorCurrent,
        courseModel: state.courseState.courseModelCurrent,
        onChangeResourceOrder: (List<String> resourceOrder) {
          ModuleModel moduleModel = state.moduleState.moduleModelCurrent!;
          moduleModel = moduleModel.copyWith(resourceOrder: resourceOrder);
          dispatch(UpdateDocModuleAction(moduleModel: moduleModel));
        },
      );
}

class ResourceViewModel extends Vm {
  final UserModel? coordinator;
  final CourseModel? courseModel;
  final ModuleModel moduleModel;
  final List<ResourceModel> resourceModelList;
  final Function(List<String>) onChangeResourceOrder;

  ResourceViewModel({
    required this.resourceModelList,
    required this.courseModel,
    required this.moduleModel,
    required this.onChangeResourceOrder,
    this.coordinator,
  }) : super(equals: [
          resourceModelList,
          courseModel,
          moduleModel,
          coordinator,
        ]);
}
