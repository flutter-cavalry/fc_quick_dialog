import 'package:fc_quick_dialog/fc_quick_dialog.dart';
import 'package:flutter/material.dart';

const colorSeed = Colors.deepPurple;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorSeed,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: colorSeed,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _resultToString(bool? result) {
    if (result == null) {
      return 'Cancel';
    }
    return result ? 'Yes' : 'No';
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
                onPressed: () async {
                  await FcQuickDialog.error(
                      context, 'Exception: Test plugin error',
                      title: 'Error', okText: 'OK');
                },
                child: const Text('Error')),
            const SizedBox(height: 10),
            OutlinedButton(
                onPressed: () async {
                  final result = await FcQuickDialog.confirm(context,
                      title: 'Confirm',
                      yesText: 'Yes',
                      noText: 'No',
                      content: 'Are you sure?');
                  if (!context.mounted) {
                    return;
                  }
                  await FcQuickDialog.standard(context,
                      title: 'Info',
                      okText: 'OK',
                      content: 'You selected "${_resultToString(result)}"');
                },
                child: const Text('Confirm (Yes/No)')),
            const SizedBox(height: 10),
            OutlinedButton(
                onPressed: () async {
                  final result = await FcQuickDialog.confirm(context,
                      title: 'Confirm',
                      yesText: 'Yes',
                      noText: 'No',
                      cancelText: 'Cancel',
                      content: 'Are you sure?');
                  if (!context.mounted) {
                    return;
                  }
                  await FcQuickDialog.standard(context,
                      title: 'Info',
                      okText: 'OK',
                      content: 'You selected "${_resultToString(result)}"');
                },
                child: const Text('Confirm (Yes/No/Cancel)')),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
