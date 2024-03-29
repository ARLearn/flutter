import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/transformers.dart';
import 'package:youplay/api/games.dart';
import 'package:youplay/store/actions/all_games.actions.dart';
import 'package:youplay/store/selectors/all_games.selectors.dart';
import 'package:youplay/store/state/app_state.dart';

final allGameEpics = combineEpics<AppState>([
  // new TypedEpic<AppState, LoadParticipateGamesListRequestAction>(_gameParticipateStream),
  new TypedEpic<AppState, LoadParticipateGamesListResponseAction>(_downloadIndividualGames),
  new TypedEpic<AppState, LoadParticipateGameResponseAction>(_downloadIndividualGames),
  new TypedEpic<AppState, LoadParticipateGameRequestAction>(_downloadGame),
  // new TypedEpic<AppState, ApiResultRunsParticipateAction>(_removeParticipateRun),
]);
//

Stream<dynamic> _gameParticipateStream(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions.where((action) => action is LoadParticipateGamesListRequestAction).asyncMap((action) =>
      GamesApi.participateGameIds()
          .then((resultAsString) => new LoadParticipateGamesListResponseAction(resultAsString: resultAsString)));
}

Stream<dynamic> _downloadIndividualGames(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .where(
          (action) => action is LoadParticipateGamesListResponseAction || action is LoadParticipateGameResponseAction)
      .where((action) => hasUnsyncedGames(store.state.allGamesState))
      .map((action) => new LoadParticipateGameRequestAction(firstUnsyncedGameId(store.state.allGamesState)));
}

Stream<dynamic> _downloadGame(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .where((action) => action is LoadParticipateGameRequestAction)
      .cast<LoadParticipateGameRequestAction>()
      .flatMap((action) => GamesApi.newGetGame(action.gameId))
      .map((game) => LoadParticipateGameResponseAction(game: game, gameId: game.gameId));
  // return GamesApi.game(action.gameId).then((results) {
  //   return LoadParticipateGameResponseAction(game: results, gameId: action.gameId);
  // }).catchError((error) {
  //   print('$error');
  //   return new ApiResultError(error: error, message: 'error in download game');
  // });
}
