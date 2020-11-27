import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_flutter/model/Conversa.dart';
import 'dart:io';
import 'model/Mensagem.dart';
import 'model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _idUsuarioDestinatario;
  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController _controllerMensagem = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.data = Timestamp.now().toString();
      mensagem.tipo = "texto";

      //salvar msg para remetente
      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
      //salvar msg para o destinatario
      _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

      //salvar conversa
      _salvarConversa(mensagem);
    }
  }

  _salvarConversa(Mensagem msg){

    //salvar conversa para remetente
    Conversa cRemetente = Conversa();
    cRemetente.idRemetente = _idUsuarioLogado;
    cRemetente.idDestinatario = _idUsuarioDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.urlImagem;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.salvar();

    //salvar conversa para o Destinatario
    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = _idUsuarioDestinatario;
    cDestinatario.idDestinatario = _idUsuarioLogado;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cRemetente.salvar();

  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    //Limpa texto
    _controllerMensagem.clear();

    /*

    + mensagens
      + jamiltondamasceno
        + joserenato
          + identicadorFirebase
            <Mensagem>

    * */
  }

  _enviarFoto() async{

    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);

    _subindoImagem = true;
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("mensagens")
        .child(_idUsuarioLogado)
        .child(nomeImagem + ".jpg");

    UploadTask task = arquivo.putFile(imagemSelecionada);

// Optional
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _subindoImagem = true;
      });

      print('Snapshot state: ${snapshot.state}'); // paused, running, complete
      print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
    }, onError: (Object e) {
      print(e); // FirebaseException
    });

// Optional
    task.then((TaskSnapshot snapshot) {
      _subindoImagem = false;
      print('Upload complete!');
      _recuperarUrlImagem(snapshot);
    }).catchError((Object e) {
      print(e); // FirebaseException
    });

  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();
    mensagem.idUsuario = _idUsuarioLogado;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.data = Timestamp.now().toString();
    mensagem.tipo = "imagem";

    //salvar msg para remetente
    _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    //salvar msg para o destinatario
    _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

  }

    _recuperarDadosUsuario(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;

    _adicionarListenerMensagens();

  }

  Stream<QuerySnapshot>_adicionarListenerMensagens(){

    final stream = db.collection("mensagens")
        .doc(_idUsuarioLogado)
        .collection(_idUsuarioDestinatario)
        .orderBy("data", descending: false)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
      Timer(Duration(seconds: 1), (){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
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
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon:
                    _subindoImagem
                        ? CircularProgressIndicator()
                        : IconButton(icon: Icon(Icons.camera_alt), onPressed: _enviarFoto)),
              ),
            ),
          ),
          Platform.isIOS
              ? CupertinoButton(
              child: Text("Enviar"),
              onPressed: _enviarMensagem,
            )
              :   FloatingActionButton(
                    backgroundColor: Color(0xff075E54),
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

      var stream = StreamBuilder(
        stream: _controller.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
           switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: <Widget>[
                    Text("Carregando mensagens"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot querySnapshot = snapshot.data;

              if (snapshot.hasError) {
                return Text("Erro ao carregar os dados!");
              } else {
                return Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, indice) {
                        //recupera mensagem
                        List<DocumentSnapshot> mensagens = querySnapshot.docs.toList();
                        DocumentSnapshot item = mensagens[indice];

                        double larguraContainer =
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.8;

                        //Define cores e alinhamentos
                        Alignment alinhamento = Alignment.centerRight;
                        Color cor = Color(0xffd2ffa5);
                        if (_idUsuarioLogado != item["idUsuario"]) {
                          alinhamento = Alignment.centerLeft;
                          cor = Colors.white;
                        }

                        return Align(
                          alignment: alinhamento,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Container(
                              width: larguraContainer,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: cor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                              child:
                              item["tipo"] == "texto"
                                ?Text(item["mensagem"], style: TextStyle(fontSize: 18),)
                                  : Image.network(item["urlImagem"]),
                            ),
                          ),
                        );
                      }),
                );
              }
              break;
          }

        },
      );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contato.urlImagem != null
                    ? NetworkImage(widget.contato.urlImagem)
                    : null),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contato.nome),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  stream,
                  caixaMensagem,
                ],
              ),
            )),
      ),
    );
  }
}
