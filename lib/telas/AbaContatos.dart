import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/model/Conversa.dart';

class AbaContatos extends StatefulWidget {
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  List<Conversa> listaConversas = [

    Conversa("Ana Clara", "Olá tudo Bem?", "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-80e64.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=99f5c074-9506-46c2-b0b9-418531611681" ),
    Conversa("Pedro Silva", "Me manda o nome daquela Série", "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-80e64.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=0d64dc8e-0f80-4f44-9435-1ea332d2ea72" ),
    Conversa("Maize", "Saudades do que a gente ainda n viveu", "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-80e64.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=5ad1ccf4-5416-434a-a7f0-d7c5b03e31b6" ),
    Conversa("Jose Lito", "Você tem uma canon t6i?", "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-80e64.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=3706a4c7-be03-4a5e-95fa-23560fae581b" ),
    Conversa("Jamilton Damasceno", "Terminou os cursos?", "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-80e64.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=abb2828c-3f79-4d59-a2eb-e9df14e68d02" ),
    Conversa("Carla", "Oi Fake?", "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-80e64.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=99f5c074-9506-46c2-b0b9-418531611681" ),
  ];

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: listaConversas.length,
        itemBuilder: (context, indice){
          Conversa conversa = listaConversas[indice];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversa.caminhoFoto),
            ),
            title: Text(
              conversa.nome,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          );
        }
    );
  }
}
