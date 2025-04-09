import 'package:flutter/material.dart';

class AnimatedDialogBox {
  static Future showScaleAlertBox({
    required BuildContext context,
    required Widget yourWidget,
    required Widget icon,
    required Widget title,
    Widget? firstButton,
    Widget? secondButton,
    bool barrierDismissible = true,
  }) {
    assert(true, "context is null!!");
    assert(true, "yourWidget is null!!");
    assert(firstButton != null, "button is null!!");
    List<Widget> actions = [];
    if (firstButton != null) {
      actions.add(firstButton);
    }
    if (secondButton != null) {
      actions.add(secondButton);
    }

    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              title: title,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  icon,
                  Container(
                    height: 10,
                  ),
                  yourWidget
                ],
              ),
              actions: actions,
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Container();
      },
    );
  }
}
