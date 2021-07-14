import 'package:professor/widget/input_file.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/upload/upload_action.dart';

class InputFileConnector extends StatelessWidget {
  final String label;
  const InputFileConnector({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InputFileViewModel>(
      vm: () => InputFileFactory(this),
      builder: (context, vm) => InputFile(
        label: label,
        selectLocalFile: vm.selectLocalFile,
        selectedLocalFileName: vm.selectedLocalFileName,
        uploadingFile: vm.uploadingFile,
        percentageOfUpload: vm.percentageOfUpload,
        urlForDownload: vm.urlForDownload,
      ),
    );
  }
}

class InputFileFactory extends VmFactory<AppState, InputFileConnector> {
  InputFileFactory(widget) : super(widget);
  @override
  InputFileViewModel fromStore() => InputFileViewModel(
        selectLocalFile: () {
          dispatch(SelectFileUploadAction());
        },
        selectedLocalFileName: state.uploadState.fileName ?? '',
        uploadingFile: () async {
          await dispatch(UploadingFileUploadAction(
              pathInFirestore: state.userState.userCurrent!.id));
        },
        percentageOfUpload: state.uploadState.uploadPercentage ?? 0.0,
        urlForDownload: state.uploadState.urlForDownload ?? '',
      );
}

class InputFileViewModel extends Vm {
  final VoidCallback selectLocalFile;
  final String selectedLocalFileName;
  final VoidCallback uploadingFile;
  final double percentageOfUpload;
  final String urlForDownload;
  InputFileViewModel({
    required this.selectLocalFile,
    required this.selectedLocalFileName,
    required this.uploadingFile,
    required this.percentageOfUpload,
    required this.urlForDownload,
  }) : super(equals: [
          selectedLocalFileName,
          percentageOfUpload,
          urlForDownload,
        ]);
}
