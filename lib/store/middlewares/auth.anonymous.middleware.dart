import 'package:youplay/actions/actions.dart';
import 'package:youplay/api/account.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:youplay/store/actions/auth.actions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final authLoginAnonymousCredentialsEpic = combineEpics<AppState>([
  new TypedEpic<AppState, AnonymousLoginAction>(customCredentialsLogin),
  new TypedEpic<AppState, EraseAnonAccount>(_eraseAnonAccount)
]);

Stream<dynamic> customCredentialsLogin(
  Stream<AnonymousLoginAction> actions,
  EpicStore<AppState> store,
) {
  return actions.asyncMap((action) => _auth
          .signInAnonymously()
          .then((authResult) => authResult.user.getIdToken().then((token) {
                if (action.onSucces != null) {
                  action.onSucces();
                }
                return new CustomLoginSucceededAction(
                    "anonymous", " ${authResult.user.uid}", authResult.user.uid, true);
              }))
          .catchError((error) {
        action.onError();
      }));
}

Stream<dynamic> _eraseAnonAccount(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions.where((action) => action is EraseAnonAccount).asyncMap((action) {
    return AccountApi.eraseAnonAcount().then((results) {
      return SignOutAction();
    });
  });
}
