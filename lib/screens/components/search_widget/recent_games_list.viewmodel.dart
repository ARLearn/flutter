import 'package:redux/redux.dart';
import 'package:youplay/actions/runs.dart';
import 'package:youplay/models/game.dart';
import 'package:youplay/state/ui_state.dart';
import 'package:youplay/store/actions/auth.actions.dart';
import 'package:youplay/store/actions/current_game.actions.dart';
import 'package:youplay/store/actions/ui_actions.dart';
import 'package:youplay/store/selectors/game_library.selectors.dart';
import 'package:youplay/store/state/app_state.dart';

class RecentGamesListViewModel {
  List<Game> searchGames;
  List<Game> recentGames;
  Function openGame;

  List<Game> get games {
    if (searchGames != null && searchGames.length != 0) return [];
    return recentGames;
}
  RecentGamesListViewModel({this.searchGames, this.recentGames, this.openGame});

  static RecentGamesListViewModel fromStore(Store<AppState> store) {
    return RecentGamesListViewModel(
        searchGames: searchedGamesSelector(store.state),
        recentGames: store.state.gameLibrary.recentGames,
        openGame: (Game g) {
          if (g.privateMode && !store.state.authentication.authenticated) {
            store.dispatch(AnonymousLoginAction());
          }
          store.dispatch(LoadGameSuccessAction(game: g));
          store.dispatch(LoadPublicGameRequestAction(g.gameId));
          store.dispatch(ResetRunsAndGoToLandingPage());
          if (store.state.authentication.authenticated) {
            store.dispatch(ApiRunsParticipateAction(g.gameId));
          }
        });
  }
}
