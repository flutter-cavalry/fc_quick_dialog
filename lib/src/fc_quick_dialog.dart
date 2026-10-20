import 'package:flutter/material.dart';

const _dartExpPrefix = 'Exception: ';

class FcQuickDialog {
  /// Shows a standard alert dialog with [title], [content] and [okText].
  /// If [titleWidget] is not null, it will be displayed instead of [title].
  /// If [contentWidget] is not null, it will be displayed instead of [content].
  static Future<void> info(
    BuildContext context, {
    String? title,
    String? content,
    required String okText,
    Widget? titleWidget,
    Widget? contentWidget,
  }) async {
    if (!context.mounted) {
      return;
    }
    titleWidget ??= title == null ? null : Text(title);
    contentWidget ??= content == null ? null : SelectableText(content);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: titleWidget,
          content: contentWidget,
          actions: [
            TextButton(
              child: Text(okText),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirm dialog with [title], [content], [yesText], [noText].
  ///
  /// If [cancelText] is not null, a cancel button will be added to the dialog.
  /// Returns true if the user selects yes, false if the user selects no, and
  /// null if the user cancels the dialog.
  /// If [titleWidget] is not null, it will be displayed instead of [title].
  /// If [contentWidget] is not null, it will be displayed instead of [content].
  static Future<bool?> confirm(
    BuildContext context, {
    required String yesText,
    required String noText,
    String? title,
    String? content,
    String? cancelText,
    Widget? titleWidget,
    Widget? contentWidget,
  }) async {
    if (!context.mounted) {
      return null;
    }
    titleWidget ??= title == null ? null : Text(title);
    contentWidget ??= content == null ? null : SelectableText(content);

    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final buttons = <Widget>[
          TextButton(
            child: Text(yesText),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
          TextButton(
            child: Text(noText),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
        ];
        if (cancelText != null) {
          buttons.add(
            TextButton(
              child: Text(cancelText),
              onPressed: () => Navigator.of(dialogContext).pop(null),
            ),
          );
        }

        return AlertDialog(
          title: titleWidget,
          content: contentWidget,
          actions: buttons,
        );
      },
    );
  }

  /// Shows an error dialog with [title], [error], and [okText].
  /// [error] can be any object including a [Widget].
  ///
  static Future<void> error(
    BuildContext context, {
    required Object error,
    required String okText,
    String? title,
    Widget? titleWidget,
  }) async {
    if (!context.mounted) {
      return;
    }
    titleWidget ??= title == null ? null : Text(title);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: titleWidget,
        content: error is Widget
            ? error
            : SelectableText(extractErrorMessage(error)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
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
  static Future<String?> textInput(
    BuildContext context, {
    required String title,
    required String okText,
    required String? cancelText,
    bool password = false,
    String? initialValue,
    String? subTitle,
  }) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        void onOKDone() {
          if (controller.text.isEmpty) {
            return;
          }
          Navigator.of(dialogContext).pop(controller.text);
        }

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
              ),
            ],
          ),
          actions: <Widget>[
            if (cancelText != null)
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            TextButton(onPressed: onOKDone, child: Text(okText)),
          ],
        );
      },
    );
  }

  /// Extracts the error message from [err].
  static String extractErrorMessage(Object err) {
    var msg = err.toString();
    if (msg.startsWith(_dartExpPrefix) == true) {
      msg = msg.substring(_dartExpPrefix.length);
    }
    return msg;
  }
}
