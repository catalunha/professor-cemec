import 'package:professor/user/user_model.dart';
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
                ? Icon(Icons.person_pin_outlined)
                : Tooltip(
                    message: 'id: ${coordinator!.id}',
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(coordinator!.photoURL!),
                        ),
                      ),
                    ),
                  ),
            title: Text(coordinator!.displayName ?? ''),
            subtitle: Text(
                'email: ${coordinator!.email}\nMobile: ${coordinator!.phoneNumber ?? ""}'),
          )
        : Container();
  }
}
