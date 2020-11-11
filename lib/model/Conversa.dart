class Conversa {

  String _nome;
  String _mensagem;
  String _caminhoFoto;


  Conversa(this._nome, this._mensagem, this._caminhoFoto);

  String get caminhoFoto => _caminhoFoto;

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}