class Studente {
  late String nome;
  late String cognome;
  late String mail;
  late String? password;
  late String? userCode;
  late String sezione;

  factory Studente() {
    return Studente.allParams('', '', '', '', '', '');
  }

  Studente.allParams(this.nome, this.cognome, this.mail, this.password,
      this.userCode, this.sezione);

  Studente.fromJson(Map<String, dynamic> data) {
    nome = data['nome'];
    cognome = data['cognome'];
    mail = data['mail'];
    password = data['password'];
    userCode = data['userCode'];
    sezione = data['sezione'];
  }

  static List<Studente> getListaStudenti(dynamic data) {
    List<Studente> studenti = [];
    for(var item in data){
      studenti.add(Studente.fromJson(item));
    }
    return studenti;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cognome': cognome,
      'mail': mail,
      'password': password,
      'userCode': userCode,
      'sezione': sezione
    };
  }
}
