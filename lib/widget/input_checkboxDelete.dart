import 'package:professor/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:professor/theme/app_icon.dart';

class InputCheckBoxDelete extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool? value;
  final void Function(bool?) onChanged;

  const InputCheckBoxDelete(
      {Key? key,
      required this.title,
      required this.onChanged,
      this.value,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Text(title),
          color: Colors.black12,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                AppIconData.delete,
                color: AppColors.delete,
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: AppColors.stroke,
            ),
            Expanded(
              child: CheckboxListTile(
                activeColor: AppColors.delete,
                selectedTileColor: AppColors.delete,
                selected: value!,
                controlAffinity: ListTileControlAffinity.leading,
                title: value!
                    ? Text(
                        subtitle,
                        style: TextStyle(color: AppColors.stroke),
                      )
                    : Text(subtitle),
                onChanged: onChanged,
                value: value,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
