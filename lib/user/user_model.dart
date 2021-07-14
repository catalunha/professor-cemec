import 'dart:convert';

import 'package:professor/firestore/firestore_model.dart';
import 'package:flutter/foundation.dart';

class UserModel extends FirestoreModel {
  static final String collection = 'users';
  final String? displayName;
  final String email;
  final String? phoneNumber;
  final String? photoURL;
  final bool isActive;
  final List<String> appList; //teacher,coordinator,administrator,student

  UserModel(
    String id, {
    required this.email,
    required this.isActive,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    required this.appList,
  }) : super(id);

  UserModel copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    bool? isActive,
    List<String>? appList,
  }) {
    return UserModel(
      id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      isActive: isActive ?? this.isActive,
      appList: appList ?? this.appList,
    );
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id,
      displayName: map['displayName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      isActive: map['isActive'],
      appList: map['appList'] == null ? [] : List<String>.from(map['appList']),
    );
  }

  factory UserModel.fromJson(String id, String source) =>
      UserModel.fromMap(id, json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'isActive': isActive,
      'appList': appList,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserModel(displayName: $displayName, email: $email, phoneNumber: $phoneNumber, photoURL: $photoURL, isActive: $isActive, appList: $appList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        listEquals(other.appList, appList) &&
        other.isActive == isActive &&
        other.displayName == displayName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.photoURL == photoURL;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        appList.hashCode ^
        isActive.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        photoURL.hashCode;
  }
}
