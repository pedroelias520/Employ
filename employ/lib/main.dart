import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Amostragem_Page.dart';
import 'cadastro_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'models/select_page.dart';
import 'models/user_model.dart';


void main() {
  //Firestore.instance.collection("teste").document('teste de msg').setData({"teste":"teste de msg"});
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(//Cria classe dependente do model especificado
      model: UserModel(),//Tudo que ocorre no model inlui nas demais telas
      child: MaterialApp(
        title: "Flutter App is coming",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 4, 125, 141)
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}


