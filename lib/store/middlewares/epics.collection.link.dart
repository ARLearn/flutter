import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youplay/models/organisation.dart';
import 'package:youplay/store/actions/actions.organisations.dart';
import 'package:youplay/store/actions/ui_actions.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/store/state/ui_state.dart';

import '../actions/actions.collection.dart';
import '../actions/actions.games.dart';
import '../actions/actions.runs.dart';
import '../selectors/auth.selectors.dart';

final collectionLinkEpics = combineEpics<AppState>([
  TypedEpic<AppState, dynamic>(_parseOrganisationLinkAuthenticatedEpic),
  TypedEpic<AppState, dynamic>(_parseGameLinkAuthenticatedEpic),
  TypedEpic<AppState, dynamic>(_parseGameLinkUnAuthenticatedEpic),
  TypedEpic<AppState, dynamic>(_parseRunLinkAuthenticatedEpic),
  TypedEpic<AppState, dynamic>(_parseRunLinkUnAuthenticatedEpic),
]);

Stream<dynamic> _parseOrganisationLinkAuthenticatedEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<ParseLinkAction>()
      .where((action) => isAuthenticatedSelector(store.state))
      .where((action) => action.isOrganisationLink())
      .where((action) {
    print (' in parse game organisationId is authenticated ${action.organisationId} ');
    return true;
  })
      .expand((action) => [
    // LoadPublicGameRequest(gameId: action.gameId),
    // LoadGameRunsRequest(gameId: action.gameId), //ResetRunsAndGoToLandingPage (is this necessary)
    SetHomeOrganisation(organisationId: action.organisationId),
    LoadGameFromOrganisationRequest(organisationId: action.organisationId),
    Organisation.loadOne(id: action.organisationId),
    SetPage(page: PageType.organisationLandingPage, pageId: int.parse(action.organisationId)),
  ]);
}

Stream<dynamic> _parseGameLinkAuthenticatedEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<ParseLinkAction>()
      .where((action) => isAuthenticatedSelector(store.state))
      .where((action) => action.isGameLink())
  .where((action) {
    print (' in parse game link is authenticated ${action.gameId} ');
    return true;
  })
      .expand((action) => [
            LoadPublicGameRequest(gameId: action.gameId),
            LoadGameRunsRequest(gameId: action.gameId), //ResetRunsAndGoToLandingPage (is this necessary)
            SetPage(page: PageType.gamePreLandingPage, gameId: action.gameId),
          ]);
}

Stream<dynamic> _parseGameLinkUnAuthenticatedEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<ParseLinkAction>()
      .where((action) => !isAuthenticatedSelector(store.state))
      .where((action) => action.isGameLink())
      .where((action) {
    print (' in parse game link is not authenticated ${action.gameId} ');
    return true;
  })
      .expand((action) => [
            LoadPublicGameRequest(gameId: action.gameId),
            SetPage(page: PageType.gamePreLandingPage, gameId: action.gameId),
          ]);
}

Stream<dynamic> _parseRunLinkAuthenticatedEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<ParseLinkAction>()
      .where((action) => isAuthenticatedSelector(store.state))
      .where((action) => action.isRunLink())
      .expand((action) => [
            LoadGameFromRunRequest(runId: '${action.runId}'),
            LoadRunAuthRequest(runId: action.runId),
            SetPage(page: PageType.runLandingPage, pageId: action.runId, runId: action.runId),
          ]);
}

Stream<dynamic> _parseRunLinkUnAuthenticatedEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<ParseLinkAction>()
      .where((action) => !isAuthenticatedSelector(store.state))
      .where((action) => action.isRunLink())
      .expand((action) => [
            LoadGameFromRunUnAuthRequest(runId: '${action.runId}'),
            LoadRunRequest(runId: action.runId),
            SetPage(page: PageType.runLandingPage, pageId: action.runId, runId: action.runId),
          ]);
}
