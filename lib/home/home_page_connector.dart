import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/home/home_page.dart';
import 'package:professor/login/login_action.dart';

import 'package:flutter/material.dart';

class HomePageConnector extends StatelessWidget {
  const HomePageConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      vm: () => HomeViewModelFactory(this),
      // onInit: (store) => store.dispatch(GetCollectionBillAction()),
      // onInit: (store) => store.dispatch(StreamDocsBillAction()),
      builder: (context, vm) => HomePage(
        signOut: vm.signOut,
        userPhotoUrl: vm.userPhotoUrl,
        // userPhoneNumber: vm.userPhoneNumber,
        userDisplayName: vm.userDisplayName,
        // userEmail: vm.userEmail,
        // userUid: vm.userUid,
      ),
    );
  }
}

class HomeViewModelFactory extends VmFactory<AppState, HomePageConnector> {
  HomeViewModelFactory(widget) : super(widget);
  @override
  HomeViewModel fromStore() => HomeViewModel(
        signOut: () => dispatch(SignOutLoginAction()),
        userPhotoUrl: state.loginState.userFirebaseAuth?.photoURL ?? '',
        userPhoneNumber: state.loginState.userFirebaseAuth?.phoneNumber ?? '',
        userDisplayName: state.loginState.userFirebaseAuth?.displayName ?? '',
        userEmail: state.loginState.userFirebaseAuth?.email ?? '',
        userUid: state.loginState.userFirebaseAuth?.uid ?? '',
      );
}

class HomeViewModel extends Vm {
  final VoidCallback signOut;

  final String userPhotoUrl;
  final String userPhoneNumber;
  final String userDisplayName;
  final String userEmail;
  final String userUid;

  HomeViewModel({
    required this.signOut,
    required this.userPhotoUrl,
    required this.userPhoneNumber,
    required this.userDisplayName,
    required this.userEmail,
    required this.userUid,
  }) : super(equals: [
          userPhotoUrl,
          userPhoneNumber,
          userDisplayName,
          userEmail,
          userUid,
        ]);
}
