import 'package:flutter/material.dart';
import './widgets/form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'KTU fetch image';
    return MaterialApp(
      title: title,
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(title),
          ),
          body: NumberForm()
            ),
    );
  }
}
