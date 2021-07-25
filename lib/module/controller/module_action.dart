import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:professor/app_state.dart';
import 'package:professor/course/controller/course_action.dart';
import 'package:professor/course/controller/course_model.dart';
import 'package:professor/module/controller/module_model.dart';
import 'package:professor/situation/controller/situation_action.dart';
import 'package:professor/user/controller/user_model.dart';

class StreamDocsModuleAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    print('--> StreamDocsModuleAction');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> collRef;
    collRef = firebaseFirestore
        .collection(ModuleModel.collection)
        .where('teacherUserId', isEqualTo: state.userState.userCurrent!.id)
        .where('isDeleted', isEqualTo: false);

    Stream<QuerySnapshot<Map<String, dynamic>>> streamQuerySnapshot =
        collRef.snapshots();

    Stream<List<ModuleModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) =>
                ModuleModel.fromMap(docSnapshot.id, docSnapshot.data()))
            .toList());
    streamList.listen((List<ModuleModel> moduleModelList) {
      dispatch(
          SetModuleModelListModuleAction(moduleModelList: moduleModelList));
    });
    // BillState.billStream = streamList.listen((List<BillModel> billModelList) {
    //   dispatch(SetBillListBillAction(billModelList: billModelList));
    // });

    return null;
  }
}

class SetModuleModelListModuleAction extends ReduxAction<AppState> {
  final List<ModuleModel> moduleModelList;

  SetModuleModelListModuleAction({required this.moduleModelList});
  @override
  AppState reduce() {
    print('-->SetModuleModelListModuleAction ${moduleModelList.length}');
    return state.copyWith(
      moduleState: state.moduleState.copyWith(
        moduleModelList: moduleModelList,
      ),
    );
  }

  void after() {
    if (state.moduleState.moduleModelCurrent != null) {
      dispatch(SetModuleCurrentModuleAction(
          id: state.moduleState.moduleModelCurrent!.id));
    }
    dispatch(ReadDocCourseOfModuleListModuleAction());
  }
}

class ReadDocCourseOfModuleListModuleAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    List<CourseModel> courseModelList = [];
    for (ModuleModel moduleModel in state.moduleState.moduleModelList!) {
      DocumentReference<Map<String, dynamic>> docRef = firebaseFirestore
          .collection(CourseModel.collection)
          .doc(moduleModel.courseId);
      DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();
      CourseModel courseModel = CourseModel.fromMap(doc.id, doc.data()!);
      if (!courseModelList.contains(courseModel)) {
        dispatch(ReadDocCoordinatorOfModuleListModuleAction(
            coordinatorUserId: courseModel.coordinatorUserId));
        courseModelList.add(courseModel);
      }
    }
    print(
        '--> ReadDocCourseOfModuleListModuleAction ${courseModelList.length}');
    return state.copyWith(
      courseState: state.courseState.copyWith(
        courseModelList: courseModelList,
      ),
    );
  }
}

class ReadDocCoordinatorOfModuleListModuleAction extends ReduxAction<AppState> {
  final String coordinatorUserId;
  ReadDocCoordinatorOfModuleListModuleAction({
    required this.coordinatorUserId,
  });
  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    List<UserModel> coordinatorList = state.coordinatorState.coordinatorList!;
    DocumentReference<Map<String, dynamic>> docRef = firebaseFirestore
        .collection(UserModel.collection)
        .doc(coordinatorUserId);
    DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();
    UserModel userModel = UserModel.fromMap(doc.id, doc.data()!);
    if (!coordinatorList.contains(userModel)) {
      coordinatorList.add(userModel);
    }

    print('--> ReadDocCoordinatorOfModuleListModuleAction $coordinatorUserId');
    return state.copyWith(
      coordinatorState: state.coordinatorState.copyWith(
        coordinatorList: coordinatorList,
      ),
    );
  }
}

class SetModuleCurrentModuleAction extends ReduxAction<AppState> {
  final String id;
  SetModuleCurrentModuleAction({
    required this.id,
  });
  @override
  AppState reduce() {
    print('--> SetModuleCurrentModuleAction $id');
    ModuleModel moduleModel = ModuleModel(
      '',
      courseId: '',
      title: '',
      description: '',
      syllabus: '',
      isArchivedByProf: false,
      isDeleted: false,
    );
    if (id.isNotEmpty) {
      moduleModel = state.moduleState.moduleModelList!
          .firstWhere((element) => element.id == id);
    }
    return state.copyWith(
      moduleState: state.moduleState.copyWith(
        moduleModelCurrent: moduleModel,
      ),
    );
  }

  void after() {
    dispatch(SetCourseCurrentCourseAction(
        id: state.moduleState.moduleModelCurrent!.courseId));
  }
}

class UpdateDocModuleAction extends ReduxAction<AppState> {
  final ModuleModel moduleModel;

  UpdateDocModuleAction({required this.moduleModel});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
        .collection(ModuleModel.collection)
        .doc(moduleModel.id);
    await docRef.update(moduleModel.toMap());
    return null;
  }
}

class UpdateResourceOrderModuleAction extends ReduxAction<AppState> {
  final String id;
  final bool isUnionOrRemove;
  UpdateResourceOrderModuleAction({
    required this.id,
    required this.isUnionOrRemove,
  });
  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
        .collection(ModuleModel.collection)
        .doc(state.moduleState.moduleModelCurrent!.id);

    if (isUnionOrRemove) {
      await docRef.update({
        'resourceOrder': FieldValue.arrayUnion([id])
      });
    } else {
      await docRef.update({
        'resourceOrder': FieldValue.arrayRemove([id])
      });
    }
    return null;
  }
}

class UpdateSituationOrderModuleAction extends ReduxAction<AppState> {
  final String id;
  final bool isUnionOrRemove;
  UpdateSituationOrderModuleAction({
    required this.id,
    required this.isUnionOrRemove,
  });
  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
        .collection(ModuleModel.collection)
        .doc(state.moduleState.moduleModelCurrent!.id);

    if (isUnionOrRemove) {
      await docRef.update({
        'situationOrder': FieldValue.arrayUnion([id])
      });
    } else {
      await docRef.update({
        'situationOrder': FieldValue.arrayRemove([id])
      });
    }
    return null;
  }
}
