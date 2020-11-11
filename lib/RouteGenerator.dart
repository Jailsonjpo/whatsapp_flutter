import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/Cadastro.dart';
import 'package:whatsapp_flutter/Home.dart';
import 'package:whatsapp_flutter/Login.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name) {
      case "/" :
      return MaterialPageRoute(
          builder: (_) => Login() //utilizar o "_" ao invés de "context" continua recebendo parâmetro mas não ocupa espaço na memória.
      );

      case "/login" :
        return MaterialPageRoute(
            builder: (_) => Login() //utilizar o "_" ao invés de "context" continua recebendo parâmetro mas não ocupa espaço na memória.
        );

      case "/cadastro" :
        return MaterialPageRoute(
            builder: (_) => Cadastro() //utilizar o "_" ao invés de "context" continua recebendo parâmetro mas não ocupa espaço na memória.
        );

      case "/home" :
        return MaterialPageRoute(
            builder: (_) => Home() //utilizar o "_" ao invés de "context" continua recebendo parâmetro mas não ocupa espaço na memória.
        );

      default:
        _erroRota();

    }
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(title: Text("Tela não encontrada!"),),
            body: Center(
              child: Text("Tela não encontrada!") ,
            ),
          );
        }
    );
  }

}