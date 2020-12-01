import 'package:auto_size_text/auto_size_text.dart';
import 'package:employ/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';

class SelectPage extends StatefulWidget {
  String id, name, img, email, tipo, area_experiencia, curriculo;
  SelectPage(id, name, img, email, tipo, area_experiencia, curriculo) {
    this.id = id;
    this.name = name;
    this.img = img;
    this.email = email;
    this.tipo = tipo;
    this.area_experiencia = area_experiencia;
    this.curriculo = curriculo;
  }

  @override
  _SelectPageState createState() =>
      _SelectPageState(id, name, img, email, tipo, area_experiencia, curriculo);
}

class _SelectPageState extends State<SelectPage> {
  String id, name, img, email, tipo, area_experiencia, curriculo;
  _SelectPageState(id, name, img, email, tipo, area_experiencia, curriculo) {
    this.id = id;
    this.name = name;
    this.img = img;
    this.email = email;
    this.tipo = tipo;
    this.area_experiencia = area_experiencia;
    this.curriculo = curriculo;
  }
  @override
  Widget build(BuildContext context) {
    var List = [name, img, email, tipo, area_experiencia, curriculo];
    print("-" * 150);
    print(List);
    print("-" * 150);
    return Scaffold(
      backgroundColor: Color.fromRGBO(62, 57, 98, 1),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLodding || model.userData == null)
          return Center(
            child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
                Text(
                  "Carregando...",
                  style: TextStyle(fontFamily: 'UbuntuM'),
                )
              ],
            ),
          );
        return PageView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 0),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 30,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                "EMPLOY",
                                style: TextStyle(
                                    fontFamily: 'UbuntuM',
                                    color: Colors.white,
                                    fontSize: 30),
                              )),
                        )
                      ],
                    ),
                  ),
                  Center(
                    heightFactor: 1.2,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(img),
                          radius: 90,
                          foregroundColor: Colors.white,
                        ),
                        //Color.fromRGBO(76, 76, 126, 1)
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Color.fromRGBO(76, 76, 126, 1),
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: <Widget>[
                                AutoSizeText(
                                  name,
                                  style: TextStyle(
                                      fontFamily: 'UbuntuM',
                                      color: Color.fromRGBO(200, 200, 224, 1),
                                      fontSize: 25),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: 20,
                                    height: 2.5,
                                    color: Color.fromRGBO(148, 147, 205, 1),
                                  ),
                                ),
                                Text(
                                  id,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.deepOrange,
                                      fontFamily: 'UbuntuM'),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(148, 147, 205, 1),
                                      fontFamily: 'UbuntuM'),
                                ),
                                Text(
                                  tipo,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(148, 147, 205, 1),
                                      fontFamily: 'UbuntuM'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.file_download,
                                  color: Color.fromRGBO(148, 147, 205, 1),
                                ),
                                Text(
                                  "Baixar Curriculo",
                                  style: TextStyle(
                                      color: Color.fromRGBO(148, 147, 205, 1),
                                      fontFamily: 'UbuntuB'),
                                )
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 20,
                            height: 2.5,
                            color: Color.fromRGBO(148, 147, 205, 1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            color: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tipo == 'Empregador'
                                  ? "Pedir Serviço"
                                  : "Contratar Serviços",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'UbuntuM'),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
