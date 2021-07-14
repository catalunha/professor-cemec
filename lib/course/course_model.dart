import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:professor/firestore/firestore_model.dart';

class CourseModel extends FirestoreModel {
  static final String collection = 'courses';

  final String coordinatorUserId; // coordinator User.id
  final String title;
  final String description;
  final String syllabus;
  final bool isArchivedByAdm; //for adm use
  final bool isArchivedByCoord; //for coord use
  final bool isDeleted; //for coord use
  final bool isActive; //for adm use

  final String? iconUrl;
  final List<String>? moduleOrder;
  final List<String>? collegiate; // lista de UserId

  CourseModel(
    String id, {
    required this.coordinatorUserId,
    required this.title,
    required this.description,
    required this.syllabus,
    this.iconUrl,
    required this.isArchivedByAdm,
    required this.isArchivedByCoord,
    required this.isDeleted,
    required this.isActive,
    this.moduleOrder,
    this.collegiate,
  }) : super(id);

  CourseModel copyWith({
    String? coordinatorUserId,
    String? title,
    String? description,
    String? syllabus,
    String? iconUrl,
    bool? isArchivedByAdm,
    bool? isDeleted,
    bool? isActive,
    bool? isArchivedByCoord,
    List<String>? moduleOrder,
    List<String>? collegiate,
  }) {
    return CourseModel(
      this.id,
      coordinatorUserId: coordinatorUserId ?? this.coordinatorUserId,
      title: title ?? this.title,
      description: description ?? this.description,
      syllabus: syllabus ?? this.syllabus,
      iconUrl: iconUrl ?? this.iconUrl,
      isArchivedByAdm: isArchivedByAdm ?? this.isArchivedByAdm,
      isArchivedByCoord: isArchivedByCoord ?? this.isArchivedByCoord,
      isDeleted: isDeleted ?? this.isDeleted,
      isActive: isActive ?? this.isActive,
      moduleOrder: moduleOrder ?? this.moduleOrder,
      collegiate: collegiate ?? this.collegiate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coordinatorUserId': coordinatorUserId,
      'title': title,
      'description': description,
      'syllabus': syllabus,
      'iconUrl': iconUrl,
      'isArchivedByAdm': isArchivedByAdm,
      'isArchivedByCoord': isArchivedByCoord,
      'isDeleted': isDeleted,
      'isActive': isActive,
      'moduleOrder': moduleOrder,
      'collegiate': collegiate,
    };
  }

  factory CourseModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseModel(
      id,
      coordinatorUserId: map['coordinatorUserId'],
      title: map['title'],
      description: map['description'],
      syllabus: map['syllabus'],
      isArchivedByAdm: map['isArchivedByAdm'],
      isArchivedByCoord: map['isArchivedByCoord'],
      isDeleted: map['isDeleted'] ?? false,
      isActive: map['isActive'] ?? true,
      iconUrl: map['iconUrl'],
      collegiate:
          map['collegiate'] == null ? [] : List<String>.from(map['collegiate']),
      moduleOrder: map['moduleOrder'] == null
          ? []
          : List<String>.from(map['moduleOrder']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String id, String source) =>
      CourseModel.fromMap(id, json.decode(source));

  @override
  String toString() {
    return 'CourseModel(coordinatorUserId: $coordinatorUserId, title: $title, description: $description, syllabus: $syllabus, iconUrl: $iconUrl, isArchivedByAdm: $isArchivedByAdm, isArchivedByCoord: $isArchivedByCoord, isDeleted: $isDeleted,isActive: $isActive, moduleOrder: $moduleOrder, collegiate: $collegiate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseModel &&
        other.coordinatorUserId == coordinatorUserId &&
        other.title == title &&
        other.description == description &&
        other.syllabus == syllabus &&
        other.iconUrl == iconUrl &&
        other.isArchivedByAdm == isArchivedByAdm &&
        other.isArchivedByCoord == isArchivedByCoord &&
        other.isDeleted == isDeleted &&
        other.isActive == isActive &&
        listEquals(other.collegiate, collegiate) &&
        listEquals(other.moduleOrder, moduleOrder);
  }

  @override
  int get hashCode {
    return coordinatorUserId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        syllabus.hashCode ^
        iconUrl.hashCode ^
        isArchivedByAdm.hashCode ^
        isArchivedByCoord.hashCode ^
        isDeleted.hashCode ^
        isActive.hashCode ^
        collegiate.hashCode ^
        moduleOrder.hashCode;
  }
}
