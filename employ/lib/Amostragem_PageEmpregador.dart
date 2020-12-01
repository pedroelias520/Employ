import 'package:auto_size_text/auto_size_text.dart';
import 'package:employ/result_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'models/select_page.dart';
import 'models/user_model.dart';

class AmostragemPageEmpregador extends StatefulWidget {
  @override
  _AmostragemPageEmpregadorState createState() =>
      _AmostragemPageEmpregadorState();
}

class _AmostragemPageEmpregadorState extends State<AmostragemPageEmpregador> {
  int _page = 0;
  double font_size = 13.0;
  PageController _pageController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,title: Text("Employ",style: TextStyle(color: Colors.white,fontFamily: 'UbuntuM'),),centerTitle: true,),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Color.fromRGBO(62, 57, 98, 1),
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.white))),
          child: BottomNavigationBar(
              currentIndex: _page,
              onTap: (p) {
                _pageController.animateToPage(p,
                    duration: Duration(microseconds: 500), curve: Curves.ease);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                      color: Color.fromRGBO(170, 170, 170, 1),
                    ),
                    title: Text(
                      "Pessoas",
                      style: TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.error_outline,
                      color: Color.fromRGBO(170, 170, 170, 1),
                    ),
                    title: Text(
                      "Sobre",
                      style: TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                    ))
              ]),
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, builder, model) {
            if (model.isLodding)
              return Center(
                  child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    "Carregando usuários",
                    style: TextStyle(fontFamily: 'UbuntuM'),
                  )
                ],
              ));
            return PageView(
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
              controller: _pageController,
              children: <Widget>[
                ListView.builder(
                  itemBuilder: (context, index) {
                    return _CardUsers(context);
                  },
                  padding: EdgeInsets.all(5.0),
                  itemCount: 1,
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return ResultPage();
                  },
                  padding: EdgeInsets.all(5.0),
                  itemCount: 2,
                ),
              ],
            );
          },
        ));
  }

  Widget _CardUsers(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //Firestore.instance.collection("Users").where("tipo",isEqualTo: 'Paciente').snapshots()
        stream: Firestore.instance
            .collection('Users')
            .where("tipo", isEqualTo: 'Empregador')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          double lenght =
              snapshot.data.documents.length.truncateToDouble() * 200;
          if (snapshot.hasError) return new Text('Error :${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Row(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            default:
              return new SizedBox(
                height: lenght,
                child: ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                  return GestureDetector(
                    child: Card(
                      margin: EdgeInsets.all(5),
                      color: Color.fromRGBO(62, 57, 98, 1),
                      child: Container(
                        height: 120,
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: new NetworkImage(
                                        document['img'].toString()),
                                    repeat: ImageRepeat.noRepeat,
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.all(10.0),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    AutoSizeText(
                                      document['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'UbuntuM',
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      document['area_experiencia'],
                                      style: TextStyle(
                                          fontFamily: 'UbuntuM',
                                          color:
                                              Color.fromRGBO(124, 124, 188, 1)),
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      document['email'],
                                      style: TextStyle(
                                        fontFamily: 'UbuntuM',
                                        color: Color.fromRGBO(124, 124, 188, 1),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      document['tipo'],
                                      style: TextStyle(
                                        fontFamily: 'UbuntuM',
                                        color: Color.fromRGBO(124, 124, 188, 1),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      print("=" * 150);
                      print("Você Clicou lá : ${document['name']}");
                      print("=" * 150);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectPage(
                                  document['id'],
                                  document['name'],
                                  document['img'],
                                  document['email'],
                                  document['tipo'],
                                  document['area_experiencia'],
                                  document['curriculo'])));
                    },
                  );
                }).toList()),
              );
          }
        });
  }
}
