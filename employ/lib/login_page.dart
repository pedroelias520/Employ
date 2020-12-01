import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'cadastro_page.dart';
import 'home_page.dart';
import 'models/user_model.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();
String name_user;
String email_user;
String PhotoUrl_user;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  FirebaseUser firebaseUser;
  List<UserModel> items;
  StreamBuilder<QuerySnapshot> users;

  void initState() {
    super.initState();
    items = new List();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Scaffold(
            resizeToAvoidBottomPadding: false,
            bottomNavigationBar: FlatButton(
                color: Color.fromRGBO(255, 255, 255, 220),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CadastroPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Não tem uma conta?",
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " Cadastre-se",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    )
                  ],
                )),
            backgroundColor: Colors.blue,
            body: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
              if (model.isLodding)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Center(
                  child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, left: 0, top: 30),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.equalizer,size: 120,color: Colors.white,),
                          Text(
                            "Employ",
                            style: TextStyle(
                                fontFamily: 'UbuntuM',
                                fontSize: 40,
                                color: Colors.white),
                          ),
                          Text(
                            "Consiga um emprego de maneira rápida e fácil",
                            style: TextStyle(
                                fontFamily: 'UbuntuM',
                                fontSize: 14,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Center(
                      heightFactor: 1.0,
                      child: Form(
                        child: Card(
                          margin: EdgeInsets.all(50),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 320,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(20.0),
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black38, blurRadius: 10.0)
                                  ]),
                              child: Column(children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        icon: Icon(Icons.person),
                                        labelText: "Login",
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: _passController,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          icon: Icon(Icons.lock_outline),
                                          labelText: "Senha"),
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
                                      colorBrightness: Brightness.light,
                                      splashColor: Colors.white,
                                      color: Colors.deepOrange,
                                      padding: EdgeInsets.all(5),
                                      onPressed: () {
                                        model.SignIn(
                                            _emailController.text,
                                            _passController.text,
                                            onSucess,
                                            onFail);
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
                                      child: Container(
                                        child: Text(
                                          "Logar",
                                          style: TextStyle(
                                              fontFamily: 'UbuntuM',
                                              color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: FlatButton(
                                      padding: EdgeInsets.all(5.0),
                                      onPressed: () {},
                                      child: Text("Esqueceu sua senha?",style: TextStyle(fontFamily: "UbuntuM")),
                                    )
                                ),
                              ])),
                        ),
                      ),
                    ),
                    Text(
                      "Para fazer o cadastro é necessário o upload do modelo,preencha o curriculo e faça o seu upload",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    FlatButton(
                      onPressed: () {
                        DownloadModel();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.file_download,
                            color: Colors.white,
                          ),
                          Text(
                            "Baixar Modelo de Curriculo",
                            style: TextStyle(
                                fontFamily: 'UbuntuM',
                                color: Colors.black38,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            })),
      ],
    );
  }

  void DownloadModel() async {
    String url_adrress =
        "https://firebasestorage.googleapis.com/v0/b/employ-86fcd.appspot.com/o/modelo_curriculum.docx?alt=media&token=35fb4d76-67f5-47ee-806d-b7f1176b9a56";
    final _localPath = await getApplicationDocumentsDirectory();
    final TaskId = await FlutterDownloader.enqueue(
      url: url_adrress,
      savedDir: _localPath.path,
      showNotification: true,
    );
  }

  void loginFailed() {
    print("Erro de login");
  }

  void onSucess() {
    AlertDialog(
      title: Text("Usuário Submetido com sucesso"),
      content: Text("Verifique sua senha e login e tente novamente"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void onFail() {
    AlertDialog(
      title: Text("Erro na submissão do Usuário"),
      content: Text("Verifique sua senha e login e tente novamente"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Sign Out");
  }
}
