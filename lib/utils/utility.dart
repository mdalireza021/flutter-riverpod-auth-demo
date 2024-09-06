import 'package:flutter/material.dart';
import '../services/GlobalService.dart';

bool isValidEmailAddress(String email) {
  return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}
showSnackBar(BuildContext context, String? message, bool isError) {
  var mContext = GlobalService().navigatorKey!.currentContext;
  mContext ??= context;

  ScaffoldMessenger.of(mContext).hideCurrentSnackBar();

  ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red[600] : Colors.grey[800],
    content: Text(
      message ?? "",
      style: const TextStyle(color: Colors.white),
    ),
    duration: isError ? const Duration(seconds: 3) : const Duration(milliseconds: 1500),
    action: isError
        ? SnackBarAction(
      label: '✖',
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(mContext!).hideCurrentSnackBar();
      },
    )
        : null,
  ));
}

void removeFocusFromInputField(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
