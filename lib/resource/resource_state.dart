import 'package:professor/app_state.dart';
import 'package:professor/resource/resource_model.dart';
import 'package:flutter/foundation.dart';

class ResourceState {
  final ResourceModel? resourceModelCurrent;
  final List<ResourceModel>? resourceModelList;

  ResourceState({
    this.resourceModelCurrent,
    this.resourceModelList,
  });
  factory ResourceState.initialState() => ResourceState(
        resourceModelCurrent: null,
        resourceModelList: [],
      );
  ResourceState copyWith({
    ResourceModel? resourceModelCurrent,
    List<ResourceModel>? resourceModelList,
  }) {
    return ResourceState(
      resourceModelCurrent: resourceModelCurrent ?? this.resourceModelCurrent,
      resourceModelList: resourceModelList ?? this.resourceModelList,
    );
  }

  @override
  String toString() =>
      'ResourceState(resourceModelCurrent: $resourceModelCurrent, resourceModelList: $resourceModelList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResourceState &&
        other.resourceModelCurrent == resourceModelCurrent &&
        listEquals(other.resourceModelList, resourceModelList);
  }

  @override
  int get hashCode =>
      resourceModelCurrent.hashCode ^ resourceModelList.hashCode;
}
