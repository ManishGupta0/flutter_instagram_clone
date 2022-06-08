import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/globals/globals.dart';

void showSnackBar(String text) {
  globalSnackbarKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(text),
      duration: const Duration(milliseconds: 3000),
      action: SnackBarAction(
        label: "Dismiss",
        onPressed: () {
          globalSnackbarKey.currentState?.hideCurrentSnackBar();
        },
      ),
    ),
  );
}
