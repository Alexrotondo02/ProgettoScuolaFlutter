import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progetto_scuola/http_service/httpservice.dart';

import '../classi/Classe.dart';

// ignore: must_be_immutable
class ElencoClassi extends StatefulWidget {
  HttpService httpService = HttpService();
  ElencoClassi({super.key});

  @override
  State<ElencoClassi> createState() => _ElencoClassiState();
}

class _ElencoClassiState extends State<ElencoClassi> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _getListaClassi(),
        builder: (context, snapshot) {
          List<Classe> list = snapshot.data ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              return ListTile(
                leading: const Icon(FontAwesomeIcons.school, color: Colors.purple),
                title: Text('${list[index].aula} - ${list[index].sezione}'),
                subtitle: Text('Il cordinatore è: ${list[index].cordinatore}'),
                onTap: () {},
              );
            },
          );
        }
      ),
    );
  }

  Future<List<Classe>> _getListaClassi() async {
    List<Classe> classi = await widget.httpService.getListaClassi();
    return classi;
  }
}