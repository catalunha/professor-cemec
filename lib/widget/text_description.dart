import 'package:flutter/material.dart';

import 'package:professor/theme/app_text_styles.dart';

class TextDescription extends StatelessWidget {
  final String firstWord;
  final String text;
  const TextDescription({
    Key? key,
    required this.firstWord,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(text: firstWord, style: AppTextStyles.captionBoldBody),
              TextSpan(
                text: text,
              )
            ],
          ),
        ),
      ),
    );
  }
}
