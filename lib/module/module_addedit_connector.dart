import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/module/module_action.dart';
import 'package:professor/module/module_addedit.page.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/teacher/teacher_action.dart';
import 'package:flutter/material.dart';

class ModuleAddEditConnector extends StatelessWidget {
  final String addOrEditId;
  const ModuleAddEditConnector({Key? key, required this.addOrEditId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ModuleAddEditViewModel>(
      onInit: (store) {
        store.dispatch(SetModuleCurrentModuleAction(id: addOrEditId));
        store.dispatch(SetTeacherCurrentTeacherAction(id: null));
        if (addOrEditId.isNotEmpty &&
            store.state.moduleState.moduleModelCurrent!.teacherUserId != null) {
          store.dispatch(SetTeacherCurrentTeacherAction(
              id: store.state.moduleState.moduleModelCurrent!.teacherUserId!));
        }
      },
      vm: () => ModuleAddEditFactory(this),
      builder: (context, vm) => ModuleAddEditPage(
        formController: vm.formController,
        onSave: vm.onSave,
      ),
    );
  }
}

class ModuleAddEditFactory extends VmFactory<AppState, ModuleAddEditConnector> {
  ModuleAddEditFactory(widget) : super(widget);
  @override
  ModuleAddEditViewModel fromStore() => ModuleAddEditViewModel(
        formController:
            FormController(moduleModel: state.moduleState.moduleModelCurrent!),
        onSave: (ModuleModel moduleModel) {
          moduleModel = moduleModel.copyWith(
              courseId: state.courseState.courseModelCurrent!.id);
          if (state.teacherState.teacherCurrent != null) {
            moduleModel = moduleModel.copyWith(
                teacherUserId: state.teacherState.teacherCurrent!.id);
          } else {
            moduleModel = moduleModel.copyWith(teacherUserIdNull: true);
          }
          if (widget!.addOrEditId.isEmpty) {
            dispatch(CreateDocModuleAction(moduleModel: moduleModel));
          } else {
            dispatch(UpdateDocModuleAction(moduleModel: moduleModel));
          }
        },
      );
}

class ModuleAddEditViewModel extends Vm {
  final FormController formController;
  final Function(ModuleModel) onSave;
  ModuleAddEditViewModel({
    required this.formController,
    required this.onSave,
  }) : super(equals: [
          formController,
        ]);
}

class FormController {
  final formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  ModuleModel moduleModel;
  FormController({
    required this.moduleModel,
  });
  String? validateRequiredText(String? value) =>
      value?.isEmpty ?? true ? 'Este campo não pode ser vazio.' : null;
  void onChange({
    String? title,
    String? description,
    String? syllabus,
    bool? isDeleted,
  }) {
    moduleModel = moduleModel.copyWith(
      title: title,
      description: description,
      syllabus: syllabus,
      isDeleted: isDeleted,
    );
  }

  void onCkechValidation() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      isFormValid = true;
    }
  }
}
