import 'package:professor/module/module_card_archived.dart';
import 'package:professor/module/module_model.dart';
import 'package:flutter/material.dart';

class ModuleArchivedPage extends StatelessWidget {
  final List<ModuleModel> moduleModelList;
  final Function(String) unArchived;

  const ModuleArchivedPage({
    Key? key,
    required this.moduleModelList,
    required this.unArchived,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Môdulos arquivados'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: moduleModelList
              .map((e) => ModuleCardArchived(
                    moduleModel: e,
                    unArchived: unArchived,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
