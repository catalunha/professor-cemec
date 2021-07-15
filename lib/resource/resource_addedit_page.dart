import 'package:professor/resource/resource_addedit_connector.dart';
import 'package:professor/resource/resource_model.dart';
import 'package:professor/widget/input_checkboxDelete.dart';
import 'package:professor/widget/input_description.dart';
import 'package:professor/widget/input_file_connector.dart';
import 'package:professor/widget/input_title.dart';
import 'package:flutter/material.dart';
import 'package:professor/widget/input_url.dart';

class ResourceAddEditPage extends StatefulWidget {
  final FormController formController;
  final Function(ResourceModel, urlOrFile) onSave;

  const ResourceAddEditPage({
    Key? key,
    required this.formController,
    required this.onSave,
  }) : super(key: key);

  @override
  _ResourceAddEditPageState createState() =>
      _ResourceAddEditPageState(formController);
}

class _ResourceAddEditPageState extends State<ResourceAddEditPage> {
  final FormController formController;

  urlOrFile? urlOrFileSelected;
  _ResourceAddEditPageState(this.formController);
  @override
  void initState() {
    super.initState();
    urlOrFileSelected = formController.resourceModel.url == null
        ? urlOrFile.empty
        : urlOrFile.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formController.resourceModel.id.isEmpty
            ? 'Adicionar recurso'
            : 'Editar recurso'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formController.formKey,
            child: Column(
              children: [
                InputTitle(
                  label: 'Título do recurso',
                  initialValue: formController.resourceModel.title,
                  validator: formController.validateRequiredText,
                  // icon: Icons.text_format,
                  onChanged: (value) {
                    formController.onChange(title: value);
                  },
                ),
                InputDescription(
                  label: 'Descrição do recurso',
                  initialValue: formController.resourceModel.description,
                  validator: formController.validateRequiredText,
                  // icon: Icons.text_snippet_outlined,
                  onChanged: (value) {
                    formController.onChange(description: value);
                  },
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Text('Decida sobre o link deste recurso'),
                  color: Colors.yellow,
                ),
                RadioListTile<urlOrFile>(
                  title: const Text('Recurso sem link'),
                  value: urlOrFile.empty,
                  groupValue: urlOrFileSelected,
                  onChanged: (urlOrFile? value) {
                    setState(() {
                      urlOrFileSelected = value;
                    });
                  },
                ),
                RadioListTile<urlOrFile>(
                  title: const Text('Informar o link manualmente'),
                  value: urlOrFile.url,
                  groupValue: urlOrFileSelected,
                  onChanged: (urlOrFile? value) {
                    setState(() {
                      urlOrFileSelected = value;
                    });
                  },
                ),
                RadioListTile<urlOrFile>(
                  title: const Text('Enviar um arquivo'),
                  value: urlOrFile.file,
                  groupValue: urlOrFileSelected,
                  onChanged: (urlOrFile? value) {
                    setState(() {
                      urlOrFileSelected = value;
                    });
                  },
                ),
                urlOrFile.url == urlOrFileSelected
                    ? InputUrl(
                        label: 'Informe o link manualmente',
                        initialValue: formController.resourceModel.url,
                        // validator: formController.validateUrl,
                        validator: urlOrFile.empty != urlOrFileSelected
                            ? formController.validateUrl
                            : null,
                        // icon: Icons.link,
                        onChanged: (value) async {
                          formController.onChange(url: value);
                        },
                      )
                    : Container(),
                urlOrFile.file == urlOrFileSelected
                    ? InputFileConnector(
                        label: 'Enviar o arquivo do recurso',
                      )
                    : Container(),
                formController.resourceModel.id.isEmpty
                    ? Container()
                    : InputCheckBoxDelete(
                        title: 'Apagar este recurso',
                        subtitle: 'Remover permanentemente',
                        value: formController.resourceModel.isDeleted,
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
            widget.onSave(formController.resourceModel, urlOrFileSelected!);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
