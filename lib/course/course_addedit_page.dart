import 'package:professor/course/course_addedit_connector.dart';
import 'package:professor/course/course_model.dart';
import 'package:professor/widget/input_checkbox.dart';
import 'package:professor/widget/input_checkboxDelete.dart';
import 'package:professor/widget/input_description.dart';
import 'package:professor/widget/input_file_connector.dart';
import 'package:professor/widget/input_title.dart';
import 'package:flutter/material.dart';

class CourseAddEditPage extends StatefulWidget {
  final FormController formController;
  final Function(CourseModel) onSave;

  const CourseAddEditPage({
    Key? key,
    required this.formController,
    required this.onSave,
  }) : super(key: key);

  @override
  _CourseAddEditPageState createState() =>
      _CourseAddEditPageState(formController);
}

class _CourseAddEditPageState extends State<CourseAddEditPage> {
  final FormController formController;

  _CourseAddEditPageState(this.formController);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formController.courseModel.id.isEmpty
            ? 'Adicionar curso'
            : 'Editar curso'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formController.formKey,
            child: Column(
              children: [
                InputTitle(
                  label: 'Título do curso',
                  initialValue: formController.courseModel.title,
                  validator: formController.validateRequiredText,
                  // icon: Icons.text_format,
                  onChanged: (value) {
                    formController.onChange(title: value);
                  },
                ),
                InputDescription(
                  label: 'Descrição do curso',
                  initialValue: formController.courseModel.description,
                  validator: formController.validateRequiredText,
                  // icon: Icons.text_snippet_outlined,
                  onChanged: (value) {
                    formController.onChange(description: value);
                  },
                ),
                InputDescription(
                  label: 'Ementa do curso',
                  initialValue: formController.courseModel.syllabus,
                  validator: formController.validateRequiredText,
                  // icon: Icons.text_snippet_outlined,
                  onChanged: (value) {
                    formController.onChange(syllabus: value);
                  },
                ),
                InputFileConnector(
                  label: 'Informe o ícone do curso',
                ),
                formController.courseModel.id.isEmpty
                    ? Container()
                    : InputCheckBox(
                        title: 'Arquivar este curso',
                        subtitle: 'Arquivar este curso',
                        value: formController.courseModel.isArchivedByCoord,
                        onChanged: (value) {
                          formController.onChange(isArchivedByCoord: value);
                          setState(() {});
                        },
                      ),
                formController.courseModel.id.isEmpty
                    ? Container()
                    : InputCheckBoxDelete(
                        title: 'Apagar este curso',
                        subtitle: 'Remover permanentemente',
                        value: formController.courseModel.isDeleted,
                        onChanged: (value) {
                          formController.onChange(isDeleted: value);
                          setState(() {});
                        },
                      ),
                SizedBox(
                  height: 100,
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload_outlined),
        onPressed: () {
          formController.onCkechValidation();
          if (formController.isFormValid) {
            widget.onSave(formController.courseModel);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
