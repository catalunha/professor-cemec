import 'package:flutter/material.dart';
import 'package:professor/course/controller/course_model.dart';
import 'package:professor/theme/app_icon.dart';

class CourseTile extends StatelessWidget {
  final CourseModel? courseModel;

  const CourseTile({
    Key? key,
    required this.courseModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return courseModel != null
        ? ListTile(
            leading: courseModel!.iconUrl == null
                ? Icon(AppIconData.undefined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      courseModel!.iconUrl!,
                      height: 58,
                      width: 58,
                    ),
                  ),
            title: Text(courseModel!.title),
            subtitle: Text('courseId: ${courseModel!.id}'),
          )
        : ListTile(
            leading: Icon(
              AppIconData.undefined,
            ),
            title: Text('Curso não disponivel'),
          );
  }
}
