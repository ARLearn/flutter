import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:youplay/models/game.dart';
import 'package:youplay/store/actions/actions.collection.dart';
import 'package:youplay/store/actions/auth.actions.dart';
import 'package:youplay/store/actions/current_run.actions.dart';
import 'package:youplay/store/actions/ui_actions.dart';
import 'package:youplay/store/selectors/auth.selectors.dart';
import 'package:youplay/store/selectors/selector.runs.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/store/state/ui_state.dart';
import 'package:youplay/ui/pages/game_runs.page.container.dart';

import '../../store/actions/actions.games.dart';
import 'game_landing.page.createanon.dart';
import 'game_landing.page.directstart.dart';
import 'game_landing.page.loading.dart';

class GameLandingPublicPageContainer extends StatelessWidget {
  Game game;

  GameLandingPublicPageContainer({required this.game, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store, game),
      builder: (context, vm) {
        if (!vm.authenticated) {
          return GameLandingCreateAnonSessionWaitingPage(init: vm.createAnonSession);
        }
        if (vm.amountOfRuns > 0) {
          return GameRunsPageContainer(game: game);
        }
        if (vm.loadingRuns) {
          return GameLandingLoadingPage(text: "Even wachten, we laden de groep(en) voor dit spel...");
        }
        if (vm.amountOfRuns == 0) {
          return GameLandingDirectStartPage(
            game: game,
            openDev: vm.openDev,
            close: vm.close,
            createRunAndStart: vm.createRunAndStart,
          );
        }
        return GameRunsPageContainer(
          game: game,
        );
      },
    );
  }
}

class _ViewModel {
  Game game;
  bool authenticated;
  Function createAnonSession;
  bool loadingRuns;
  int amountOfRuns;
  bool isAnon;
  Store<AppState> store;

  _ViewModel(
      {required this.game,
      required this.authenticated,
      required this.isAnon,
      required this.createAnonSession,
      required this.loadingRuns,
      required this.amountOfRuns,
      required this.store});

  static _ViewModel fromStore(Store<AppState> store, Game game) {
    return _ViewModel(
      game: game,
      authenticated: isAuthenticatedSelector(store.state),
      isAnon: isAnonSelector(store.state),
      createAnonSession: () {
        store.dispatch(AnonymousLoginAction());
      },
      loadingRuns: isLoadingCurrentGameRuns(store.state),
      amountOfRuns: amountOfRunsSelector(store.state),
      store: store,
    );
  }

  close() {
    store.dispatch(new SetPage(page: PageType.featured));
  }


  openDev() {
    if (game.organisationId != null) {
      store.dispatch(new SetPage(page: PageType.organisationLandingPage, pageId: int.parse(game.organisationId!)));
    }
  }

  createRunAndStart() {
    store.dispatch(new LoadGameRequest(gameId: '${game.gameId}'));
    store.dispatch(new RequestNewRunAction(gameId: game.gameId, name: 'demo'));
    // store.dispatch(new SetPage(page: PageType.game));
  }
}
