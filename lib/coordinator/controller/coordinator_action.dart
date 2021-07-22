import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/coordinator/controller/coordinator_state.dart';

class SetCoordinatorCurrentCoordinatorAction extends ReduxAction<AppState> {
  final String? id;
  SetCoordinatorCurrentCoordinatorAction({
    required this.id,
  });
  @override
  AppState? reduce() {
    return state.copyWith(
      coordinatorState: state.coordinatorState.copyWith(
        coordinatorCurrent: CoordinatorState.selectCoordinator(state, id!),
      ),
    );
  }
}
