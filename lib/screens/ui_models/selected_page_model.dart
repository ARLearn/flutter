import 'package:redux/redux.dart';
import 'package:youplay/selectors/authentication_selectors.dart';
import 'package:youplay/selectors/ui_selectors.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/state/ui_state.dart';

class SelectedPageModel {

  PageType selectedPage;
  bool isAuthenticated;

  SelectedPageModel({this.selectedPage, this.isAuthenticated});

  static SelectedPageModel fromStore(Store<AppState> store) {
    return new SelectedPageModel(
        selectedPage: currentPage(store.state),
        isAuthenticated: isAuthenticatedSelector(store.state)
    );
  }
}


