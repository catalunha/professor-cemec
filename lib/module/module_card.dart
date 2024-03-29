import 'package:professor/coordinator/coordinator_tile.dart';
import 'package:professor/course/controller/course_model.dart';
import 'package:professor/course/course_tile.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:professor/user/controller/user_model.dart';
import 'package:flutter/material.dart';
import 'package:professor/widget/text_description.dart';

class ModuleCard extends StatelessWidget {
  final ModuleModel moduleModel;
  final UserModel? coordinator;
  final CourseModel? courseModel;
  final VoidCallback onArchiveModule;

  const ModuleCard(
      {Key? key,
      required this.moduleModel,
      required this.coordinator,
      required this.courseModel,
      required this.onArchiveModule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 2,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.topCenter,
            child: Text(
              '${moduleModel.title}',
              style: AppTextStyles.trailingBold,
            ),
            color: Colors.blue.shade50,
          ),
          CourseTile(
            courseModel: courseModel,
          ),
          CoordinatorTile(
            coordinator: coordinator,
          ),
          TextDescription(
            firstWord: 'Descrição: ',
            text: moduleModel.description,
          ),
          TextDescription(
            firstWord: 'Ementa: ',
            text: moduleModel.syllabus,
          ),
          TextDescription(
            firstWord: 'moduleId: ',
            text: moduleModel.id,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: RichText(
          //       text: TextSpan(
          //         style: DefaultTextStyle.of(context).style,
          //         children: [
          //           TextSpan(
          //               text: 'Descrição: ',
          //               style: AppTextStyles.captionBoldBody),
          //           TextSpan(
          //             text: '${moduleModel.description}',
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: RichText(
          //       text: TextSpan(
          //         style: DefaultTextStyle.of(context).style,
          //         children: [
          //           TextSpan(
          //               text: 'Ementa: ', style: AppTextStyles.captionBoldBody),
          //           TextSpan(
          //             text: '${moduleModel.syllabus}',
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: Text(
          //       '${moduleModel.id}',
          //       // textAlign: TextAlign.start,
          //     ),
          //   ),
          // ),
          Wrap(
            spacing: 50,
            children: [
              IconButton(
                tooltip: 'Editar recursos deste môdulo',
                icon: Icon(AppIconData.resourse),
                onPressed: () async {
                  Navigator.pushNamed(context, '/resource',
                      arguments: moduleModel.id);
                },
              ),
              IconButton(
                tooltip: 'Ver situações para este môdulo',
                icon: Icon(AppIconData.situation),
                onPressed: () async {
                  Navigator.pushNamed(context, '/situation',
                      arguments: moduleModel.id);
                },
              ),
              IconButton(
                tooltip: 'Arquivar este môdulo',
                icon: Icon(AppIconData.archived),
                onPressed: onArchiveModule,
              ),
            ],
          )
        ],
      ),
    );
  }
}
