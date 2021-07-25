import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:professor/app_state.dart';
import 'package:professor/module/controller/module_action.dart';
import 'package:professor/situation/controller/situation_model.dart';

class StreamDocsSituationAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    print('--> StreamDocsSituationAction');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> collRef;
    collRef = firebaseFirestore
        .collection(SituationModel.collection)
        .where('moduleId', isEqualTo: state.moduleState.moduleModelCurrent!.id)
        .where('isDeleted', isEqualTo: false);

    Stream<QuerySnapshot<Map<String, dynamic>>> streamQuerySnapshot =
        collRef.snapshots();

    Stream<List<SituationModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) =>
                SituationModel.fromMap(docSnapshot.id, docSnapshot.data()))
            .toList());
    streamList.listen((List<SituationModel> situationList) {
      dispatch(SetSituationListSituationAction(situationList: situationList));
    });
    // BillState.billStream = streamList.listen((List<BillModel> billModelList) {
    //   dispatch(SetBillListBillAction(billModelList: billModelList));
    // });

    return null;
  }
}

class SetSituationListSituationAction extends ReduxAction<AppState> {
  final List<SituationModel> situationList;

  SetSituationListSituationAction({required this.situationList});
  @override
  AppState reduce() {
    return state.copyWith(
      situationState: state.situationState.copyWith(
        situationList: situationList,
      ),
    );
  }
}

class SetSituationCurrentSituationAction extends ReduxAction<AppState> {
  final String id;
  SetSituationCurrentSituationAction({
    required this.id,
  });
  @override
  AppState reduce() {
    print('--> SetSituationCurrentSituationAction $id');
    SituationModel situationModel = SituationModel(
      '',
      moduleId: '',
      title: '',
      description: '',
      proposalUrl: '',
      solutionUrl: '',
      type: 'report',
      options: [],
      choice: '',
      isDeleted: false,
    );
    if (id.isNotEmpty) {
      situationModel = state.situationState.situationList!
          .firstWhere((element) => element.id == id);
    }
    return state.copyWith(
      situationState: state.situationState.copyWith(
        situationCurrent: situationModel,
      ),
    );
  }
}

class CreateDocSituationAction extends ReduxAction<AppState> {
  final SituationModel situationModel;

  CreateDocSituationAction({required this.situationModel});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference docRef =
        firebaseFirestore.collection(SituationModel.collection);
    await docRef.add(situationModel.toMap()).then((newSituationRef) {
      dispatch(UpdateSituationOrderModuleAction(
          id: newSituationRef.id, isUnionOrRemove: true));
    });
    return null;
  }
}

class UpdateDocSituationAction extends ReduxAction<AppState> {
  final SituationModel situationModel;

  UpdateDocSituationAction({required this.situationModel});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
        .collection(SituationModel.collection)
        .doc(situationModel.id);
    await docRef.update(situationModel.toMap()).then((value) {
      if (situationModel.isDeleted) {
        print('--> remove ${docRef.id} em module.resourceOrder');
        dispatch(UpdateSituationOrderModuleAction(
            id: docRef.id, isUnionOrRemove: false));
      }
    });
    return null;
  }
}
