class Docente {
  late String nome;
  late String cognome;
  late String mail;
  late String password;
  late String codiceFiscale;
  late String sezioni;
  late String materie;

  factory Docente() {
    return Docente.allParams('', '', '', '', '', '', '');
  }

  Docente.allParams(this.nome, this.cognome, this.mail, this.password,
      this.codiceFiscale, this.materie, this.sezioni);

  static List<Docente> getListDocenti(dynamic response) {
    List<Docente> docenti = [];
    for(var item in response){
      docenti.add(Docente.fromJson(item));
    }
    return docenti;
  }

  Docente.fromJson(Map<String, dynamic> data) {
    nome = data['nome'];
    cognome = data['cognome'];
    mail = data['mail'];
    password = data['password'];
    codiceFiscale = data['codiceFiscale'];
    materie = data['materie'].join(', ').toLowerCase();
    sezioni = data['sezioni'].join(', ').toLowerCase();
  }

  Map<String, dynamic> toJson() {
    List<String> newSezioni = sezioni.split(', ');
    List<String> newMaterie = materie.toUpperCase().split(', ');
    return {
      'nome': nome,
      'cognome': cognome,
      'mail': mail,
      'password': password,
      'codiceFiscale': codiceFiscale,
      'materie': newMaterie,
      'sezioni': newSezioni
    };
  }
}
