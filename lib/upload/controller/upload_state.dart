import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class UploadState {
  final String? fileName;
  final Uint8List? fileBytes;
  final UploadTask? uploadTask;
  final double? uploadPercentage;
  final String? urlForDownload;
  UploadState({
    required this.fileName,
    required this.fileBytes,
    required this.uploadTask,
    required this.uploadPercentage,
    required this.urlForDownload,
  });
  factory UploadState.initialState() => UploadState(
        uploadTask: null,
        uploadPercentage: 0.0,
        urlForDownload: null,
        fileBytes: null,
        fileName: null,
      );
  UploadState copyWith({
    String? fileName,
    Uint8List? fileBytes,
    UploadTask? uploadTask,
    double? uploadPercentage,
    String? urlForDownload,
  }) {
    return UploadState(
      fileName: fileName ?? this.fileName,
      fileBytes: fileBytes ?? this.fileBytes,
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
        other.fileName == fileName &&
        other.fileBytes == fileBytes &&
        other.uploadTask == uploadTask;
  }

  @override
  int get hashCode =>
      fileName.hashCode ^
      fileBytes.hashCode ^
      urlForDownload.hashCode ^
      uploadTask.hashCode ^
      uploadPercentage.hashCode;
}
