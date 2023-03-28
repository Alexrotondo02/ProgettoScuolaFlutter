class Classe {
  late String sezione;
  late String cordinatore;
  late String aula;

  Classe(this.sezione, this.cordinatore, this.aula);

  Classe.fromJson(Map<String, dynamic> data) {
    sezione = data['sezione'];
    cordinatore = data['cordinatore'];
    aula = data['aula'];
  }

  static List<Classe> getListClassi(dynamic response) {
    List<Classe> classi = [];
    for (var item in response) {
      classi.add(Classe.fromJson(item));
    }
    classi.sort((classe_1, classe_2) {
      int numberSezione_1 = int.parse(classe_1.sezione.substring(0, 1));
      int numberSezione_2 = int.parse(classe_2.sezione.substring(0, 1));
      return numberSezione_1.compareTo(numberSezione_2);
    });
    return classi;
  }

  Map<String, dynamic> toJson() {
    return { 'sezione': sezione, 'cordinatore': cordinatore, 'aula': aula };
  }
}