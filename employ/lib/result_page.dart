import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _CardNotification() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        double lenght = snapshot.data.documents.length.truncateToDouble() * 200;
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
            return new PageView(
              children: <Widget>[SizedBox()],
            );
        }
      },
    );
  }
}
