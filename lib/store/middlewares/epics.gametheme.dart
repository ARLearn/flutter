import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youplay/store/actions/actions.games.dart';
import 'package:youplay/store/state/app_state.dart';

import '../../api/gametheme.api.dart';
import '../../models/game_theme.dart';
import '../actions/game_theme.actions.dart';
import 'epics.collection.dart';

final gameThemeEpics = combineEpics<AppState>([
  TypedEpic<AppState, dynamic>(_gameThemeEpics),
  TypedEpic<AppState, dynamic>(_loadGameSuccessEpic),
]);

Stream<dynamic> _gameThemeEpics(Stream<dynamic> actions, EpicStore<AppState> store) {
  return resetOnError(
      actions,
      actions
      .whereType<LoadGameTheme>()
      .distinctUnique()
      .flatMap((LoadGameTheme action) => GameThemeAPI.instance.getGameTheme('${action.themeIdentifier}'))
      .map((GameTheme gameTheme) => LoadGameThemeSuccess(gameTheme: gameTheme)));
}

Stream<dynamic> _loadGameSuccessEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<LoadGameSuccess>()
      .map((action) => new LoadGameTheme(themeIdentifier: action.game.theme));
}
