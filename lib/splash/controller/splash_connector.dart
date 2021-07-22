import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/home/controller/home_page_connector.dart';
import 'package:professor/login/controller/login_action.dart';
import 'package:professor/login/controller/login_connector.dart';
import 'package:professor/login/controller/login_state.dart';
import 'package:professor/splash/splash_page.dart';
import 'package:professor/user/controller/user_state.dart';
import 'package:flutter/material.dart';

class SplashConnector extends StatelessWidget {
  const SplashConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashViewModel>(
        vm: () => SplashViewModelFactory(this),
        builder: (context, vm) {
          if (vm.isUnInitialized) {
            vm.startLogin();
          }
          if (vm.isAuthenticated && vm.isInFirestore) {
            print('--> vm.isAuthenticated && vm.isInFirestore : true');
            return HomePageConnector();
          }
          if (vm.isUnAuthenticated && !vm.isAuthenticating) {
            print(
                '--> vm.isUnAuthenticated:true || !vm.isAuthenticating: true');
            return LoginConnector();
          }
          return SplashPage(
            isUnInitialized: vm.isUnInitialized,
            isAuthenticating: vm.isAuthenticating,
            isAuthenticated: vm.isAuthenticated,
            isUnAuthenticated: vm.isUnAuthenticated,
            isUnInitializedFirestore: vm.isUnInitializedFirestore,
            isCheckingInFirestore: vm.isCheckingInFirestore,
            isInFirestore: vm.isInFirestore,
            isOutFirestore: vm.isOutFirestore,
          );
        });
  }
}

class SplashViewModelFactory extends VmFactory<AppState, SplashConnector> {
  SplashViewModelFactory(widget) : super(widget);

  @override
  SplashViewModel fromStore() {
    return SplashViewModel(
      isUnInitialized: state.loginState.statusFirebaseAuth ==
          StatusFirebaseAuth.unInitialized,
      isAuthenticating: state.loginState.statusFirebaseAuth ==
          StatusFirebaseAuth.authenticating,
      isAuthenticated: state.loginState.statusFirebaseAuth ==
          StatusFirebaseAuth.authenticated,
      isUnAuthenticated: state.loginState.statusFirebaseAuth ==
          StatusFirebaseAuth.unAuthenticated,
      isUnInitializedFirestore: state.userState.statusFirestoreUser ==
          StatusFirestoreUser.unInitialized,
      isCheckingInFirestore: state.userState.statusFirestoreUser ==
          StatusFirestoreUser.checkingInFirestore,
      isInFirestore: state.userState.statusFirestoreUser ==
          StatusFirestoreUser.inFirestore,
      isOutFirestore: state.userState.statusFirestoreUser ==
          StatusFirestoreUser.outFirestore,
      startLogin: () async {
        // await Future.delayed(Duration(seconds: 5));
        dispatch(CheckLoginAction());
      },
    );
  }
}

class SplashViewModel extends Vm {
  final bool isUnInitialized;
  final bool isAuthenticating;
  final bool isAuthenticated;
  final bool isUnAuthenticated;
  final bool isUnInitializedFirestore;
  final bool isCheckingInFirestore;
  final bool isInFirestore;
  final bool isOutFirestore;
  final VoidCallback startLogin;

  SplashViewModel({
    required this.isUnInitialized,
    required this.isAuthenticating,
    required this.isAuthenticated,
    required this.isUnAuthenticated,
    required this.isUnInitializedFirestore,
    required this.isCheckingInFirestore,
    required this.isInFirestore,
    required this.isOutFirestore,
    required this.startLogin,
  }) : super(equals: [
          isUnInitialized,
          isAuthenticating,
          isAuthenticated,
          isUnAuthenticated,
          isUnInitializedFirestore,
          isCheckingInFirestore,
          isInFirestore,
          isOutFirestore,
        ]);
}
