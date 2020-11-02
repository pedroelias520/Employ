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
  final _passController_Confirm = TextEditingController();
  String chosseProfission;
  String escolaridade;
  double size = 56;
  double pad = 2.5;
  int current_value = 0;
  int type_value = 0;
  File _image;
  File _Curriculo;
  FirebaseUser user;
  String alert = "Confirmation";
  bool obscureText = true;

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
        backgroundColor: Color.fromRGBO(39, 71, 103, 1),
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
                          color: Color.fromRGBO(6, 129, 251, 1),
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
                                              color: Colors.white,
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
                                                      color: Colors.white,
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
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.blue,
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
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'UbuntuM'),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: new BorderSide(
                                          color:
                                              Color.fromRGBO(143, 199, 255, 1),
                                          width: 2.0)),
                                  labelText: "Nome Completo"),
                              enabled: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _passController,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'UbuntuM'),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              obscureText: !obscureText,
                              validator: (val) => val.length < 6
                                  ? "Sua senha é muito curta"
                                  : null,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: new BorderSide(
                                          color:
                                              Color.fromRGBO(143, 199, 255, 1),
                                          width: 2.0)),
                                  labelText: "Senha"),
                              enabled: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _passController_Confirm,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'UbuntuM'),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              validator: (val) => _passController.text == val
                                  ? alert = "Senhas iguais"
                                  : alert = "Senhas não coincidem",
                              obscureText: !obscureText,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(143, 199, 255, 1),
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  labelText: "Confirma Senha"),
                              enabled:
                                  _passController.text == null ? false : true,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: obscureText,
                                onChanged: (bool value) {
                                  setState(() {
                                    obscureText = value;
                                  });
                                },
                              ),
                              Text(
                                "Mostrar senha",
                                style: TextStyle(
                                    fontFamily: 'UbuntuM',
                                    color: Color.fromRGBO(143, 199, 255, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 80.0),
                                child: Text(
                                  _passController.text == _passController_Confirm.text ? " " : "Senhas diferentes",
                                  style: TextStyle(
                                      fontFamily: 'UbuntuM',
                                      color: Colors.red),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardAppearance: Brightness.light,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'UbuntuM'),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: new BorderSide(
                                          color:
                                              Color.fromRGBO(143, 199, 255, 1),
                                          width: 2.0)),
                                  labelText: "Email"),
                              enabled: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(pad),
                            height: size,
                            child: TextFormField(
                              controller: _areaxpController,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'UbuntuM'),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color:
                                              Color.fromRGBO(143, 199, 255, 1),
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
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
                                    color: Color.fromRGBO(143, 199, 255, 1),
                                  ),
                                  Text("Carregar Currículo",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(143, 199, 255, 1),
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
                                                143, 199, 255, 1),
                                            fontFamily: 'UbuntuM'),
                                      ),
                                      leading: Radio(
                                          activeColor: Colors.deepOrange,
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
                                                143, 199, 255, 1),
                                            fontFamily: 'UbuntuM'),
                                      ),
                                      leading: Radio(
                                          activeColor: Colors.deepOrange,
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
                              }
                              if (validate()) {
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
                              "Cadastrar",
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
                                  color: Color.fromRGBO(143, 199, 255, 1),
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
    if (_passController.text == _passController_Confirm.text) {
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        title: Text("Os campos de senha estão errados!"),
      );
      return false;
    }
  }
}
