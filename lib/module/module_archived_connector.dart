import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:flutter/material.dart';
import 'package:professor/module/module_action.dart';
import 'package:professor/module/module_archived_page.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/module/module_state.dart';

class ModuleArchivedConnector extends StatelessWidget {
  const ModuleArchivedConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      vm: () => HomeViewModelFactory(this),
      builder: (context, vm) => ModuleArchivedPage(
        moduleModelList: vm.moduleModelList,
        unArchived: vm.unArchived,
      ),
    );
  }
}

class HomeViewModelFactory
    extends VmFactory<AppState, ModuleArchivedConnector> {
  HomeViewModelFactory(widget) : super(widget);
  @override
  HomeViewModel fromStore() => HomeViewModel(
        moduleModelList: ModuleState.selectModuleArchived(state),
        unArchived: (String id) {
          dispatch(SetModuleCurrentModuleAction(id: id));
          ModuleModel moduleModel = state.moduleState.moduleModelCurrent!;
          moduleModel = moduleModel.copyWith(isArchivedByProf: false);
          dispatch(UpdateDocModuleAction(moduleModel: moduleModel));
        },
      );
}

class HomeViewModel extends Vm {
  final List<ModuleModel> moduleModelList;
  final Function(String) unArchived;
  HomeViewModel({
    required this.moduleModelList,
    required this.unArchived,
  }) : super(equals: [
          moduleModelList,
        ]);
}
