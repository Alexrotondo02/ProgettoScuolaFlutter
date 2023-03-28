import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progetto_scuola/classi/Assenza.dart';
import 'package:progetto_scuola/http_service/httpservice.dart';
import 'package:progetto_scuola/http_service/service_dati.dart';

// ignore: must_be_immutable
class Assenze extends StatefulWidget {
  HttpService httpService = HttpService();

  Assenze({super.key});

  @override
  State<Assenze> createState() => _AssenzeState();
}

class _AssenzeState extends State<Assenze> {
  late List<Assenza> assenze = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    assenze = await _getListAssenze();
    setState(() {
      assenze = assenze;
      ServiceDati.setAssenze(assenze);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
      child: ListView.builder(
        itemCount: assenze.length,
        itemBuilder: (_, index) {
          return CheckboxListTile(
            enabled: !assenze[index].giustificata,
            activeColor: Colors.blue,
            title: Row(
              children: [
                assenze[index].giustificata
                    ? const Icon(FontAwesomeIcons.faceLaugh,
                        color: Colors.green)
                    : const Icon(FontAwesomeIcons.faceTired, color: Colors.red),
                const SizedBox(width: 10),
                Text(DateFormat.yMMMMEEEEd().format(assenze[index].giornataAssenza)),
              ],
            ),
            subtitle: Text(assenze[index].giustificata
                ? 'giustificata'
                : 'non è giustificata'),
            onChanged: (bool? value) {
              setState(() {
                assenze[index].giustificata = value!;
                ServiceDati.setAssenze(assenze);
              });
            },
            value: assenze[index].giustificata,
          );
        },
      ),
    );
  }

  Future<List<Assenza>> _getListAssenze() async {
    List<Assenza> assenze = await widget.httpService.getAssenze();
    return assenze;
  }
}
