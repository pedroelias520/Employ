import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_page.dart';
import 'models/user_model.dart';

class SucessScreen extends StatefulWidget {
  @override
  _SucessScreenState createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 37, 65, 1),
      body:
          ScopedModelDescendant<UserModel>(builder: (context, builder, model) {
        if (model.isLodding) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          heightFactor: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.bookmark_border,color: Color.fromRGBO(255, 182, 0, 1),size: 100,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Bora trabalhar !",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "UbuntuM", fontSize: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Seu cadastro foi realizado com sucesso na plataforma!",
                  style: TextStyle(color: Colors.white, fontFamily: "UbuntuM"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: AutoSizeText(
                  "Após a aceitamento do seu cadastro você já pode mandar solicitações para outras pessoas e até conseguir o seu emprego",
                  style: TextStyle(color: Color.fromRGBO(110,103,176, 1),fontSize: 15,fontFamily: "UbuntuM"),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Colors.orange[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                  child: Text("Continuar",style: TextStyle(fontFamily: "UbuntuM",color: Colors.white),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  
                  ),
              )
            ],
          ),
        );
      }),
    );
  }
}
