import 'package:professor/coordinator/coordinator_card.dart';
import 'package:professor/course/course_model.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/resource/resource_card.dart';
import 'package:professor/resource/resource_model.dart';
import 'package:professor/theme/app_colors.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:professor/user/user_model.dart';
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
                  widget.courseModel != null
                      ? ListTile(
                          leading: widget.courseModel!.iconUrl == null
                              ? Icon(AppIconData.undefined)
                              : Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.courseModel!.iconUrl!),
                                    ),
                                  ),
                                ),
                          title: Text(widget.courseModel!.title),
                          subtitle: Text(widget.courseModel!.id),
                        )
                      : ListTile(
                          leading: Icon(AppIconData.undefined),
                        ),
                  widget.coordinator != null
                      ? CoordinatorTile(coordinator: widget.coordinator!)
                      : ListTile(
                          leading: Icon(AppIconData.undefined),
                        ),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            color: AppColors.input,
            alignment: Alignment.topCenter,
            child: Text(
              widget.moduleModel.title,
              style: AppTextStyles.titleBoldHeading,
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
          // SizedBox(
          //   height: 40,
          // )
          // Padding(
          //   padding: const EdgeInsets.only(left: 8, top: 4, right: 8),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(25)),
          //     elevation: 10,
          //     color: Colors.lightBlueAccent,
          //     child: Column(
          //       children: [
          //         Text(
          //           moduleModel.title,
          //           style: AppTextStyles.titleBoldHeading,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: widget.resourceModelList
          //           .map((e) => ResourceCard(resourceModel: e))
          //           .toList(),
          //     ),
          //   ),
          // ),
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
