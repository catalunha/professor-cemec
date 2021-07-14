import 'package:professor/coordinator/coordinator_card.dart';
import 'package:professor/course/course_model.dart';
import 'package:professor/module/module_model.dart';
import 'package:professor/resource/resource_card.dart';
import 'package:professor/resource/resource_model.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:professor/user/user_model.dart';
import 'package:flutter/material.dart';

class ResourcePage extends StatelessWidget {
  final UserModel? coordinator;
  final CourseModel? courseModel;
  final ModuleModel moduleModel;
  final List<ResourceModel> resourceModelList;

  const ResourcePage({
    Key? key,
    required this.resourceModelList,
    required this.courseModel,
    required this.moduleModel,
    this.coordinator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recursos deste curso e môdulo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.lightBlue,
              elevation: 10,
              child: Column(
                children: [
                  courseModel != null
                      ? ListTile(
                          leading: courseModel!.iconUrl == null
                              ? Icon(Icons.favorite_outline_rounded)
                              : Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(courseModel!.iconUrl!),
                                    ),
                                  ),
                                ),
                          title: Text(courseModel!.title),
                        )
                      : ListTile(
                          leading: Icon(Icons.desktop_access_disabled_sharp),
                        ),
                  coordinator != null
                      ? CoordinatorTile(coordinator: coordinator!)
                      : ListTile(
                          leading: Icon(Icons.person_off_outlined),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4, right: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              color: Colors.lightBlueAccent,
              child: Column(
                children: [
                  Text(
                    moduleModel.title,
                    style: AppTextStyles.titleBoldHeading,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: resourceModelList
                    .map((e) => ResourceCard(resourceModel: e))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Navigator.pushNamed(context, '/course_addedit', arguments: '');
        },
      ),
    );
  }
}
