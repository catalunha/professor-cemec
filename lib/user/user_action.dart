import 'package:async_redux/async_redux.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:professor/app_state.dart';
import 'package:professor/login/login_action.dart';
import 'package:professor/user/user_model.dart';
import 'package:professor/user/user_state.dart';

class ChangeStatusFirestoreUserUserAction extends ReduxAction<AppState> {
  final StatusFirestoreUser statusFirestoreUser;

  ChangeStatusFirestoreUserUserAction({required this.statusFirestoreUser});
  @override
  AppState reduce() {
    return state.copyWith(
        userState: state.userState.copyWith(
      statusFirestoreUser: statusFirestoreUser,
    ));
  }
}

class GetDocUserAsyncUserAction extends ReduxAction<AppState> {
  final String uid;

  GetDocUserAsyncUserAction({required this.uid});
  @override
  Future<AppState> reduce() async {
    dispatch(ChangeStatusFirestoreUserUserAction(
        statusFirestoreUser: StatusFirestoreUser.checkingInFirestore));
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var querySnapshot = await firebaseFirestore
        .collection(UserModel.collection)
        .where('uid', isEqualTo: uid)
        .get();
    var userModelList = querySnapshot.docs
        .map((queryDocumentSnapshot) => UserModel.fromMap(
            queryDocumentSnapshot.id, queryDocumentSnapshot.data()))
        .toList();
    print('--> GetDocUserAsyncUserAction: ${userModelList.length}');
    if (userModelList.length == 1) {
      UserModel userModel = userModelList[0];
      print('--> GetDocUserAsyncUserAction: ' + userModel.toString());
      return state.copyWith(
        userState: state.userState.copyWith(
          userCurrent: userModel,
          statusFirestoreUser: StatusFirestoreUser.inFirestore,
        ),
      );
    } else {
      print('--> GetDocUserAsyncUserAction: users NAO encontrado');
      dispatch(SignOutLoginAction());
      return state.copyWith(
        userState: state.userState.copyWith(
          statusFirestoreUser: StatusFirestoreUser.outFirestore,
        ),
      );
    }
  }
}
