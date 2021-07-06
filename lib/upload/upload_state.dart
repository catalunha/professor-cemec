import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadState {
  final File? selectedLocalFile;
  final UploadTask? uploadTask;
  final double? uploadPercentage;
  final String? urlForDownload;
  UploadState({
    required this.selectedLocalFile,
    required this.uploadTask,
    required this.uploadPercentage,
    required this.urlForDownload,
  });
  factory UploadState.initialState() => UploadState(
        selectedLocalFile: null,
        uploadTask: null,
        uploadPercentage: 0.0,
        urlForDownload: null,
      );
  UploadState copyWith({
    File? selectedLocalFile,
    UploadTask? uploadTask,
    double? uploadPercentage,
    String? urlForDownload,
  }) {
    return UploadState(
      selectedLocalFile: selectedLocalFile ?? this.selectedLocalFile,
      uploadTask: uploadTask ?? this.uploadTask,
      uploadPercentage: uploadPercentage ?? this.uploadPercentage,
      urlForDownload: urlForDownload ?? this.urlForDownload,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UploadState &&
        other.urlForDownload == urlForDownload &&
        other.uploadPercentage == uploadPercentage &&
        other.selectedLocalFile == selectedLocalFile &&
        other.uploadTask == uploadTask;
  }

  @override
  int get hashCode =>
      urlForDownload.hashCode ^
      selectedLocalFile.hashCode ^
      uploadTask.hashCode ^
      uploadPercentage.hashCode;
}
