import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:professor/app_state.dart';
import 'package:professor/resource/resource_model.dart';

class ReadDocsResourceAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    print('--> ReadDocsResourceAction');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection(ResourceModel.collection)
        .where('moduleId', isEqualTo: state.moduleState.moduleModelCurrent!.id)
        .get();
    List<ResourceModel> resourceModelList = [];
    resourceModelList = querySnapshot.docs
        .map(
          (queryDocumentSnapshot) => ResourceModel.fromMap(
            queryDocumentSnapshot.id,
            queryDocumentSnapshot.data(),
          ),
        )
        .toList();
    dispatch(SetResourceModelListResourceAction(
        resourceModelList: resourceModelList));
    return null;
  }
}

class StreamDocsResourceAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    print('--> StreamDocsResourceAction');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> collRef;
    collRef = firebaseFirestore
        .collection(ResourceModel.collection)
        .where('moduleId', isEqualTo: state.moduleState.moduleModelCurrent!.id);

    Stream<QuerySnapshot<Map<String, dynamic>>> streamQuerySnapshot =
        collRef.snapshots();

    Stream<List<ResourceModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) =>
                ResourceModel.fromMap(docSnapshot.id, docSnapshot.data()))
            .toList());
    streamList.listen((List<ResourceModel> resourceModelList) {
      dispatch(SetResourceModelListResourceAction(
          resourceModelList: resourceModelList));
    });
    // BillState.billStream = streamList.listen((List<BillModel> billModelList) {
    //   dispatch(SetBillListBillAction(billModelList: billModelList));
    // });

    return null;
  }
}

class SetResourceModelListResourceAction extends ReduxAction<AppState> {
  final List<ResourceModel> resourceModelList;

  SetResourceModelListResourceAction({required this.resourceModelList});
  @override
  AppState reduce() {
    return state.copyWith(
      resourceState: state.resourceState.copyWith(
        resourceModelList: resourceModelList,
      ),
    );
  }
}
