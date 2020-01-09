import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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
  double _updatedScale = 1.0;

  @override
  void dispose() {
    lowerNumberController.dispose();
    upperNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: TextFormField(
            maxLength: 6,
            controller: lowerNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Alt aralik', border: OutlineInputBorder()),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          child: TextFormField(
            maxLength: 6,
            controller: upperNumberController,
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
                  //'http://bis.ktu.edu.tr/personel/${linkString[index]}.jpg'),
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return PhotoView(
                              imageProvider: NetworkImageWithRetry(
                                  'http://bis.ktu.edu.tr/personel/${linkString[index]}.jpg'),
                                  heroAttributes: PhotoViewHeroAttributes(tag: 'tag', ),
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
                              'http://bis.ktu.edu.tr/personel/${linkString[index]}.jpg'),
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

}
