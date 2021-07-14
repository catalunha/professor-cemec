import 'package:professor/course/course_model.dart';
import 'package:professor/module/module_card_connector.dart';
import 'package:professor/module/module_model.dart';
import 'package:flutter/material.dart';

class ModulePage extends StatefulWidget {
  final CourseModel courseModel;
  final List<ModuleModel> moduleModelList;
  final Function(List<String>) onChangeModuleOrder;

  const ModulePage({
    Key? key,
    required this.moduleModelList,
    required this.courseModel,
    required this.onChangeModuleOrder,
  }) : super(key: key);

  @override
  _ModulePageState createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Módulos deste curso'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4, right: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              color: Colors.lightBlue,
              child: Column(
                children: [
                  ListTile(
                    leading: widget.courseModel.iconUrl == null
                        ? Icon(Icons.favorite_outline_rounded)
                        : Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.courseModel.iconUrl!),
                              ),
                            ),
                          ),
                    title: Text(widget.courseModel.title),
                    subtitle: Text(
                        'Com ${widget.courseModel.moduleOrder!.length} môdulos.'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              scrollDirection: Axis.vertical,
              onReorder: _onReorder,
              children: buildItens(context),
            ),
          ),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: moduleModelList
          //           .map((e) => ModuleCardConnector(moduleModel: e))
          //           .toList(),
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.pushNamed(context, '/module_addedit', arguments: '');
        },
      ),
    );
  }

  buildItens(context) {
    List<Widget> list = [];
    Map<String, ModuleModel> map = Map.fromIterable(
      widget.moduleModelList,
      key: (element) => element.id,
      value: (element) => element,
    );
    for (var index in widget.courseModel.moduleOrder!) {
      if (map[index] != null) {
        list.add(Container(
            key: ValueKey(index),
            child: ModuleCardConnector(moduleModel: map[index]!)));
      }
    }
    setState(() {});
    return list;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
    });
    List<String> moduleOrderTemp = widget.courseModel.moduleOrder!;
    String moduleId = moduleOrderTemp[oldIndex];
    moduleOrderTemp.removeAt(oldIndex);
    moduleOrderTemp.insert(newIndex, moduleId);
    widget.onChangeModuleOrder(moduleOrderTemp);
  }
}
