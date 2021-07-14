import 'package:professor/teacher/teacher_card.dart';
import 'package:professor/user/user_model.dart';
import 'package:flutter/material.dart';

class TeacherList extends StatelessWidget {
  final String label;
  final List<UserModel> teacherList;
  final Function(String) onSelect;
  const TeacherList({
    Key? key,
    required this.teacherList,
    required this.onSelect,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(label),
      children: [
        SingleChildScrollView(
          child: Column(
            children: teacherList
                .map((e) => InkWell(
                    onTap: () {
                      onSelect(e.id);
                      Navigator.pop(context);
                    },
                    child: TeacherCard(teacher: e)))
                .toList(),
          ),
        ),
      ],
    );
  }
}
