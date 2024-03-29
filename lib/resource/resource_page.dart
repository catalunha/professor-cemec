import 'package:professor/coordinator/coordinator_tile.dart';
import 'package:professor/course/controller/course_model.dart';
import 'package:professor/course/course_tile.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/resource/resource_card.dart';
import 'package:professor/resource/controller/resource_model.dart';
import 'package:professor/theme/app_colors.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:professor/user/controller/user_model.dart';
import 'package:flutter/material.dart';

class ResourcePage extends StatefulWidget {
  final UserModel? coordinator;
  final CourseModel? courseModel;
  final ModuleModel moduleModel;
  final List<ResourceModel> resourceModelList;
  final Function(List<String>) onChangeResourceOrder;

  const ResourcePage({
    Key? key,
    required this.resourceModelList,
    required this.courseModel,
    required this.moduleModel,
    this.coordinator,
    required this.onChangeResourceOrder,
  }) : super(key: key);

  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recursos deste môdulo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              // color: AppColors.secondary,
              elevation: 10,
              child: Column(
                children: [
                  CourseTile(
                    courseModel: widget.courseModel,
                  ),
                  CoordinatorTile(
                    coordinator: widget.coordinator,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.input,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  widget.moduleModel.title,
                  style: AppTextStyles.titleBoldHeading,
                ),
                Text('moduleId: ${widget.moduleModel.id}'),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ReorderableListView(
              scrollDirection: Axis.vertical,
              onReorder: _onReorder,
              children: buildItens(context),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(AppIconData.addInCloud),
        onPressed: () async {
          Navigator.pushNamed(context, '/resource_addedit', arguments: '');
        },
      ),
    );
  }

  buildItens(context) {
    List<Widget> list = [];
    Map<String, ResourceModel> map = Map.fromIterable(
      widget.resourceModelList,
      key: (element) => element.id,
      value: (element) => element,
    );
    for (var index in widget.moduleModel.resourceOrder!) {
      if (map[index] != null) {
        list.add(Container(
            key: ValueKey(index),
            child: ResourceCard(resourceModel: map[index]!)));
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
    List<String> resourceOrderTemp = widget.moduleModel.resourceOrder!;
    String resourceId = resourceOrderTemp[oldIndex];
    resourceOrderTemp.removeAt(oldIndex);
    resourceOrderTemp.insert(newIndex, resourceId);
    widget.onChangeResourceOrder(resourceOrderTemp);
  }
}
