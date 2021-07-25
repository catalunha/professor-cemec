import 'package:flutter/foundation.dart';
import 'package:professor/situation/controller/situation_model.dart';

class SituationState {
  final SituationModel? situationCurrent;
  final List<SituationModel>? situationList;

  SituationState({
    this.situationCurrent,
    this.situationList,
  });
  factory SituationState.initialState() => SituationState(
        situationCurrent: null,
        situationList: [],
      );
  SituationState copyWith({
    SituationModel? situationCurrent,
    List<SituationModel>? situationList,
  }) {
    return SituationState(
      situationCurrent: situationCurrent ?? this.situationCurrent,
      situationList: situationList ?? this.situationList,
    );
  }

  @override
  String toString() =>
      'SituationState(situationCurrent: $situationCurrent, situationList: $situationList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SituationState &&
        other.situationCurrent == situationCurrent &&
        listEquals(other.situationList, situationList);
  }

  @override
  int get hashCode => situationCurrent.hashCode ^ situationList.hashCode;
}
