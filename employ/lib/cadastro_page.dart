import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Amostragem_Page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  @override
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _areaController = TextEditingController();
  final _metasController = TextEditingController();
  final _areaxpController = TextEditingController();
  final _passController = TextEditingController();
  String chosseProfission;
  String escolaridade;
  double size = 56;
  double pad = 2.5;
  int current_value = 0;
  int type_value = 0;
  File _image;
  File _Curriculo;
  FirebaseUser user;

  Future getImage(verification) async {
    try {
      if (verification) {
        var img = await ImagePicker.pickImage(source: ImageSource.gallery);
        await setState(() {
          _image = img;
        });
        return _image;
      } else {
        var img = await ImagePicker.pickImage(source: ImageSource.camera);
        await setState(() {
          _image = img;
        });
        return _image;
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCurriculo() async {
    try {
      var curriculo = await FilePicker.getFile();
      await setState(() {
        _Curriculo = curriculo;
      });
      return _Curriculo;
    } catch (e) {
      print("*" * 50);
      print(e);
      print("*" * 50);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(40, 37, 65, 1),
        body: ScopedModelDescendant<UserModel>(
            builder: (context, builder, model) {
          if (model.isLodding)
            return Center(
              child: CircularProgressIndicator(),
            );
          return PageView(children: <Widget>[
            ListView(
              children: <Widget>[
                Center(
                  child: Form(
                      child: Card(
                    margin: EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Color.fromRGBO(62, 57, 98, 1),
                          boxShadow: [
                            new BoxShadow(
                                color: Colors.black, blurRadius: 10.0),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(pad),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Selecionar Foto",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  124, 124, 188, 1),
                                              fontFamily: 'UbuntuM',
                                              fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          124, 124, 188, 1),
                                                      width: 5.0),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: _image != null
                                                          ? FileImage(
                                                              _image) //Este Tipo não pode ser declarado com File.image pois há um comflito de tipos
                                                          : AssetImage(
                                                              "lib/images/person.png"),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    getImage(true);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 100),
                                  child: GestureDetector(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(124, 124, 188, 1),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      getImage(false);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Nome Completo"),
                              enabled: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _passController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Senha"),
                              enabled: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _passController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Confirma Senha"),
                              enabled: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardAppearance: Brightness.light,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Email"),
                              enabled: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _areaxpController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Profissão"),
                              enabled: true,
                            ),
                          ),
                          FlatButton(
                              onPressed: () {
                                getCurriculo();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.file_download,
                                    color: Color.fromRGBO(124, 124, 188, 1),
                                  ),
                                  Text("Carregar Currículo",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(124, 124, 188, 1),
                                          fontFamily: 'UbuntuM'))
                                ],
                              )),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: ListTile(
                                      title: const Text(
                                        "Empregador",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: Color.fromRGBO(
                                                124, 124, 188, 1),
                                            fontFamily: 'UbuntuM'),
                                      ),
                                      leading: Radio(
                                          value: 1,
                                          groupValue: type_value,
                                          onChanged: (int e) =>
                                              ServiceType(e)))),
                              Expanded(
                                  child: ListTile(
                                      title: const Text(
                                        "Empregado",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromRGBO(
                                                124, 124, 188, 1),
                                            fontFamily: 'UbuntuM'),
                                      ),
                                      leading: Radio(
                                          value: 2,
                                          groupValue: type_value,
                                          onChanged: (int e) =>
                                              ServiceType(e)))),
                            ],
                          ),
                          RaisedButton(
                            onPressed: () async {
                              String curriculo =
                                  await model.saveCurriculo(_Curriculo);
                              String FileURL = await model.saveImage(_image);
                              print(FileURL);
                              if (FileURL == null) {
                                ImageNotFound();
                              } else {
                                Map<String, dynamic> userData = {
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                  "area_experiencia": _areaxpController.text,
                                  "tipo": chosseProfission,
                                  "img": FileURL.toString(),
                                  "curriculo": FileURL.toString()
                                };
                                model.SignUp(
                                    userData: userData,
                                    pass: _passController.text,
                                    onsucess: _onSucess,
                                    onFail: _onFail);                                    
                              }
                            },
                            color: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                            child: Text(
                              "Submeter",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'UbuntuM'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Ao submeter ,seu perfil será submetido para análise e depois será adcionado ao banco de dados da plataforma",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromRGBO(124, 124, 188, 1),
                                  fontFamily: 'UbuntuM'),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                ),
              ],
            )
          ]);
        }));
  }

  void _onSucess() {
    AlertDialog(
      title: Text("Usuário Submetido com sucesso"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
    print("*" * 150);
    print("Usuario Cadastrado");
    print("*" * 150);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    /*Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));*/
  }

  void _onFail() {
    AlertDialog(
      title: Text("Erro na submissão do Usuário"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
    print("*-" * 150);
    print("Usuario Não cadastrado");
    print("*-" * 150);
    //Navigator.pop(context);
  }

  void ImageNotFound() {
    AlertDialog(
      title: Text("Imagem não encontrada"),
      content: Text(
          "É necessário uma foto para sua identificação na plataforma,recomeda-se usar um foto do seu documento de identidade"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void ServiceType(int e) {
    setState(() {
      switch (e) {
        case 1:
          chosseProfission = "Empregador";
          type_value = e;
          break;
        case 2:
          chosseProfission = "Empregado";
          type_value = e;
          break;
      }
    });
  }

  bool validate() {
    if (_emailController.text.isEmpty) {
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        title: Text("Insira um email válido!"),
      );
      return false;
    }

    if (_nameController.text.contains("pica") ||
        _nameController.text.contains("porra") ||
        _nameController.text.contains("caralho") ||
        _nameController.text.contains("piroca") ||
        _nameController.text.contains("fdp")) {
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        title: Text("É extremamente proibido o uso de palavras obscenas!"),
      );
      return false;
    }
  }
}
