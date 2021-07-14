import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/teacher/teacher_action.dart';
import 'package:professor/teacher/teacher_list.dart';
import 'package:professor/user/user_model.dart';
import 'package:flutter/material.dart';

class TeacherListConnector extends StatelessWidget {
  final String label;

  const TeacherListConnector({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TeacherListViewModel>(
      vm: () => TeacherListFactory(this),
      builder: (context, vm) => TeacherList(
        label: label,
        teacherList: vm.teacherList,
        onSelect: vm.onSelect,
      ),
    );
  }
}

class TeacherListFactory extends VmFactory<AppState, TeacherListConnector> {
  TeacherListFactory(widget) : super(widget);
  @override
  TeacherListViewModel fromStore() => TeacherListViewModel(
        teacherList: teacherList(),
        onSelect: (String id) {
          dispatch(SetTeacherCurrentTeacherAction(id: id));
        },
      );

  List<UserModel> teacherList() {
    print('collegiate ${state.courseState.courseModelCurrent?.collegiate}');
    List<UserModel> teacherThisCourse = [];
    for (UserModel teacher in state.teacherState.teacherList!) {
      if (state.courseState.courseModelCurrent!.collegiate!
          .contains(teacher.id)) {
        teacherThisCourse.add(teacher);
      }
    }
    return teacherThisCourse;
    // return state.teacherState.teacherList ?? [];
  }
}

class TeacherListViewModel extends Vm {
  final List<UserModel> teacherList;
  final Function(String) onSelect;
  TeacherListViewModel({
    required this.teacherList,
    required this.onSelect,
  }) : super(equals: [
          teacherList,
        ]);
}
