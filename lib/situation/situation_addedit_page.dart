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
enum Options { sim, nao, a, b, c, d, e }
// extension OptionsExtension on Options {
//   static const names = {
//     Options.sim: 'Sim',
//     Options.n: 'Sim',
//     Options.sim: 'Sim',
//     Options.sim: 'Sim',
//     Options.sim: 'Sim',

//   };
//   String get name => names[this]!;
// }
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
              // mainAxisSize: MainAxisSize.min,
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
                      formController.onChange(type: 'report');
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
                      formController.onChange(type: 'choice');
                    });
                  },
                ),
                choiceOrReportSelected == ChoiceOrReport.choice
                    ? Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          // Divider(),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            child: Text('Clique nas opções que deseja'),
                            color: Colors.black12,
                          ),
                          Wrap(
                            children: [
                              IconButton(
                                onPressed: () => addorRemoveItem('Sim'),
                                icon: Text('Sim'),
                              ),
                              IconButton(
                                  onPressed: () => addorRemoveItem('Não'),
                                  icon: Text('Não')),
                              IconButton(
                                  onPressed: () => addorRemoveItem('A'),
                                  icon: Text('A')),
                              IconButton(
                                  onPressed: () => addorRemoveItem('B'),
                                  icon: Text('B')),
                              IconButton(
                                  onPressed: () => addorRemoveItem('C'),
                                  icon: Text('C')),
                              IconButton(
                                  onPressed: () => addorRemoveItem('D'),
                                  icon: Text('D')),
                              IconButton(
                                  onPressed: () => addorRemoveItem('E'),
                                  icon: Text('E')),
                            ],
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: buildItens(context),
                            ),
                          ),
                          // buildItens(context),
                          // Container(
                          //   height: 100,
                          //   child: ReorderableListView(
                          //     scrollDirection: Axis.vertical,
                          //     onReorder: _onReorder,
                          //     children: buildItens(context),
                          //   ),
                          // ),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            child: Text('======='),
                            color: Colors.black12,
                          ),
                        ],
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

  addorRemoveItem(String item) {
    List<String> temp = formController.situationModel.options!;
    if (temp.contains(item)) {
      temp.remove(item);
    } else {
      temp.add(item);
    }
    formController.onChange(options: temp);
    setState(() {});
  }

  buildItens(context) {
    List<Widget> list = [];
    // Map<String, String> map = Map.fromIterable(
    //   widget.formController.situationModel.options!,
    //   key: (element) => element.id,
    //   value: (element) => element,
    // );
    for (var index in widget.formController.situationModel.options!) {
      // if (map[index] != null) {
      // list.add(
      //   Container(
      //     key: ValueKey(index),
      //     child: Text(index),
      //   ),
      // );
      // }
      list.add(RadioListTile<String>(
        value: index,
        groupValue: widget.formController.situationModel.choice,
        onChanged: (index) => setState(() {
          formController.onChange(choice: index);
        }),
        title: Text(index),
      ));
    }
    setState(() {});
    return list;
  }

  // buildItens(context) {
  //   return ListView.builder(
  //     itemBuilder: (context, index) {
  //       return RadioListTile(
  //         value: index,
  //         groupValue: widget.formController.situationModel.options![index],
  //         onChanged: (ind) => setState(() {
  //           formController.onChange(
  //               choice: widget.formController.situationModel.options![index]);
  //         }),
  //         title:
  //             Text('${widget.formController.situationModel.options![index]}'),
  //       );
  //     },
  //     itemCount: widget.formController.situationModel.options!.length,
  //   );
  // }

  // void _onReorder(int oldIndex, int newIndex) {
  //   setState(() {
  //     if (newIndex > oldIndex) {
  //       newIndex -= 1;
  //     }
  //   });
  //   List<String> optionsTemp = widget.formController.situationModel.options!;
  //   String resourceId = optionsTemp[oldIndex];
  //   optionsTemp.removeAt(oldIndex);
  //   optionsTemp.insert(newIndex, resourceId);
  //   formController.onChange(options: optionsTemp);
  //   // widget.onChangeChoiceOrder(resourceOrderTemp);
  // }
}
