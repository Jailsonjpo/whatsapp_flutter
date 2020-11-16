import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/model/Mensagem.dart';
import 'package:whatsapp_flutter/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  String _idUsuarioLogado;
  String _idUsuarioDestinatario;
  List<String> listaMensagens = [
    "Olá tudo bem?",
    "Você viu o Jogo ontem?",
    "vi!, o Flamengo está com uma Zaga muito Ruim",
    "Vdd Léo Pereba e GH não podem jogar no mesmo time",
    "Poise pow, ainda tem o Renê",
    "E o Michael e o Vitinho (mortinho)",
    "Bora ver o que dá com o Ceni",
    "Fé!",
  ];

  TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;

    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    }
  }

  _salvarMensagem( String idRemetente, String idDestinatario, Mensagem msg) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    //Limpa o campo Texto para digitar uma nova msg
    _controllerMensagem.clear();

    /*
    * mensaagens
    *   jailson
    *     amigo
    *       identificadorFirebase
    *         <mensagem>
    * */
  }

  _enviarFoto() {}

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMensagem,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma mensagem...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _enviarFoto,
                    )),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075e54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
          itemCount: listaMensagens.length,
          itemBuilder: (context, indice) {
            //  double larguraContainer = MediaQuery.of(context).size.width * 0.8;

            //Define cores e alinhamentos
            Alignment alinhamento = Alignment.centerRight;
            Color cor = Color(0xffd2ffa5);

            if (indice % 2 == 0) {
              alinhamento = Alignment.centerLeft;
              cor = Colors.white;
            }

            return Align(
              alignment: alinhamento,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  //  width: larguraContainer,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: cor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text(
                    // larguraContainer.toString() + "++" + listaMensagens[indice],
                    listaMensagens[indice],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }),
    );

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.contato.urlImagem != null
                      ? NetworkImage(widget.contato.urlImagem)
                      : null),
              Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(widget.contato.nome)),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
          //decoration
          child: SafeArea(
              child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                listView,
                caixaMensagem,
              ],
            ),
          )),
        ));
  }
}
