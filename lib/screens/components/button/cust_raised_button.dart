import 'package:flutter/material.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/screens/general_item/util/messages/components/game_themes.viewmodel.dart';

class CustomRaisedButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Icon? icon;
  Color? _primaryColor;

  final bool disabled;

  CustomRaisedButton({
    required this.onPressed,
    required this.title,
    this.icon,
    Color? primaryColor,
    this.disabled = false,
  }) : _primaryColor = primaryColor ?? AppConfig().themeData!.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: AppConfig.isTablet() ? 290 : double.infinity,
          height: 51.0,
          child: buildButton(context),
        ),
      ],
    );
  }

  buildButton(BuildContext context) {
    // if (!useThemeColor) {
    return _buildRawButton();
    // }
    // return new StoreConnector<AppState, GameThemesViewModel>(
    //     converter: (store) => GameThemesViewModel.fromStore(store),
    //     builder: (context, GameThemesViewModel themeModel) {
    //       return _buildRawButton(themeModel: themeModel);
    //     });
  }

  _buildRawButton({GameThemesViewModel? themeModel}) {
    if (icon == null) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: (this._primaryColor != null)
                  ? this._primaryColor
                  : (themeModel == null ? null : themeModel.getPrimaryColor()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.0),
              ),
              textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          onPressed: disabled ? null : onPressed,
          child: Text(
            '$title',
            style: AppConfig().customTheme!.nextButtonStyle,
          ));
    } else {
      return RaisedButton.icon(
          color: (this._primaryColor != null)
              ? this._primaryColor
              : (themeModel == null ? null : themeModel.getPrimaryColor()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.0),
          ),
          onPressed: disabled ? null : onPressed,
          icon: icon!,
          label: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w900,
            ),
          ));
    }
  }
}
