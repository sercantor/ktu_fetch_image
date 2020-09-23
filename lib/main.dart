import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import './widgets/form.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'KTU fetch image';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(title),
          ),
          body: NumberForm()),
    );
  }
}
