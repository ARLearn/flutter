import 'dart:collection';
import 'package:redux/redux.dart';
import 'package:youplay/models/game.dart';

import 'package:youplay/store/actions/all_games.actions.dart';
import 'package:youplay/store/state/all_games_state.dart';

AllGamesState _reduceParticipateGamesResponse(
    AllGamesState gamesState, LoadParticipateGamesListResponseAction action) {
  if (!action.isError()) {
    return gamesState.copyWith(
      pgs: action.getResultIdentifiers(), //todo test with empty list
    );
    gamesState;
  }
  return gamesState;
}

AllGamesState _reduceGameResponse(
    AllGamesState gamesState, LoadParticipateGameResponseAction action) {
  if (action.game == null) {
    gamesState.participateGames.remove(action.gameId);
    return gamesState;
  }
  gamesState.idToGame[action.game.gameId] = action.game;
  return gamesState.copyWith(i2g: HashMap<int, Game>.from(gamesState.idToGame));
}


AllGamesState _setQuery(
    AllGamesState gamesState, SetGameQuery action) {
  if (action.query == null || action.query!.trim() ==''){
    return gamesState.copyWith(q:  '-');
  }
  return gamesState.copyWith(q: action.query);
}

final Reducer<AllGamesState> allGamesReducer = combineReducers<AllGamesState>([
  new TypedReducer<AllGamesState, LoadParticipateGamesListResponseAction>(
      _reduceParticipateGamesResponse),
  new TypedReducer<AllGamesState, LoadParticipateGameResponseAction>(
      _reduceGameResponse),
  new TypedReducer<AllGamesState, SetGameQuery>(
      _setQuery),
]);


