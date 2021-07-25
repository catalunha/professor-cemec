import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:professor/app_state.dart';
import 'package:professor/course/controller/course_model.dart';
import 'package:professor/module/controller/module_action.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/situation/controller/situation_action.dart';
import 'package:professor/situation/controller/situation_model.dart';
import 'package:professor/situation/situation_page.dart';
import 'package:professor/user/controller/user_model.dart';

class SituationConnector extends StatelessWidget {
  final String moduleId;
  const SituationConnector({
    Key? key,
    required this.moduleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SituationViewModel>(
      onInit: (store) async {
        await store.dispatch(SetModuleCurrentModuleAction(id: moduleId));
        store.dispatch(StreamDocsSituationAction());
      },
      vm: () => SituationFactory(this),
      builder: (context, vm) => SituationPage(
        coordinator: vm.coordinator,
        courseModel: vm.courseModel,
        moduleModel: vm.moduleModel,
        situationList: vm.situationList,
        onChangeSituationOrder: vm.onChangeSituationOrder,
      ),
    );
  }
}

class SituationFactory extends VmFactory<AppState, SituationConnector> {
  SituationFactory(widget) : super(widget);
  SituationViewModel fromStore() => SituationViewModel(
        coordinator: state.coordinatorState.coordinatorCurrent,
        courseModel: state.courseState.courseModelCurrent,
        moduleModel: state.moduleState.moduleModelCurrent!,
        situationList: state.situationState.situationList!,
        onChangeSituationOrder: (List<String> situationOrder) {
          ModuleModel moduleModel = state.moduleState.moduleModelCurrent!;
          moduleModel = moduleModel.copyWith(situationOrder: situationOrder);
          dispatch(UpdateDocModuleAction(moduleModel: moduleModel));
        },
      );
}

class SituationViewModel extends Vm {
  final UserModel? coordinator;
  final CourseModel? courseModel;
  final ModuleModel moduleModel;
  final List<SituationModel> situationList;
  final Function(List<String>) onChangeSituationOrder;

  SituationViewModel({
    required this.coordinator,
    required this.courseModel,
    required this.moduleModel,
    required this.situationList,
    required this.onChangeSituationOrder,
  }) : super(equals: [
          coordinator,
          courseModel,
          moduleModel,
          situationList,
        ]);
}
