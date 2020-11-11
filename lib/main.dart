import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/RouteGenerator.dart';
import 'Login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
        home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xff075e54),
      accentColor: Color(0xff25d366)
    ),
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
