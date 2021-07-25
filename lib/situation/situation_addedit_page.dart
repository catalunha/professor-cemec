import 'package:flutter/material.dart';
import 'package:professor/situation/controller/situation_addedit_connector.dart';
import 'package:professor/situation/controller/situation_model.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:professor/widget/input_description.dart';
import 'package:professor/widget/input_title.dart';

class SituationAddEditPage extends StatefulWidget {
  final FormController formController;
  final Function(SituationModel) onSave;

  const SituationAddEditPage({
    Key? key,
    required this.formController,
    required this.onSave,
  }) : super(key: key);

  @override
  _SituationAddEditPageState createState() =>
      _SituationAddEditPageState(formController);
}

enum ChoiceOrReport { choice, report }

class _SituationAddEditPageState extends State<SituationAddEditPage> {
  final FormController formController;
  ChoiceOrReport? choiceOrReportSelected;

  _SituationAddEditPageState(this.formController);
  @override
  void initState() {
    super.initState();
    choiceOrReportSelected = formController.situationModel.type == 'report'
        ? ChoiceOrReport.report
        : ChoiceOrReport.choice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formController.situationModel.id.isEmpty
            ? 'Adicionar situação'
            : 'Editar situação'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formController.formKey,
            child: Column(
              children: [
                InputTitle(
                  label: 'Título da situação',
                  initialValue: formController.situationModel.title,
                  validator: formController.validateRequiredText,
                  onChanged: (value) {
                    formController.onChange(title: value);
                  },
                ),
                InputDescription(
                  label: 'Descrição da situação',
                  initialValue: formController.situationModel.description,
                  validator: formController.validateRequiredText,
                  onChanged: (value) {
                    formController.onChange(description: value);
                  },
                ),
                InputDescription(
                  label: 'Proposta da situação',
                  initialValue: formController.situationModel.proposalUrl,
                  validator: formController.validateRequiredText,
                  onChanged: (value) {
                    formController.onChange(proposalUrl: value);
                  },
                ),
                InputDescription(
                  label: 'Solução da situação',
                  initialValue: formController.situationModel.solutionUrl,
                  validator: formController.validateRequiredText,
                  onChanged: (value) {
                    formController.onChange(solutionUrl: value);
                  },
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Text('Decida sobre o tipo de situação'),
                  color: Colors.yellow,
                ),
                RadioListTile<ChoiceOrReport>(
                  title: const Text('Relatório'),
                  value: ChoiceOrReport.report,
                  groupValue: choiceOrReportSelected,
                  onChanged: (ChoiceOrReport? value) {
                    setState(() {
                      choiceOrReportSelected = value;
                    });
                  },
                ),
                RadioListTile<ChoiceOrReport>(
                  title: const Text('Escolha única'),
                  value: ChoiceOrReport.choice,
                  groupValue: choiceOrReportSelected,
                  onChanged: (ChoiceOrReport? value) {
                    setState(() {
                      choiceOrReportSelected = value;
                    });
                  },
                ),
                choiceOrReportSelected == ChoiceOrReport.choice
                    ? Container(
                        color: Colors.red,
                      )
                    : Container(),
                SizedBox(
                  height: 100,
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(AppIconData.saveInCloud),
        onPressed: () {
          formController.onCkechValidation();
          if (formController.isFormValid) {
            widget.onSave(formController.situationModel);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
