import 'package:professor/theme/app_colors.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userPhotoUrl;
  final String userDisplayName;
  final VoidCallback signOut;

  const HomePage({
    Key? key,
    required this.userPhotoUrl,
    required this.userDisplayName,
    required this.signOut,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125),
          child: Container(
            height: 90,
            color: AppColors.primary,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: ListTile(
                    onTap: widget.signOut,
                    title: Text(
                      'Olá ${widget.userDisplayName}',
                      style: AppTextStyles.titleRegular,
                    ),
                    trailing: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(widget.userPhotoUrl),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Bem vindo ao aplicativo para PROFESSORES de cursos no CEMEC.',
            style: AppTextStyles.titleHome,
          ),
        ));
  }
}
