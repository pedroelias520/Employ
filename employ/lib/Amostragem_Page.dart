import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:employ/result_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'login_page.dart';
import 'models/select_page.dart';
import 'models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cadastro_page.dart';
import 'contact_helper.dart';
import 'home_page.dart';

enum OrderOptions { orderaz, orderza }

class AmostragemPage extends StatefulWidget {
  @override
  _AmostragemPageState createState() => _AmostragemPageState();
}

class _AmostragemPageState extends State<AmostragemPage> {
  ContactHelper helper = ContactHelper();
  //final Contact contact;
  int _page = 0;
  double font_size = 13.0;
  PageController _pageController;
  List<Contact> contacts = List();
  List<Contact> contacts2 = List();
  FirebaseUser firebaseUser;

  List<UserModel> items;
  StreamBuilder<QuerySnapshot> users;
  UserModel user_model = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(40, 37, 65, 1),
        appBar: AppBar(
          leading: FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )
                ],
              )),
          title: Text(
            "EMPLOY",
            style: TextStyle(fontFamily: "UbuntuM"),
          ),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOptions.orderza,
                )
              ],
            )
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange
            ),
          ),
        ),
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
        stream: Firestore.instance.collection('Users').where('tipo',isEqualTo: 'Empregado').snapshots(),
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
                      print("="*150);
                      print("Você Clicou lá : ${document['name']}");
                      print("="*150);
                      Navigator.push(context,MaterialPageRoute(builder: (context) => SelectPage(
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

  Widget _contactCard(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Color.fromRGBO(62, 57, 98, 1),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 120.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts.isEmpty
                            ? AssetImage("lib/images/person.png")
                            : null,
                        repeat: ImageRepeat.noRepeat)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      textDirection: TextDirection.ltr,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(right: 7),
                                  child: Icon(
                                    Icons.person,
                                    color: Color.fromRGBO(124, 124, 188, 1),
                                    size: 17,
                                  )),
                              Text("Pedro Elias ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: "UbuntuB",
                                      fontSize: 27,
                                      fontStyle: FontStyle.normal))
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(right: 7),
                                  child: Icon(
                                    Icons.email,
                                    color: Color.fromRGBO(124, 124, 188, 1),
                                    size: 15,
                                  )),
                              Text(
                                "emaailqualquer.com",
                                style: TextStyle(
                                    color: Color.fromRGBO(124, 124, 188, 1),
                                    fontFamily: 'UbuntuM',
                                    fontSize: font_size),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Container(
                            color: Colors.blue,
                            height: 2.0,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(right: 7),
                                  child: Icon(
                                    Icons.build,
                                    color: Color.fromRGBO(124, 124, 188, 1),
                                    size: 15,
                                  )),
                              Text("Analista de Sistemas",
                                  style: TextStyle(
                                      color: Color.fromRGBO(124, 124, 188, 1),
                                      fontFamily: 'UbuntuM',
                                      fontSize: font_size))
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 80),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color.fromRGBO(124, 124, 188, 1),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _CardPessoa(BuildContext context) {
    final content = StreamBuilder(
        stream: Firestore.instance.collection('persons').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return const Text('Carregando',
                style: TextStyle(fontFamily: 'UbuntuB'));
          else
            const Text("Sem dados apresentaveis em banco");

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot doc = snapshot.data.documents[index];

                return GestureDetector(
                  child: Padding(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.person_pin),
                        Column(
                          children: <Widget>[
                            Text(
                              doc.data['nome'],
                              style: TextStyle(fontFamily: 'UbuntuB'),
                            ),
                            Text(
                              doc.data['idade'],
                              style: TextStyle(fontFamily: 'UbuntuB'),
                            ),
                            Text(
                              doc.data['profissao'],
                              style: TextStyle(fontFamily: 'UbuntuB'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
