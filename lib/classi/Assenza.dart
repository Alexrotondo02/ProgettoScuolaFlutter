import 'package:intl/intl.dart';

class Assenza {
  late DateTime giornataAssenza;
  late bool giustificata;

  Assenza(this.giustificata, this.giornataAssenza);

  Assenza.fromJson(Map<String, dynamic> data) {
    giornataAssenza = DateTime.parse(data['giornataAssenza']);
    giustificata = data['giustificata'];
  }

  static List<Assenza> getListAssenze(dynamic response) {
    List<Assenza> assenze = [];
    for (var item in response) {
      assenze.add(Assenza.fromJson(item));
    }
    assenze.sort((assenza_1, assenza_2) =>
        assenza_1.giornataAssenza.compareTo(assenza_2.giornataAssenza));
    return assenze;
  }

  Map<String, dynamic> toJson() {
    final date = DateFormat('yyyy-MM-dd').format(giornataAssenza);
    return {'giornataAssenza': date, 'giustificata': giustificata};
  }
}
