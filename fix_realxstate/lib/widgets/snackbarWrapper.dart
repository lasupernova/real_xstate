import 'package:flutter/material.dart';

class SnackbarWrapper {
  // const SnackbarWrapper({Key? key}) : super(key: key);
  final BuildContext context;
  final String displayText;
  final String actionText;
  final int dur;
  final actionFunc;

  SnackbarWrapper(
      {required this.context,
      this.displayText = "Done",
      this.actionText = "",
      this.dur = 3,
      this.actionFunc});

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(displayText),
      duration: Duration(seconds: dur),
      // backgroundColor: (Colors.black12),
      action: actionText == ""
          ? SnackBarAction(
              label: actionText,
              onPressed: () {},
            )
          : SnackBarAction(
              label: actionText,
              onPressed: actionFunc,
              textColor: Theme.of(context).colorScheme.primary,
            ),
    ));
  }
}
