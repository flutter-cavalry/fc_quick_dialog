# fc_quick_dialog

[![pub package](https://img.shields.io/pub/v/fc_quick_dialog.svg)](https://pub.dev/packages/fc_quick_dialog)

Lightweight Material dialogs for alerts, confirmations, errors, and text input—similar to JavaScript's `alert()`, `confirm()`, and `prompt()`.

## Usage

```dart
// Show a confirmation dialog.
final result = await FcQuickDialog.confirm(
  context,
  title: 'Confirm',
  yesText: 'Yes',
  noText: 'No',
  cancelText: 'Cancel',
  content: 'Are you sure?',
);

// Show an informational dialog.
await FcQuickDialog.info(
  context,
  title: 'Information',
  okText: 'OK',
  content: 'You selected $result',
);

// Show an error dialog.
await FcQuickDialog.error(
  context,
  error: 'Exception: Test plugin error',
  title: 'Error',
  okText: 'OK',
);

// Ask the user to enter text.
final text = await FcQuickDialog.textInput(
  context,
  title: 'Enter some text',
  subTitle: 'Add details below',
  okText: 'OK',
  cancelText: 'Cancel',
);

// Ask the user to enter a password.
final pwd = await FcQuickDialog.textInput(
  context,
  title: 'Enter your password',
  password: true,
  okText: 'OK',
  cancelText: 'Cancel',
);
```
