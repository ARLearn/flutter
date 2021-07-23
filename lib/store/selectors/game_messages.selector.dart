import 'package:flutter/material.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/models.dart';

import 'package:youplay/store/state/current_game_state.dart';
import 'package:reselect/reselect.dart';
import 'package:youplay/store/selectors/ui_selectors.dart';
import 'package:youplay/store/selectors/current_game.selectors.dart';

final Selector<AppState, GeneralItem?> currentGeneralItem = createSelector2(
    gameStateFeature, currentItemId, (GamesState state, int? itemId) {
  if (state.game == null) {
    return null;
  }
  return state.itemIdToGeneralItem[itemId];
});


//        itemPrimaryColor: currentGeneralItem(store.state)?.primaryColor,


final Selector<AppState, Color> itemColor = createSelector2(
    gameStateFeature, currentItemId, (GamesState state, int? itemId) {
  if (state.game == null) {
    return AppConfig().themeData!.primaryColor;
  }
  if (state.itemIdToGeneralItem[itemId] != null && state.itemIdToGeneralItem[itemId]!.primaryColor != null) {
    return state.itemIdToGeneralItem[itemId]!.primaryColor!;
  }
  return state.gameTheme?.primaryColor ?? AppConfig().themeData!.primaryColor;
});