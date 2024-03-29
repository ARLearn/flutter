import 'package:flutter/material.dart';
import 'package:youplay/config/app_config.dart';

class CustomFlatButton extends StatelessWidget {
  Function onPressed;
  String title;
  IconData? icon;
  Color? color;
  Color? colorBorder;
  Color? backgroundColor;

  CustomFlatButton({
    required this.onPressed,
    required this.title,
    this.icon,
    this.colorBorder,
    this.color,
    this.backgroundColor,
  });

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
    if (icon == null) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.0),
                side: BorderSide(width: 2, color: colorBorder ?? color ?? AppConfig().themeData!.primaryColor)),
          ),
          onPressed: () {
            onPressed();
          },
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              '$title',
              style: TextStyle(
                color: color ?? AppConfig().themeData!.primaryColor,
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ));

      // return FlatButton(
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(26.0),
      //         side: BorderSide(width: 2, color: colorBorder ?? color ?? AppConfig().themeData!.primaryColor)),
      //     onPressed: () {
      //       onPressed();
      //     },
      //     child: FittedBox(
      //       fit: BoxFit.fitWidth,
      //       child: Text(
      //         '$title',
      //         style: TextStyle(
      //           color: color ?? AppConfig().themeData!.primaryColor,
      //           fontSize: 22.0,
      //           fontWeight: FontWeight.w900,
      //         ),
      //       ),
      //     ));
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            // minimumSize: Size(60, 24),
            backgroundColor: backgroundColor ?? Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.0),
                side: BorderSide(width: 2, color: colorBorder ?? color ?? AppConfig().themeData!.primaryColor))),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Icon(icon, color: color ?? AppConfig().themeData!.primaryColor),
            Flexible(
              flex: 1,
              child: Text(
                '$title',
                style: TextStyle(
                  color: color ?? AppConfig().themeData!.primaryColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      );

      // return FlatButton(
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(26.0),
      //       side: BorderSide(width: 2, color: colorBorder ?? color ?? AppConfig().themeData!.primaryColor)),
      //   onPressed: () {
      //     onPressed();
      //   },
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     mainAxisSize: MainAxisSize.max,
      //     children: [
      //       new Icon(icon, color: color ?? AppConfig().themeData!.primaryColor),
      //       Flexible(
      //         flex: 1,
      //         child: Text(
      //           '$title',
      //           style: TextStyle(
      //             color: color ?? AppConfig().themeData!.primaryColor,
      //             fontSize: 22.0,
      //             fontWeight: FontWeight.w900,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }
  }
}
