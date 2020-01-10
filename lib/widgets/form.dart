import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_image/network.dart';

class NumberForm extends StatefulWidget {
  NumberForm({Key key}) : super(key: key);

  @override
  _NumberFormState createState() => _NumberFormState();
}

class _NumberFormState extends State<NumberForm> {
  TextEditingController lowerNumberController = TextEditingController();
  TextEditingController upperNumberController = TextEditingController();
  List<int> encodeList;
  List<Digest> linkString = List<Digest>();
  bool isPressed = false;
  List<int> valuesList = List<int>();
  FocusNode _focusNodeLower = FocusNode();
  FocusNode _focusNodeUpper = FocusNode();
  @override
  void dispose() {
    lowerNumberController.dispose();
    upperNumberController.dispose();
    _focusNodeLower.dispose();
    _focusNodeUpper.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNodeLower.addListener(() {});
    _focusNodeUpper.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: TextFormField(
            maxLength: 6,
            autofocus: false,
            maxLengthEnforced: true,
            controller: lowerNumberController,
            keyboardType: TextInputType.number,
            focusNode: _focusNodeLower,
            decoration: InputDecoration(
                labelText: 'Alt aralik', border: OutlineInputBorder()),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          child: TextFormField(
            autofocus: false,
            maxLengthEnforced: true,
            maxLength: 6,
            controller: upperNumberController,
            focusNode: _focusNodeUpper,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                labelText: 'Ust aralik', border: OutlineInputBorder()),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          child: RaisedButton(
            child: Text('Resmini goster'),
            onPressed: () {
              _unFocusNodes();
              //text in controll can be nothing but integer, so this is ok to do
              if (int.parse(lowerNumberController.text) <
                  int.parse(upperNumberController.text)) {
                setState(() {
                  linkString.clear();
                  valuesList.clear();
                  //formatter messes this up so it's not readable, its basically dx of upper and lower value
                  for (int i = 0;
                      i <
                          (int.parse(upperNumberController.text) -
                              int.parse(lowerNumberController.text));
                      i++) {
                    valuesList.add(int.parse(lowerNumberController.text) + i);
                    encodeList = utf8.encode(valuesList[i].toString());
                    linkString.add(md5.convert(encodeList));
                  }
                  isPressed = true;
                });
              } else {
                Fluttertoast.showToast(
                    msg: "Ust aralik alt araliktan kucuk olamaz",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          ),
        ),
        //add container here, for padding
        Visibility(
          visible: isPressed,
          child: Expanded(
            //otherwise gridview doesn't show up in column
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                linkString.length,
                (index) {
                  //generate a list of containers that have the image
                  return InkWell(
                    onTap: () {
                      _unFocusNodes();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return PhotoView(
                              imageProvider: NetworkImageWithRetry(
                                  'http://bis.ktu.edu.tr/personel/${linkString[index]}.jpg'),
                              heroAttributes: PhotoViewHeroAttributes(
                                tag: 'tag$index',
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Hero(
                        tag: 'tag$index',
                        child: Image(
                          image: NetworkImageWithRetry(
                            'http://bis.ktu.edu.tr/personel/${linkString[index]}.jpg',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  void _unFocusNodes() {
    setState(() {
      _focusNodeLower.unfocus();
      _focusNodeUpper.unfocus();
    });
  }
}
