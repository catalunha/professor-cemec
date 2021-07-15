import 'package:professor/course/course_model.dart';
import 'package:flutter/material.dart';
import 'package:professor/module/module_model.dart';

class ModuleCardArchived extends StatelessWidget {
  final ModuleModel moduleModel;
  final Function(String) unArchived;

  const ModuleCardArchived(
      {Key? key, required this.moduleModel, required this.unArchived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: Text(moduleModel.title),
            subtitle: Text(moduleModel.description),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                moduleModel.syllabus,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Wrap(
            children: [
              IconButton(
                icon: Icon(Icons.upcoming),
                onPressed: () {
                  unArchived(moduleModel.id);
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
