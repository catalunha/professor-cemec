import 'dart:convert';

import 'package:professor/firestore/firestore_model.dart';

class UserModel extends FirestoreModel {
  static final String collection = 'users';
  String? info;

  UserModel(
    String id, {
    this.info,
  }) : super(id);

  UserModel copyWith({
    String? info,
  }) {
    return UserModel(
      this.id,
      info: info ?? this.info,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'info': info,
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id,
      info: map['info'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String id, String source) =>
      UserModel.fromMap(id, json.decode(source));

  @override
  String toString() => 'UserModel(info: $info)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.info == info;
  }

  @override
  int get hashCode => info.hashCode;
}
