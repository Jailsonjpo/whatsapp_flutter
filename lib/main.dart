import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Home.dart';
import 'RouteGenerator.dart';
import 'Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

final ThemeData temaIOS = ThemeData(
    primaryColor: Colors.grey[200],
    accentColor: Color(0xff25d366)
);

final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff075e54),
    accentColor: Color(0xff25d366)
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
        home: Login(),
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,

/*As rotas podem ser chamadas assim também ou como feito acima dentro de um arquivo RouteGenerator*/
    /*routes: {
          "/login" : (context) => Login(),
          "/home" : (context) => Home(),
    },*/

  ));

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Firestore.instance
      .collection("usuarios")
      .document("001")
      .setData({"nome": "Jailson"});
*/

  /*Firebase.initializeApp();
  Firestore.instance
  .collection("suarios")
  .document("001")
  .setData("nome": "Jailson")*/
}
