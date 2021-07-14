import 'package:professor/module/module_addedit_connector.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/teacher/teacher_search_connector.dart';
import 'package:professor/widget/input_checkboxDelete.dart';
import 'package:professor/widget/input_description.dart';
import 'package:professor/widget/input_title.dart';
import 'package:flutter/material.dart';

class ModuleAddEditPage extends StatefulWidget {
  final FormController formController;
  final Function(ModuleModel) onSave;

  const ModuleAddEditPage({
    Key? key,
    required this.formController,
    required this.onSave,
  }) : super(key: key);

  @override
  _ModuleAddEditPageState createState() =>
      _ModuleAddEditPageState(formController);
}

class _ModuleAddEditPageState extends State<ModuleAddEditPage> {
  final FormController formController;

  _ModuleAddEditPageState(this.formController);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formController.moduleModel.id.isEmpty
            ? 'Adicionar um môdulo'
            : 'Editar este môdulo'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formController.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputTitle(
                  label: 'Título do môdulo',
                  initialValue: formController.moduleModel.title,
                  validator: formController.validateRequiredText,
                  onChanged: (value) {
                    formController.onChange(title: value);
                  },
                ),
                InputDescription(
                  label: 'Descrição do môdulo',
                  initialValue: formController.moduleModel.description,
                  validator: formController.validateRequiredText,
                  onChanged: (value) {
                    formController.onChange(description: value);
                  },
                ),
                InputDescription(
                  label: 'Ementa do môdulo',
                  initialValue: formController.moduleModel.syllabus,
                  validator: formController.validateRequiredText,
                  onChanged: (value) {
                    formController.onChange(syllabus: value);
                  },
                ),
                TeacherSearchConnector(
                  label: 'Selecionar um professor',
                ),
                formController.moduleModel.id.isEmpty
                    ? Container()
                    : InputCheckBoxDelete(
                        title: 'Apagar este modulo',
                        subtitle: 'Remover permanentemente',
                        value: formController.moduleModel.isDeleted,
                        onChanged: (value) {
                          formController.onChange(isDeleted: value);
                          setState(() {});
                        },
                      ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload_outlined),
        onPressed: () {
          formController.onCkechValidation();
          if (formController.isFormValid) {
            widget.onSave(formController.moduleModel);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
