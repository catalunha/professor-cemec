import 'package:professor/theme/app_icon.dart';
import 'package:professor/user/controller/user_model.dart';
import 'package:flutter/material.dart';

class CoordinatorTile extends StatelessWidget {
  final UserModel? coordinator;
  const CoordinatorTile({Key? key, required this.coordinator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return coordinator != null
        ? ListTile(
            leading: coordinator!.photoURL == null
                ? Icon(AppIconData.undefined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      coordinator!.photoURL!,
                      height: 58,
                      width: 58,
                    ),
                  ),
            // : Tooltip(
            //     message: 'id: ${coordinator!.id}',
            //     child: Container(
            //       height: 48,
            //       width: 48,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(5),
            //         image: DecorationImage(
            //           image: NetworkImage(coordinator!.photoURL!),
            //         ),
            //       ),
            //     ),
            //   ),
            title: Text(coordinator!.displayName ?? ''),
            subtitle: Text(
                'email: ${coordinator!.email}\nuserId: ${coordinator!.id}'),
          )
        : ListTile(
            leading: Icon(
              AppIconData.undefined,
            ),
            title: Text('Coordenador não disponivel'),
          );
  }
}
