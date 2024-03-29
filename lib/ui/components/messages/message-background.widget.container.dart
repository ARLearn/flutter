import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:youplay/models/game_theme.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/store/selectors/selector.generalitems.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/util/extended_network_image.dart';

import '../../../store/selectors/selector.gametheme.dart';

class MessageBackgroundWidgetContainer extends StatelessWidget {
  final Widget child;
  final bool darken;
  final Function()? onTap;

  MessageBackgroundWidgetContainer({
    required this.child,
    this.darken: false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      builder: (context, vm) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Container(
              decoration: getBoxDecoration(vm.getBackground() ?? vm.gameTheme?.backgroundPath),
              child: Container(color: darken ? Color.fromRGBO(0, 0, 0, 0.7) : null, child: child)),
        );
      },
    );
  }
}

class _ViewModel {
  GameTheme? gameTheme;
  GeneralItem item;

  _ViewModel({this.gameTheme, required this.item});

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      gameTheme: currentThemeSelector(store.state),
      item: currentGeneralItemNew(store.state) as GeneralItem,
    );
  }

  String? getBackground() {
    if (item.fileReferences != null &&
        item.fileReferences!['background'] != null &&
        item.fileReferences!['background'] != '') {
      return item.fileReferences!['background'];
    }
    return null;
  }

  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _ViewModel && (other.item.itemId == item.itemId);
  }

  @override
  int get hashCode => item.itemId;
}
