import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/home/home_page.dart';
import 'package:professor/login/controller/login_action.dart';

import 'package:flutter/material.dart';
import 'package:professor/module/controller/module_action.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/module/controller/module_state.dart';

class HomePageConnector extends StatelessWidget {
  const HomePageConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      vm: () => HomeViewModelFactory(this),
      onInit: (store) => store.dispatch(StreamDocsModuleAction()),
      builder: (context, vm) => HomePage(
        signOut: vm.signOut,
        photoUrl: vm.photoUrl,
        phoneNumber: vm.phoneNumber,
        displayName: vm.displayName,
        uid: vm.uid,
        id: vm.id,
        email: vm.email,
        moduleModelList: vm.moduleModelList,
      ),
    );
  }
}

class HomeViewModelFactory extends VmFactory<AppState, HomePageConnector> {
  HomeViewModelFactory(widget) : super(widget);
  @override
  HomeViewModel fromStore() => HomeViewModel(
        signOut: () => dispatch(SignOutLoginAction()),
        photoUrl: state.userState.userCurrent!.photoURL ?? '',
        phoneNumber: state.userState.userCurrent!.phoneNumber ?? '',
        displayName: state.userState.userCurrent!.displayName ?? '',
        email: state.userState.userCurrent!.email,
        uid: state.loginState.userFirebaseAuth?.uid ?? '',
        id: state.userState.userCurrent!.id,
        moduleModelList: ModuleState.selectModuleNotArchived(state),
      );
}

class HomeViewModel extends Vm {
  final VoidCallback signOut;

  final String displayName;
  final String photoUrl;
  final String phoneNumber;
  final String email;
  final String uid;
  final String id;

  final List<ModuleModel> moduleModelList;

  HomeViewModel({
    required this.signOut,
    required this.photoUrl,
    required this.phoneNumber,
    required this.displayName,
    required this.email,
    required this.uid,
    required this.id,
    required this.moduleModelList,
  }) : super(equals: [
          photoUrl,
          phoneNumber,
          displayName,
          email,
          uid,
          id,
          moduleModelList,
        ]);
}
