import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:professor/app_state.dart';
import 'package:professor/situation/controller/situation_action.dart';
import 'package:professor/situation/controller/situation_model.dart';
import 'package:professor/situation/situation_addedit_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SituationAddEditConnector extends StatelessWidget {
  final String addOrEditId;
  const SituationAddEditConnector({Key? key, required this.addOrEditId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SituationAddEditViewModel>(
      onInit: (store) {
        store.dispatch(SetSituationCurrentSituationAction(id: addOrEditId));
      },
      vm: () => SituationAddEditFactory(this),
      builder: (context, vm) => SituationAddEditPage(
        formController: vm.formController,
        onSave: vm.onSave,
      ),
    );
  }
}

class SituationAddEditFactory
    extends VmFactory<AppState, SituationAddEditConnector> {
  SituationAddEditFactory(widget) : super(widget);

  @override
  SituationAddEditViewModel fromStore() => SituationAddEditViewModel(
        formController: FormController(
            situationModel: state.situationState.situationCurrent!),
        onSave: (SituationModel situationModel) {
          situationModel = situationModel.copyWith(
              moduleId: state.moduleState.moduleModelCurrent!.id);
          if (widget!.addOrEditId.isEmpty) {
            dispatch(CreateDocSituationAction(situationModel: situationModel));
          } else {
            dispatch(UpdateDocSituationAction(situationModel: situationModel));
          }
        },
      );
}

class SituationAddEditViewModel extends Vm {
  final FormController formController;
  final Function(SituationModel) onSave;
  SituationAddEditViewModel({
    required this.formController,
    required this.onSave,
  }) : super(equals: [
          formController,
        ]);
}

class FormController {
  final formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  SituationModel situationModel;
  FormController({
    required this.situationModel,
  });
  String? validateRequiredText(String? value) =>
      value?.isEmpty ?? true ? 'Este campo não pode ser vazio.' : null;

  Future<bool> can(String url) async {
    return await canLaunch(url);
  }

  void onChange({
    String? title,
    String? description,
    String? proposalUrl,
    String? solutionUrl,
    String? type,
    String? choice,
    bool? isDeleted,
    List<String>? options,
  }) {
    situationModel = situationModel.copyWith(
      title: title,
      description: description,
      proposalUrl: proposalUrl,
      solutionUrl: solutionUrl,
      isDeleted: isDeleted,
      options: options,
      type: type,
      choice: choice,
    );
    print('==--> FormController.onChange: $situationModel');
  }

  void onCkechValidation() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      isFormValid = true;
    }
  }
}
