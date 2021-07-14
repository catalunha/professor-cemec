import 'package:professor/course/course_card_archived.dart';
import 'package:professor/course/course_model.dart';
import 'package:flutter/material.dart';

class CourseArchivedPage extends StatelessWidget {
  final List<CourseModel> courseModelList;
  final Function(String) unArchived;

  const CourseArchivedPage({
    Key? key,
    required this.courseModelList,
    required this.unArchived,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cursos arquivados'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: courseModelList
              .map((e) => CourseCardArchived(
                    courseModel: e,
                    unArchived: unArchived,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
