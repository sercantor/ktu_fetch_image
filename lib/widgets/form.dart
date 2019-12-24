import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter_image/network.dart';

class NumberForm extends StatefulWidget {
  NumberForm({Key key}) : super(key: key);

  @override
  _NumberFormState createState() => _NumberFormState();
}

class _NumberFormState extends State<NumberForm> {
  TextEditingController numberController = TextEditingController();
  List<int> numberValue;
  var linkString;
  bool isPressed = false;

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: TextFormField(
            controller: numberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Numarani gir', border: OutlineInputBorder()),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          child: RaisedButton(
            child: Text('Resmini goster'),
            onPressed: () {
              setState(() {
                numberValue = utf8.encode(numberController.text);
                linkString = md5.convert(numberValue);
                isPressed = true;
              });
            },
          ),
        ),
        Visibility(
          visible: isPressed,
          child: Container(
            padding: EdgeInsets.all(6.0),
            child: Image(
              image: NetworkImageWithRetry(
                  'http://bis.ktu.edu.tr/personel/$linkString.jpg'),
            ),
          ),
        )
      ],
    );
  }
}
