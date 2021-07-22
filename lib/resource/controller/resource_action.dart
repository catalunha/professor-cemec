import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:professor/app_state.dart';
import 'package:professor/module/controller/module_action.dart';
import 'package:professor/resource/controller/resource_model.dart';

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
        .where('moduleId', isEqualTo: state.moduleState.moduleModelCurrent!.id)
        .where('isDeleted', isEqualTo: false);

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

class SetResourceCurrentResourceAction extends ReduxAction<AppState> {
  final String id;
  SetResourceCurrentResourceAction({
    required this.id,
  });
  @override
  AppState reduce() {
    print('--> SetResourceCurrentResourceAction $id');
    ResourceModel resourceModel = ResourceModel(
      '',
      moduleId: '',
      title: '',
      description: '',
      url: null,
      isDeleted: false,
    );
    if (id.isNotEmpty) {
      resourceModel = state.resourceState.resourceModelList!
          .firstWhere((element) => element.id == id);
    }
    return state.copyWith(
      resourceState: state.resourceState.copyWith(
        resourceModelCurrent: resourceModel,
      ),
    );
  }
}

class CreateDocResourceAction extends ReduxAction<AppState> {
  final ResourceModel resourceModel;

  CreateDocResourceAction({required this.resourceModel});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference docRef =
        firebaseFirestore.collection(ResourceModel.collection);
    await docRef.add(resourceModel.toMap()).then((newResourceRef) {
      dispatch(UpdateResourceOrderModuleAction(
          id: newResourceRef.id, isUnionOrRemove: true));
    });
    return null;
  }
}

class UpdateDocResourceAction extends ReduxAction<AppState> {
  final ResourceModel resourceModel;

  UpdateDocResourceAction({required this.resourceModel});

  @override
  Future<AppState?> reduce() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
        .collection(ResourceModel.collection)
        .doc(resourceModel.id);
    await docRef.update(resourceModel.toMap()).then((value) {
      if (resourceModel.isDeleted) {
        print('--> remove ${docRef.id} em module.resourceOrder');
        dispatch(UpdateResourceOrderModuleAction(
            id: docRef.id, isUnionOrRemove: false));
      }
    });
    return null;
  }
}
