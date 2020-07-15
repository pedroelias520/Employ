import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Amostragem_Page.dart';
import 'Amostragem_PageEmpregador.dart';
import 'models/user_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  String type;
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(40, 37, 65, 1),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            String service_type = model.userData['tipo'];
            if (service_type == 'Empregador') {
              type = 'Contratar Serviço';
            } else {
              type = 'Prestar Serviço';
            }
            if (model.isLodding)
              return Center(
                heightFactor: 2.0,
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
            if (model.userData["name"] == null)
              return Center(
                heightFactor: 2.0,
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text(
                      "Carregando Usuário...",
                      style: TextStyle(fontFamily: 'UbuntuM'),
                    ),
                  ],
                ),
              );
            if (model.userData["img"] == null)
              return Center(
                heightFactor: 2.0,
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text(
                      "Carregando Imagem...",
                      style: TextStyle(fontFamily: 'UbuntuM'),
                    )
                  ],
                ),
              );
            return Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {},
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 67),
                          child: Text(
                            "EMPLOY",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'UbuntuM',
                                fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    heightFactor: 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "Bem-Vindo!",
                            style: TextStyle(
                                fontFamily: 'UbuntuM',
                                color: Colors.white,
                                fontSize: 40),
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(!model.isLoggedIn()
                              ? Icon(Icons.person_pin)
                              : model.userData["img"]),
                          radius: 80,
                          backgroundColor: Colors.transparent,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "${!model.isLoggedIn() ? "" : model.userData["tipo"]}",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'UbuntuM',
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "${!model.isLoggedIn() ? "" : model.userData["name"]}",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'UbuntuM',
                                fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Oque deseja fazer hoje?",
                            style: TextStyle(
                                fontFamily: 'UbuntuM',
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.deepOrange,
                            onPressed: () {},
                            child: Container(
                              width: 110,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Notificações",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.lightBlueAccent,
                                      radius: 10,
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'UbuntuM',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            onPressed: () {
                              switch (service_type) {
                                case "Empregador":
                                  type = 'Contratar um serviço';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AmostragemPage()),
                                  );
                                  break;
                                case "Empregado":
                                  type = 'Prestar um serviço';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AmostragemPageEmpregador()),
                                  );
                                  break;
                              }
                            },
                            color: Colors.deepOrange,
                            child: Text(
                              type,
                              style: TextStyle(
                                  fontFamily: 'UbuntuM', color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            color: Colors.deepOrange,
                            child: Text(
                              "Editar Perfil",
                              style: TextStyle(
                                  fontFamily: 'UbuntuM', color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
