import 'package:professor/module/controller/module_card_connector.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/theme/app_colors.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String photoUrl;
  final String displayName;
  final String email;
  final String uid;
  final String id;
  final VoidCallback signOut;
  final List<ModuleModel> moduleModelList;
  const HomePage({
    Key? key,
    required this.photoUrl,
    required this.displayName,
    required this.signOut,
    required this.email,
    required this.moduleModelList,
    required this.uid,
    required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          // height: 110,
          color: AppColors.primary,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: ListTile(
                  onTap: signOut,
                  title: Text(
                    'Olá, $displayName',
                    style: AppTextStyles.titleRegular,
                  ),
                  subtitle: Text('Môdulos em que você é PROFESSOR(A).'),
                  trailing: Tooltip(
                    message: 'email: $email\nid: $id\nuid: $uid',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        photoUrl,
                        height: 58,
                        width: 58,
                      ),
                    ),
                    // child: Container(
                    //   height: 48,
                    //   width: 48,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     image: DecorationImage(
                    //       image: NetworkImage(photoUrl),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topRight,
              child: Wrap(
                children: [
                  IconButton(
                      tooltip: 'Ir para môdulos arquivados',
                      onPressed: () => Navigator.pushNamed(
                            context,
                            '/module_archived',
                          ),
                      icon: Icon(AppIconData.archived))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: SingleChildScrollView(
              child: Column(
                children: moduleModelList
                    .map((e) => ModuleCardConnector(
                          moduleModel: e,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
