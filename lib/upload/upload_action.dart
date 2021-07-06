import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:professor/app_state.dart';
import 'package:professor/upload/upload_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:async_redux/async_redux.dart';
import 'package:file_picker/file_picker.dart';

class RestartingStateUploadAction extends ReduxAction<AppState> {
  RestartingStateUploadAction();
  AppState reduce() {
    return state.copyWith(uploadState: UploadState.initialState());
  }
}

class SelectFileUploadAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    dispatch(RestartingStateUploadAction());
    UploadForFirebase uploadFirebase = UploadForFirebase();
    bool status = await uploadFirebase.selectFile();
    if (status) {
      return state.copyWith(
        uploadState: state.uploadState.copyWith(
          selectedLocalFile: uploadFirebase.file,
        ),
      );
    } else {
      return state.copyWith(uploadState: UploadState.initialState());
    }
  }
}

class UploadingFileUploadAction extends ReduxAction<AppState> {
  Future<AppState> reduce() async {
    UploadForFirebase uploadForFirebase = UploadForFirebase();
    File? file = state.uploadState.selectedLocalFile;
    if (file != null) {
      UploadTask? task = uploadForFirebase.uploadingFile(file, 'files2');
      return state.copyWith(
          uploadState: state.uploadState.copyWith(uploadTask: task));
    } else {
      return state.copyWith(uploadState: UploadState.initialState());
    }
  }

  void after() => dispatch(StreamUploadTask());
}

class UpdateUploadPorcentageUploadAction extends ReduxAction<AppState> {
  final double value;

  UpdateUploadPorcentageUploadAction({required this.value});
  AppState reduce() {
    return state.copyWith(
      uploadState: state.uploadState.copyWith(
        uploadPercentage: value,
      ),
    );
  }
}

class UpdateUrlForDownloadUploadAction extends ReduxAction<AppState> {
  UpdateUrlForDownloadUploadAction();
  Future<AppState?> reduce() async {
    if (state.uploadState.uploadTask != null) {
      UploadTask task = state.uploadState.uploadTask!;
      final snapshot = await task.whenComplete(() {});
      String url = await snapshot.ref.getDownloadURL();
      return state.copyWith(
        uploadState: state.uploadState.copyWith(
          urlForDownload: url,
        ),
      );
    } else {
      return null;
    }
  }
}

class StreamUploadTask extends ReduxAction<AppState> {
  Future<AppState?> reduce() async {
    print('StreamUploadTask');
    if (state.uploadState.uploadTask != null) {
      UploadTask uploadTask = state.uploadState.uploadTask!;
      Stream<TaskSnapshot> streamTaskSnapshot = uploadTask.snapshotEvents;
      streamTaskSnapshot.listen((TaskSnapshot event) {
        final progress = event.bytesTransferred / event.totalBytes;
        final percentage = (progress * 100);
        print(percentage);
        dispatch(UpdateUploadPorcentageUploadAction(value: percentage));
      });
      // dispatch(UpdateUrlForDownloadUploadAction());

      return null;
    } else {
      return null;
    }
  }

  void after() => dispatch(UpdateUrlForDownloadUploadAction());
}

class UploadForFirebase {
  File? file;
  Future<bool> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return false;
    final path = result.files.single.path!;

    file = File(path);
    return true;
  }

  UploadTask? uploadingFile(File file, String pathInFirestore) {
    final fileName = basename(file.path);
    final destination = '$pathInFirestore/$fileName';
    var task = _uploadFile(destination, file);
    if (task == null) return null;
    return task;
  }
  // Future<bool> uploadFile(String pathInFirestore) async {
  //   if (file == null) return false;
  //   final fileName = basename(file!.path);
  //   final destination = '$pathInFirestore/$fileName';
  //   task = _uploadFile(destination, file!);
  //   if (task == null) return false;
  //   final snapshot = await task!.whenComplete(() {});
  //   urlDownload = await snapshot.ref.getDownloadURL();
  //   return true;
  //   print('Download-link:$urlDownload');
  // }

  static UploadTask? _uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? _uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
