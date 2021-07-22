import 'package:professor/coordinator/coordinator_card.dart';
import 'package:professor/course/controller/course_model.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:professor/user/controller/user_model.dart';
import 'package:flutter/material.dart';

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
            child:
                Text('${moduleModel.title}', style: AppTextStyles.trailingBold),
            color: Colors.blue.shade50,
          ),
          courseModel != null
              ? ListTile(
                  leading: courseModel!.iconUrl == null
                      ? Icon(AppIconData.undefined)
                      : Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(courseModel!.iconUrl!),
                            ),
                          ),
                        ),
                  title: Text(courseModel!.title),
                )
              : Container(),
          coordinator != null
              ? CoordinatorTile(coordinator: coordinator!)
              : ListTile(
                  leading: Icon(AppIconData.undefined),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: 'Descrição: ',
                        style: AppTextStyles.captionBoldBody),
                    TextSpan(
                      text: '${moduleModel.description}',
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: 'Ementa: ', style: AppTextStyles.captionBoldBody),
                    TextSpan(
                      text: '${moduleModel.syllabus}',
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${moduleModel.id}',
                // textAlign: TextAlign.start,
              ),
            ),
          ),
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
