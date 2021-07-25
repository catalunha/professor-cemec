import 'package:flutter/material.dart';
import 'package:professor/coordinator/coordinator_tile.dart';

import 'package:professor/course/controller/course_model.dart';
import 'package:professor/course/course_tile.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/situation/controller/situation_model.dart';
import 'package:professor/situation/situation_card.dart';
import 'package:professor/theme/app_colors.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:professor/user/controller/user_model.dart';

class SituationPage extends StatefulWidget {
  final CourseModel? courseModel;
  final UserModel? coordinator;
  final ModuleModel moduleModel;
  final List<SituationModel> situationList;
  final Function(List<String>) onChangeSituationOrder;
  const SituationPage({
    Key? key,
    this.courseModel,
    this.coordinator,
    required this.moduleModel,
    required this.situationList,
    required this.onChangeSituationOrder,
  }) : super(key: key);

  @override
  _SituationPageState createState() => _SituationPageState();
}

class _SituationPageState extends State<SituationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Situações para este môdulo'),
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
          Navigator.pushNamed(context, '/situation_addedit', arguments: '');
        },
      ),
    );
  }

  buildItens(context) {
    List<Widget> list = [];
    Map<String, SituationModel> map = Map.fromIterable(
      widget.situationList,
      key: (element) => element.id,
      value: (element) => element,
    );
    for (var index in widget.moduleModel.situationOrder!) {
      if (map[index] != null) {
        list.add(Container(
            key: ValueKey(index),
            child: SituationCard(situationModel: map[index]!)));
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
    List<String> situationOrderTemp = widget.moduleModel.situationOrder!;
    String situationId = situationOrderTemp[oldIndex];
    situationOrderTemp.removeAt(oldIndex);
    situationOrderTemp.insert(newIndex, situationId);
    widget.onChangeSituationOrder(situationOrderTemp);
  }
}
