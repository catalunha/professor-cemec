import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:professor/app_state.dart';
import 'package:professor/user/user_model.dart';
import 'package:collection/collection.dart';

class ReadDocsTeacherAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection(UserModel.collection)
        .where('appList', arrayContains: 'teacher')
        .get();
    List<UserModel> teacherList = querySnapshot.docs
        .map(
          (queryDocumentSnapshot) => UserModel.fromMap(
            queryDocumentSnapshot.id,
            queryDocumentSnapshot.data(),
          ),
        )
        .toList();
    dispatch(SetTeacherListTeacherAction(teacherList: teacherList));
    return null;
  }
}

class SetTeacherListTeacherAction extends ReduxAction<AppState> {
  final List<UserModel> teacherList;

  SetTeacherListTeacherAction({required this.teacherList});
  @override
  AppState reduce() {
    return state.copyWith(
      teacherState: state.teacherState.copyWith(
        teacherList: teacherList,
      ),
    );
  }
}

class SetTeacherCurrentTeacherAction extends ReduxAction<AppState> {
  final String? id;
  SetTeacherCurrentTeacherAction({
    required this.id,
  });
  @override
  AppState? reduce() {
    print('--> SetTeacherCurrentTeacherAction $id');
    UserModel? userModel;
    if (id != null && id!.isNotEmpty) {
      userModel = state.teacherState.teacherList!
          .firstWhereOrNull((element) => element.id == id);
      if (userModel != null) {
        return state.copyWith(
          teacherState: state.teacherState.copyWith(
            teacherCurrent: userModel,
          ),
        );
      }
    }
    return state.copyWith(
      teacherState: state.teacherState.copyWith(
        teacherCurrentNull: true,
      ),
    );
  }
}
