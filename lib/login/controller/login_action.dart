import 'package:async_redux/async_redux.dart';
import 'package:professor/app_state.dart';
import 'package:professor/login/controller/login_state.dart';
import 'package:professor/user/user_action.dart';
import 'package:professor/user/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChangeStatusFirebaseAuthLoginAction extends ReduxAction<AppState> {
  final StatusFirebaseAuth statusFirebaseAuth;

  ChangeStatusFirebaseAuthLoginAction({required this.statusFirebaseAuth});
  @override
  AppState reduce() {
    return state.copyWith(
        loginState: state.loginState.copyWith(
      statusFirebaseAuth: statusFirebaseAuth,
    ));
  }
}

class ChangeUserLoginAction extends ReduxAction<AppState> {
  final User userFirebaseAuth;

  ChangeUserLoginAction({required this.userFirebaseAuth});
  @override
  AppState reduce() {
    return state.copyWith(
        loginState: state.loginState.copyWith(
      userFirebaseAuth: userFirebaseAuth,
    ));
  }
}

class CheckLoginAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    dispatch(ChangeStatusFirebaseAuthLoginAction(
        statusFirebaseAuth: StatusFirebaseAuth.authenticating));
    // await Future.delayed(Duration(seconds: 5));
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('---> User is currently signed out!');
        dispatch(ChangeStatusFirebaseAuthLoginAction(
            statusFirebaseAuth: StatusFirebaseAuth.unAuthenticated));
      } else {
        print('--->  User is signed in! ${user.uid}');
        dispatch(ChangeUserLoginAction(userFirebaseAuth: user));
        dispatch(ChangeStatusFirebaseAuthLoginAction(
            statusFirebaseAuth: StatusFirebaseAuth.authenticated));
        // await Future.delayed(Duration(seconds: 5));

        await dispatch(GetDocGoogleAccountUserAction(uid: user.uid));
        print('---> SignInLoginAction: verificado se tem users correspondente');
        print('---> SignInLoginAction: ${state.userState.userCurrent}');
        print('---> SignInLoginAction: state.userState.userCurrent != null');
      }
    });

    return null;
  }
}

class SignInLoginAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      var google = GoogleSignInOrSignOut();
      bool done = await google.googleLogin();
      print('---> SignInLoginAction: googleLogin $done');
    } catch (e) {
      print('--> google.googleLogin(): nao escolheu nada');
    }

    return null;
  }
}

class SignOutLoginAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    var google = GoogleSignInOrSignOut();
    var done = await google.googleLogout();
    print('---> SignOutLoginAction: googleLogout $done');
    return state.copyWith(
      userState: UserState.initialState(),
    );
  }

  void after() => dispatch(ChangeStatusFirebaseAuthLoginAction(
      statusFirebaseAuth: StatusFirebaseAuth.unAuthenticated));
}

class GoogleSignInOrSignOut {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future<bool> googleLogin() async {
    try {
      print('--> GoogleSignInOrSignOut.googleLogin(): 1');
      final googleUser = await googleSignIn.signIn();
      print('--> GoogleSignInOrSignOut.googleLogin(): 2 $googleUser');
      if (googleUser == null) return false;
      _user = googleUser;
      print('--> GoogleSignInOrSignOut.googleLogin(): 3');
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('+++ Erro googleLogin +++');
      print(e.toString());
      print('--- Erro googleLogin ---');
      return false;
    }
  }

  Future<bool> googleLogout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return true;
    } else {
      return false;
    }
  }
}
