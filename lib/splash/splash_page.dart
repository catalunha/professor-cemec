import 'package:professor/theme/app_colors.dart';
import 'package:professor/theme/app_images.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  final bool isUnInitialized;
  final bool isAuthenticating;
  final bool isAuthenticated;
  final bool isUnAuthenticated;
  final bool isUnInitializedFirestore;
  final bool isCheckingInFirestore;
  final bool isInFirestore;
  final bool isOutFirestore;
  const SplashPage(
      {Key? key,
      required this.isUnInitialized,
      required this.isAuthenticating,
      required this.isAuthenticated,
      required this.isUnAuthenticated,
      required this.isUnInitializedFirestore,
      required this.isCheckingInFirestore,
      required this.isInFirestore,
      required this.isOutFirestore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(child: Image.asset(AppImages.union)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isUnInitialized
                  ? Text('unInitialized: true')
                  : Text('unInitialized: false'),
              isAuthenticating
                  ? Text('authenticating: true')
                  : Text('authenticating: false'),
              isAuthenticated
                  ? Text('authenticated: true')
                  : Text('authenticated: false'),
              isUnAuthenticated
                  ? Text('unAuthenticated: true')
                  : Text('unAuthenticated: false'),
              isUnInitializedFirestore
                  ? Text('unInitializedFirestore: true')
                  : Text('unInitializedFirestore: false'),
              isCheckingInFirestore
                  ? Text('checkingInFirestore: true')
                  : Text('checkingInFirestore: false'),
              isInFirestore
                  ? Text('inFirestore: true')
                  : Text('inFirestore: false'),
              isOutFirestore
                  ? Text('outFirestore: true')
                  : Text('outFirestore: false'),
            ],
          ),
        ],
      ),
    );
  }
}
