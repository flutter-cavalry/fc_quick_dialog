# fc_quick_dialog

[![pub package](https://img.shields.io/pub/v/fc_quick_dialog.svg)](https://pub.dev/packages/fc_quick_dialog)

Quick and simple dialogs like JavaScript's `alert`, `confirm` and `prompt`.

## Usage

```dart
// Confirm dialog.
final result = await FcQuickDialog.confirm(context,
    title: 'Confirm',
    yesText: 'Yes',
    noText: 'No',
    cancelText: 'Cancel',
    content: 'Are you sure?');

// Standard dialog.
await FcQuickDialog.info(context,
    title: 'Info',
    okText: 'OK',
    content: 'You selected $result');

// Error dialog.
await FcQuickDialog.error(
    context,
    error: 'Exception: Test plugin error',
    title: 'Error',
    okText: 'OK');

// Text input dialog.
final text = await FcQuickDialog.textInput(
    context,
    title: 'Enter a text',
    subTitle: 'This is a subtitle',
    okText: 'OK',
    cancelText: 'Cancel',
  );

// Password input dialog.
final pwd = await FcQuickDialog.textInput(
    context,
    title: 'Enter your password',
    password: true,
    okText: 'OK',
    cancelText: 'Cancel',
  );
```
