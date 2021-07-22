import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/resource/controller/resource_action.dart';
import 'package:professor/resource/resource_addedit_page.dart';
import 'package:professor/resource/controller/resource_model.dart';
import 'package:professor/upload/upload_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceAddEditConnector extends StatelessWidget {
  final String addOrEditId;
  const ResourceAddEditConnector({Key? key, required this.addOrEditId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResourceAddEditViewModel>(
      onInit: (store) {
        store.dispatch(RestartingStateUploadAction());
        store.dispatch(SetResourceCurrentResourceAction(id: addOrEditId));
        if (addOrEditId.isNotEmpty &&
            store.state.resourceState.resourceModelCurrent!.url != null) {
          store.dispatch(SetUrlForDownloadUploadAction(
              url: store.state.resourceState.resourceModelCurrent!.url!));
        }
      },
      vm: () => ResourceAddEditFactory(this),
      builder: (context, vm) => ResourceAddEditPage(
        formController: vm.formController,
        onSave: vm.onSave,
      ),
    );
  }
}

class ResourceAddEditFactory
    extends VmFactory<AppState, ResourceAddEditConnector> {
  ResourceAddEditFactory(widget) : super(widget);

  @override
  ResourceAddEditViewModel fromStore() => ResourceAddEditViewModel(
        formController: FormController(
            resourceModel: state.resourceState.resourceModelCurrent!),
        onSave: (ResourceModel resourceModel, urlOrFile urlOrFileSelected) {
          resourceModel = resourceModel.copyWith(
              moduleId: state.moduleState.moduleModelCurrent!.id);
          if (urlOrFileSelected == urlOrFile.file) {
            if (state.uploadState.urlForDownload != null &&
                state.uploadState.urlForDownload!.isNotEmpty) {
              resourceModel =
                  resourceModel.copyWith(url: state.uploadState.urlForDownload);
            }
          }
          if (urlOrFileSelected == urlOrFile.empty) {
            resourceModel = resourceModel.copyWith(urlIsNull: true);
          }
          if (widget!.addOrEditId.isEmpty) {
            dispatch(CreateDocResourceAction(resourceModel: resourceModel));
          } else {
            dispatch(UpdateDocResourceAction(resourceModel: resourceModel));
          }
        },
      );
}

enum urlOrFile { url, file, empty }

class ResourceAddEditViewModel extends Vm {
  final FormController formController;
  final Function(ResourceModel, urlOrFile) onSave;
  ResourceAddEditViewModel({
    required this.formController,
    required this.onSave,
  }) : super(equals: [
          formController,
        ]);
}

class FormController {
  final formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  ResourceModel resourceModel;
  FormController({
    required this.resourceModel,
  });
  String? validateRequiredText(String? value) =>
      value?.isEmpty ?? true ? 'Este campo não pode ser vazio.' : null;
  String? validateUrl(String? value) {
    print('validando url');
    if (value != null && value.isNotEmpty) {
      // Uri.tryParse(value)?.hasAbsolutePath ?? false;
      if (!(Uri.tryParse(value)?.hasAbsolutePath ?? false)) {
        return 'Esta URL é inválida';
      }
    }
    return null;
  }

  Future<bool> can(String url) async {
    return await canLaunch(resourceModel.url!);
  }

  void onChange({
    String? title,
    String? description,
    String? url,
    bool? isDeleted,
  }) {
    resourceModel = resourceModel.copyWith(
      title: title,
      description: description,
      url: url,
      isDeleted: isDeleted,
    );
    print('==--> FormController.onChange: $resourceModel');
  }

  void onCkechValidation() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      isFormValid = true;
    }
  }
}
