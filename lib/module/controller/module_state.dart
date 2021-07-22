import 'package:professor/app_state.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:flutter/foundation.dart';

class ModuleState {
  final ModuleModel? moduleModelCurrent;
  final List<ModuleModel>? moduleModelList;
  static List<ModuleModel> selectModuleNotArchived(AppState state) =>
      state.moduleState.moduleModelList!
          .where((element) => element.isArchivedByProf == false)
          .toList();
  static List<ModuleModel> selectModuleArchived(AppState state) =>
      state.moduleState.moduleModelList!
          .where((element) => element.isArchivedByProf == true)
          .toList();
  ModuleState({
    this.moduleModelCurrent,
    this.moduleModelList,
  });
  factory ModuleState.initialState() => ModuleState(
        moduleModelCurrent: null,
        moduleModelList: [],
      );
  ModuleState copyWith({
    ModuleModel? moduleModelCurrent,
    List<ModuleModel>? moduleModelList,
  }) {
    return ModuleState(
      moduleModelCurrent: moduleModelCurrent ?? this.moduleModelCurrent,
      moduleModelList: moduleModelList ?? this.moduleModelList,
    );
  }

  @override
  String toString() =>
      'ModuleState(moduleModelCurrent: $moduleModelCurrent, moduleModelList: $moduleModelList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModuleState &&
        other.moduleModelCurrent == moduleModelCurrent &&
        listEquals(other.moduleModelList, moduleModelList);
  }

  @override
  int get hashCode => moduleModelCurrent.hashCode ^ moduleModelList.hashCode;
}
