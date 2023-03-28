import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progetto_scuola/classi/Docente.dart';
import 'package:progetto_scuola/http_service/httpservice.dart';

// ignore: must_be_immutable
class ElencoDocenti extends StatefulWidget {
  HttpService httpService = HttpService();
  ElencoDocenti({super.key});

  @override
  State<ElencoDocenti> createState() => _ElencoDocentiState();
}

class _ElencoDocentiState extends State<ElencoDocenti> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: _getListaDocenti(),
          builder: (context, snapshot) {
            List<Docente> list = snapshot.data ?? [];
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: const Icon(FontAwesomeIcons.personChalkboard,
                        color: Colors.purple),
                    title: Text('${list[index].nome} ${list[index].cognome}'),
                    subtitle: Text(
                        'Insegna => ${list[index].materie}.\nSezioni dove insegna => ${list[index].sezioni}'),
                  );
                });
          }),
    );
  }

  Future<List<Docente>> _getListaDocenti() async {
    List<Docente> docenti = await widget.httpService.getListaDocenti();
    return docenti;
  }
}
