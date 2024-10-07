import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _dartExpPrefix = 'Exception: ';

class FcQuickDialog {
  /// Shows a standard alert dialog with [title], [content] and [okText].
  static Future<void> standard(BuildContext context,
      {required String? title, String? content, required String okText}) async {
    if (!context.mounted) {
      return;
    }
    final Widget okButton = TextButton(
      child: Text(okText),
      onPressed: () => Navigator.of(context).pop(),
    );

    final alert = AlertDialog(
      title: title == null ? null : Text(title),
      content: content == null ? null : SelectableText(content),
      actions: [okButton],
    );

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Shows a confirm dialog with [title], [content], [yesText], [noText].
  ///
  /// If [cancelText] is not null, a cancel button will be added to the dialog.
  /// Returns true if the user selects yes, false if the user selects no, and
  /// null if the user cancels the dialog.
  static Future<bool?> confirm(BuildContext context,
      {required String? title,
      String? content,
      required String yesText,
      required String noText,
      String? cancelText}) async {
    if (!context.mounted) {
      return false;
    }
    final noButton = TextButton(
      child: Text(noText),
      onPressed: () => Navigator.of(context).pop(false),
    );
    final yesButton = TextButton(
      child: Text(yesText),
      onPressed: () => Navigator.of(context).pop(true),
    );
    final buttons = <Widget>[yesButton, noButton];
    if (cancelText != null) {
      final cancelButton = TextButton(
        child: Text(cancelText),
        onPressed: () => Navigator.of(context).pop(null),
      );
      buttons.add(cancelButton);
    }

    final alert = AlertDialog(
      title: title == null ? null : Text(title),
      content: content == null ? null : SelectableText(content),
      actions: buttons,
    );

    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Shows an error dialog with [title], [error], and [okText].
  static Future<void> error(BuildContext context,
      {required String? title,
      required Object error,
      required String okText}) async {
    if (!context.mounted) {
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: title == null ? null : Text(title),
        content: SelectableText(extractErrorMessage(error)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(okText),
          ),
        ],
      ),
    );
  }

  /// Shows a text input dialog with [title], [okText], and [cancelText].
  ///
  /// If [subTitle] is not null, it will be displayed above the text field.
  /// If [password] is true, the text field will be obscured.
  /// [initialValue] is the initial value of the text field.
  static Future<String?> textInput(BuildContext context,
      {required String title,
      required String okText,
      required String cancelText,
      bool password = false,
      String? initialValue,
      String? subTitle}) async {
    final controller = TextEditingController(text: initialValue);
    void onOKDone() {
      if (controller.text.isEmpty) {
        return;
      }
      Navigator.pop(context, controller.text);
    }

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (subTitle != null) Text(subTitle),
              if (subTitle != null) const SizedBox(height: 10),
              TextField(
                controller: controller,
                autofocus: true,
                obscureText: password,
                onSubmitted: (value) => onOKDone(),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(cancelText),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              onPressed: onOKDone,
              child: Text(okText),
            ),
          ],
        );
      },
    );
  }

  /// Extracts the error message from [err].
  static String extractErrorMessage(Object err) {
    String? msg;
    if (err is PlatformException) {
      msg = err.message;
    }
    // ignore: prefer_conditional_assignment
    if (msg == null) {
      msg = err.toString();
    }
    if (msg.startsWith(_dartExpPrefix) == true) {
      msg = msg.substring(_dartExpPrefix.length);
    }
    return msg;
  }
}
