import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:professor/firestore/firestore_model.dart';

class SituationModel extends FirestoreModel {
  static final String collection = 'situations';
  final String moduleId;
  final String title;
  final String description;
  final String proposalUrl;
  final String solutionUrl;
  final String type; //choice,report
  final List<String>? options; // [Sim,Não] or [A,B,C,D,E]
  final String? choice; // [Sim] or [A]
  final bool isDeleted;

  SituationModel(
    String id, {
    required this.moduleId,
    required this.title,
    required this.description,
    required this.proposalUrl,
    required this.solutionUrl,
    required this.type,
    this.options,
    this.choice,
    required this.isDeleted,
  }) : super(id);

  get url => null;

  SituationModel copyWith({
    String? moduleId,
    String? title,
    String? description,
    String? proposalUrl,
    String? solutionUrl,
    String? type,
    List<String>? options,
    String? choice,
    bool? isDeleted,
    bool choiceIsNull = false,
    bool optionsIsNull = false,
  }) {
    return SituationModel(
      id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      proposalUrl: proposalUrl ?? this.proposalUrl,
      solutionUrl: solutionUrl ?? this.solutionUrl,
      type: type ?? this.type,
      // options: options ?? this.options,
      // choice: choice ?? this.choice,
      isDeleted: isDeleted ?? this.isDeleted,
      choice: choiceIsNull ? null : choice ?? this.choice,
      options: optionsIsNull ? null : options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'title': title,
      'description': description,
      'proposalUrl': proposalUrl,
      'solutionUrl': solutionUrl,
      'type': type,
      'options': options,
      'choice': choice,
      'isDeleted': isDeleted,
    };
  }

  factory SituationModel.fromMap(String id, Map<String, dynamic> map) {
    return SituationModel(
      id,
      moduleId: map['moduleId'],
      title: map['title'],
      description: map['description'],
      proposalUrl: map['proposalUrl'],
      solutionUrl: map['solutionUrl'],
      type: map['type'],
      options: map['options'] == null ? [] : List<String>.from(map['options']),
      choice: map['choice'],
      isDeleted: map['isDeleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SituationModel.fromJson(String id, String source) =>
      SituationModel.fromMap(id, json.decode(source));

  @override
  String toString() {
    return 'Situation(moduleId: $moduleId, title: $title, description: $description, proposalUrl: $proposalUrl, solutionUrl: $solutionUrl, type: $type, options: $options, choice: $choice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SituationModel &&
        other.moduleId == moduleId &&
        other.title == title &&
        other.description == description &&
        other.proposalUrl == proposalUrl &&
        other.solutionUrl == solutionUrl &&
        other.type == type &&
        other.choice == choice &&
        other.isDeleted == isDeleted &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode {
    return moduleId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        proposalUrl.hashCode ^
        solutionUrl.hashCode ^
        type.hashCode ^
        isDeleted.hashCode ^
        options.hashCode ^
        choice.hashCode;
  }
}
