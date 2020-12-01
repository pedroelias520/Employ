import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employ/SucessScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import '../home_page.dart';

final CollectionReference myCollection = Firestore.instance.collection('Users');

class UserModel extends Model {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance; //sigleton pra não precisa instancia toda vez
  FirebaseUser firebaseUser; //definicao de usuario
  AuthResult firebase_user;
  Firestore database;
  String name_user;
  String email_user;
  String PhotoUrl_user;
  Map<String, dynamic> userData = Map();
  bool isLodding = false;
  BuildContext get context => null;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

  }

  void SignUp({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onsucess,
    @required VoidCallback onFail,
  }) {
    isLodding = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      await _saveUserData(
          userData, user); //Salva os demais dados do usuário no  banco
      print("Usuário cadastrado");
      onsucess();
      isLodding = false;
      notifyListeners();
    }).catchError((e) {
      print("-" * 150);
      print("Erro de chamada : " + e.toString());
      print("-" * 150);
      onFail();

      isLodding = false;
      notifyListeners();
    });
  }

  void SignIn(@required String email, @required String pass, VoidCallback onSucess, VoidCallback onFail) async {
    isLodding = true;
    notifyListeners(); //atualiza a pagina
    try {
      onSucess();
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: pass)).user;
      print(user);
      DocumentSnapshot docUser = await Firestore.instance.collection("Users").document(user.uid).get();
      firebaseUser = user;
      userData = docUser.data;
      print("-" * 150);
      print(docUser.data);
      print("-" * 150);      
      isLodding = false;
      notifyListeners();
    } catch (e) {
      onFail();     
      print("-" * 150);
      print("Error : ${e.toString()}");
      print("Error Number: ${e.hashCode}");
      print("Error Type: ${e.runtimeType}");
      print("-" * 150);
      isLodding = false;
      notifyListeners();
    }
   /* _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) async {
      firebaseUser = user as FirebaseUser;
      await _loadCurrentUser();

      onSucess();
      isLodding = false;
      notifyListeners(); //atualiza a pagina
    }).catchError((e) {
      onFail();
      print("-" * 150);
      print("Error : " + e.toString());
      print("-" * 150);
      isLodding = false;
      notifyListeners(); //atualiza a pagina
    }); */
  }  

  List<UserModel> getUserList() {
    List items;
    Firestore.instance
        .collection("Users")
        .document(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
      print(ds);
    });
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<String> GenerateId() async {
    String id_number = "";
    var gerador = Random();
    for(int x=0;x<4;x++){
      for (int i=0;i<4;i++){
        var number = gerador.nextInt(9);
        id_number = id_number.toString() + number.toString();
      }
      if(x<3){
        id_number = id_number + " ";
      }
    }
    List List_of_ids = (await Firestore.instance.collection("Users").where("id", arrayContains: id_number).getDocuments()).documents;
    if(List_of_ids.isEmpty){
      return id_number;
    }
    else{
      GenerateId();
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoUrl != null);

      name_user = user.displayName;
      email_user = user.email;
      PhotoUrl_user = user.photoUrl;

      if (name_user.contains(" ")) {
        name_user = name_user.substring(0, name_user.indexOf(" "));
      }
      Map<String, dynamic> user_map = Map();
      user_map = {
        'name': name_user,
        'email': email_user,
        'photo': PhotoUrl_user
      };
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return 'signInWithGoogle succeeded: ${user_map}';
    } catch (e) {
      print("-" * 150);
      print("Loggin Failed : " + e.toString());
      print("-" * 150);
    }
  }

  Future<Null> _loadCurrentUser() async {
    try{
      if (firebaseUser == null) {
        firebaseUser = await _auth.currentUser();
        print("Usuário Autenticado: ${firebaseUser.email} | ${firebaseUser.displayName} | ${firebaseUser.uid} | ${firebaseUser.photoUrl}");
      }
        if (firebaseUser != null) {
          if (userData["name"] == null) {
            DocumentSnapshot docUser = await Firestore.instance.collection("Users").document("admin").get();
            userData = docUser.data;
            print("-"*150);
            print("Usuário: ${docUser.data}");
            print("-"*150);
          }
        }
        notifyListeners();
    }catch(e){
      print("="*150);
      print("Erro ao carregar o usuário atual: ${e.toString()}");
      print("="*150);
    }

  }

  Future<Null> _saveUserData(@required Map<String, dynamic> userData,
      @required AuthResult user) async {
    this.userData = userData;
    Firestore.instance
        .collection("Users")
        .document(user.user.uid)
        .setData(userData);
  }

  Future<dynamic> saveImage(@required dynamic image) async {
    try {
      String fileName = 'images/${DateTime.now()}.png';
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("-" * 150);
      print("Erro na mandagem de imagem : " + e.toString());
      print("-" * 150);
    }
  }
  Future<dynamic> saveCurriculo(@required dynamic curriculo) async {
    try {
      String fileName = 'curriculos/${DateTime.now()}.pdf';
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(curriculo);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("-" * 150);
      print("Erro na mandagem de curriculo : " + e.toString());
      print("-" * 150);
    }
  }
}
