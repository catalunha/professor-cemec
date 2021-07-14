import 'dart:convert';

import 'package:professor/firestore/firestore_model.dart';

class ResourceModel extends FirestoreModel {
  static final String collection = 'resources';
  final String moduleId;
  final String title;
  final String description;
  final String? url;
  ResourceModel(
    String id, {
    required this.moduleId,
    required this.title,
    required this.description,
    this.url,
  }) : super(id);

  ResourceModel copyWith({
    String? moduleId,
    String? title,
    String? description,
    String? url,
  }) {
    return ResourceModel(
      this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'title': title,
      'description': description,
      'url': url,
    };
  }

  factory ResourceModel.fromMap(String id, Map<String, dynamic> map) {
    return ResourceModel(
      id,
      moduleId: map['moduleId'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResourceModel.fromJson(String id, String source) =>
      ResourceModel.fromMap(id, json.decode(source));

  @override
  String toString() {
    return 'ResourceModel(moduleId: $moduleId, title: $title, description: $description, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResourceModel &&
        other.moduleId == moduleId &&
        other.title == title &&
        other.description == description &&
        other.url == url;
  }

  @override
  int get hashCode {
    return moduleId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        url.hashCode;
  }
}
