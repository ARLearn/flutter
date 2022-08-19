
import 'package:redux/redux.dart';
import 'package:youplay/models/models.dart';
import 'package:youplay/store/actions/current_game.actions.dart';
import 'package:youplay/store/actions/current_run.actions.dart';
import 'package:youplay/store/actions/game_messages.actions.dart';
import 'package:youplay/store/actions/ui_actions.dart';
import 'package:youplay/store/reducers/ui.reducer.dart';
import 'package:youplay/store/state/all_games_state.dart';
import 'package:youplay/store/state/current_game_state.dart';
import 'package:youplay/store/state/run_state.dart';

import 'game_messages.reducer.dart';

final Reducer<GamesState> currentGameReducer = combineReducers<GamesState>([
  // new TypedReducer<GamesState, SyncGameContentResult>(_syncGameContentResult),
  new TypedReducer<GamesState, LoadGameSuccessAction>(_gameSuccesstoGameState),
  new TypedReducer<GamesState, LoadGameMessagesListResponseAction>(addMessagesToGameState),
  new TypedReducer<GamesState, ApiResultRunsParticipateAction>(_addParticipateRun),
  new TypedReducer<GamesState, ResetRunsAndGoToLandingPage>(_resetAmountOfRuns),
]);


GamesState _gameSuccesstoGameState( GamesState state, LoadGameSuccessAction action) {
  if (action.game.title == null) action.game.title = "no title";
  return state.copyWith(game:action.game);
}





AppState swapGameState(AppState state, SetCurrentGameAction action) {
  // if (state.currentGameState.game != null) { //backup old game state
  //   state.gameIdToGameState[state.currentGameState.game!.gameId] = state.currentGameState;
  // }
  return new AppState(
      // themIdToTheme: state.themIdToTheme,
      // gameIdToGameState: state.gameIdToGameState,
      currentGameState: _initGameState(state.allGamesState, action.currentGame),
//      runIdToRunState: state.runIdToRunState,
      gameIdToRun: state.gameIdToRun,
      gameLibrary: state.gameLibrary,
      // participateGames: state.participateGames,
      allGamesState: state.allGamesState,
      authentication: state.authentication,
      gameThemeState: state.gameThemeState,
      uiState: uiReducer(state.uiState, action),
      currentRunState: RunState.init()
  );
}

_initGameState(AllGamesState allGamesState, int gameId) {
  if (allGamesState.idToGame[gameId] != null) {
    return new GamesState();
  }
  return GamesState.makeWithGame(allGamesState.idToGame[gameId]!);

}

GamesState  _addParticipateRun(GamesState state, ApiResultRunsParticipateAction action) {
  return state.copyWith(runAmount: action.runs.where((element) => !element.deleted).length);
}

GamesState  _resetAmountOfRuns(GamesState state, ResetRunsAndGoToLandingPage action) {
  return state.copyWith(runAmount: -1);
}
