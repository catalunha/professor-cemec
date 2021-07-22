import 'package:async_redux/async_redux.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:professor/app_state.dart';
import 'package:professor/login/controller/login_action.dart';
import 'package:professor/user/controller/user_model.dart';
import 'package:professor/user/controller/user_state.dart';

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

class GetDocGoogleAccountUserAction extends ReduxAction<AppState> {
  final String uid;

  GetDocGoogleAccountUserAction({required this.uid});
  @override
  Future<AppState> reduce() async {
    dispatch(ChangeStatusFirestoreUserUserAction(
        statusFirestoreUser: StatusFirestoreUser.checkingInFirestore));
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var querySnapshot = await firebaseFirestore
        .collection(UserModel.collection)
        .where('uid', isEqualTo: uid)
        .get();
    var documentListMapIdData = querySnapshot.docs
        .map((queryDocumentSnapshot) =>
            {'${queryDocumentSnapshot.id}': queryDocumentSnapshot.data()})
        .toList();
    print('--> GetDocUserAsyncUserAction: $documentListMapIdData');
    if (documentListMapIdData.length == 1) {
      Map<String, Map<String, dynamic>> documentMapIdData =
          documentListMapIdData.first;
      String documentId = documentMapIdData.keys.first;
      Map<String, dynamic> documentData = documentMapIdData.values.first;
      if (documentData['isActive'] == true &&
          documentData['appList'].contains('teacher')) {
        await dispatch(UpdateDocWithGoogleAccountUserAction(id: documentId));
        await dispatch(ReadDocUserUserAction(id: documentId));
        return state.copyWith(
          userState: state.userState.copyWith(
            statusFirestoreUser: StatusFirestoreUser.inFirestore,
          ),
        );
      } else {
        await dispatch(UpdateDocWithGoogleAccountUserAction(id: documentId));
        dispatch(SignOutLoginAction());
        return state.copyWith(
          userState: state.userState.copyWith(
            statusFirestoreUser: StatusFirestoreUser.outFirestore,
          ),
        );
      }
    } else {
      print('--> GetDocUserAsyncUserAction: users NAO encontrado');
      await dispatch(CreateDocWithGoogleAccountUserAction());
      dispatch(SignOutLoginAction());
      return state.copyWith(
        userState: state.userState.copyWith(
          statusFirestoreUser: StatusFirestoreUser.outFirestore,
        ),
      );
    }
  }
}

class ReadDocUserUserAction extends ReduxAction<AppState> {
  final String id;

  ReadDocUserUserAction({required this.id});
  @override
  Future<AppState> reduce() async {
    dispatch(ChangeStatusFirestoreUserUserAction(
        statusFirestoreUser: StatusFirestoreUser.checkingInFirestore));
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var docRef = firebaseFirestore.collection(UserModel.collection).doc(id);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();
    UserModel userModel =
        UserModel.fromMap(documentSnapshot.id, documentSnapshot.data()!);

    return state.copyWith(
      userState: state.userState.copyWith(
        userCurrent: userModel,
      ),
    );
  }
}

class UpdateDocWithGoogleAccountUserAction extends ReduxAction<AppState> {
  final String id;
  UpdateDocWithGoogleAccountUserAction({required this.id});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    DocumentReference docRef =
        firebaseFirestore.collection(UserModel.collection).doc(id);
    Map<String, dynamic> googleUser = {};
    googleUser['displayName'] = state.loginState.userFirebaseAuth!.displayName;
    googleUser['photoURL'] = state.loginState.userFirebaseAuth!.photoURL;
    googleUser['phoneNumber'] = state.loginState.userFirebaseAuth!.phoneNumber;
    googleUser['email'] = state.loginState.userFirebaseAuth!.email;
    await docRef.update(googleUser);
    return null;
  }
}

class CreateDocWithGoogleAccountUserAction extends ReduxAction<AppState> {
  CreateDocWithGoogleAccountUserAction();

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    CollectionReference docRef =
        firebaseFirestore.collection(UserModel.collection);
    Map<String, dynamic> googleUser = {};
    googleUser['uid'] = state.loginState.userFirebaseAuth!.uid;
    googleUser['displayName'] = state.loginState.userFirebaseAuth!.displayName;
    googleUser['photoURL'] = state.loginState.userFirebaseAuth!.photoURL;
    googleUser['phoneNumber'] = state.loginState.userFirebaseAuth!.phoneNumber;
    googleUser['email'] = state.loginState.userFirebaseAuth!.email;
    googleUser['isActive'] = false;
    googleUser['appList'] = [];
    await docRef.add(googleUser);
    return null;
  }
}
