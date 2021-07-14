import 'package:professor/login/google_login_button.dart';
import 'package:professor/theme/app_colors.dart';
import 'package:professor/theme/app_images.dart';
import 'package:professor/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback signIn;
  const LoginPage({
    Key? key,
    required this.signIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.4,
              color: AppColors.primary,
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Image.asset(
                    AppImages.person,
                    width: 208,
                    height: 273,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      'Bem vindo ao CEMEC',
                      style: AppTextStyles.titleRegular,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      'Professor',
                      style: AppTextStyles.titleHome,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  GoogleLoginButton(
                    onTap: signIn,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
