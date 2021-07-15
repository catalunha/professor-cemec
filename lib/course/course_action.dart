import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:professor/app_state.dart';
import 'package:professor/coordinator/coordinator_action.dart';
import 'package:professor/course/course_model.dart';

class SetCourseCurrentCourseAction extends ReduxAction<AppState> {
  final String id;
  SetCourseCurrentCourseAction({
    required this.id,
  });
  @override
  AppState reduce() {
    print('--> SetCourseCurrentCourseAction $id');
    CourseModel courseModel = CourseModel(
      '',
      coordinatorUserId: '',
      title: '',
      description: '',
      syllabus: '',
      isArchivedByAdm: false,
      isArchivedByCoord: false,
      isDeleted: false,
      isActive: true,
    );
    if (id.isNotEmpty) {
      courseModel = state.courseState.courseModelList!
          .firstWhere((element) => element.id == id);
    }
    return state.copyWith(
      courseState: state.courseState.copyWith(
        courseModelCurrent: courseModel,
      ),
    );
  }

  void after() {
    dispatch(SetCoordinatorCurrentCoordinatorAction(
        id: store.state.courseState.courseModelCurrent!.coordinatorUserId));
  }
}

class CreateDocCourseAction extends ReduxAction<AppState> {
  final CourseModel courseModel;

  CreateDocCourseAction({required this.courseModel});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef =
        firebaseFirestore.collection(CourseModel.collection).doc();
    await docRef.set(courseModel.toMap());
    return null;
  }
}

class UpdateDocCourseAction extends ReduxAction<AppState> {
  final CourseModel courseModel;

  UpdateDocCourseAction({required this.courseModel});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
        .collection(CourseModel.collection)
        .doc(courseModel.id);
    await docRef.update(courseModel.toMap());
    return null;
  }
}

class ReadDocsCourseAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection(CourseModel.collection)
        .where('coordinatorUserId', isEqualTo: state.userState.userCurrent!.id)
        .where('isDeleted', isEqualTo: false)
        .get();
    List<CourseModel> courseModelList = querySnapshot.docs
        .map(
          (queryDocumentSnapshot) => CourseModel.fromMap(
            queryDocumentSnapshot.id,
            queryDocumentSnapshot.data(),
          ),
        )
        .toList();
    dispatch(SetCourseModelListCourseAction(courseModelList: courseModelList));
    return null;
  }
}

class StreamDocsCourseAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    print('--> StreamDocsCourseAction');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> collRef;
    collRef = firebaseFirestore
        .collection(CourseModel.collection)
        .where('coordinatorUserId', isEqualTo: state.userState.userCurrent!.id)
        .where('isDeleted', isEqualTo: false);

    Stream<QuerySnapshot<Map<String, dynamic>>> streamQuerySnapshot =
        collRef.snapshots();

    Stream<List<CourseModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) =>
                CourseModel.fromMap(docSnapshot.id, docSnapshot.data()))
            .toList());
    streamList.listen((List<CourseModel> courseModelList) {
      print('--> courseModel foi alterado...');
      dispatch(
          SetCourseModelListCourseAction(courseModelList: courseModelList));
    });
    // BillState.billStream = streamList.listen((List<BillModel> billModelList) {
    //   dispatch(SetBillListBillAction(billModelList: billModelList));
    // });

    return null;
  }
}

class SetCourseModelListCourseAction extends ReduxAction<AppState> {
  final List<CourseModel> courseModelList;

  SetCourseModelListCourseAction({required this.courseModelList});
  @override
  AppState reduce() {
    return state.copyWith(
      courseState: state.courseState.copyWith(
        courseModelList: courseModelList,
      ),
    );
  }

  void after() {
    print('SetCourseModelListCourseAction.after');
    if (state.courseState.courseModelCurrent != null) {
      dispatch(SetCourseCurrentCourseAction(
          id: state.courseState.courseModelCurrent!.id));
    }
  }
}

class UpdateModuleOrderCourseAction extends ReduxAction<AppState> {
  final String id;
  final bool isUnionOrRemove;
  UpdateModuleOrderCourseAction({
    required this.id,
    required this.isUnionOrRemove,
  });
  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
        .collection(CourseModel.collection)
        .doc(state.courseState.courseModelCurrent!.id);
    if (isUnionOrRemove) {
      await docRef.update({
        'moduleOrder': FieldValue.arrayUnion([id])
      });
    } else {
      await docRef.update({
        'moduleOrder': FieldValue.arrayRemove([id])
      });
    }
    return null;
  }
}
