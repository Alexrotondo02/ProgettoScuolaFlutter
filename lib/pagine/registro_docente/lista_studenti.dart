import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progetto_scuola/classi/Classe.dart';
import 'package:progetto_scuola/http_service/httpservice.dart';

import '../../classi/Studente.dart';

// ignore: must_be_immutable
class ListaStudentiDocente extends StatefulWidget {
  HttpService httpService = HttpService();

  ListaStudentiDocente({super.key});

  @override
  State<ListaStudentiDocente> createState() => _ListaStudentiDocenteState();
}

class _ListaStudentiDocenteState extends State<ListaStudentiDocente> {
  String scelta = 'Scegliere una sezione';
  late List<Studente> studenti = [];
  bool showTabel = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Colors.lightBlue, blurRadius: 5)
                  ]),
              child: FutureBuilder(
                future: _getListaClassi(),
                builder: (context, snapshot) {
                  List<Classe> classi = snapshot.data ?? [];
                  return DropdownButton(
                    onChanged: (value) {
                      _initListStudenti(value!);
                    },
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(scelta,
                          style: const TextStyle(fontSize: 20, color: Colors.black)),
                    ),
                    items: classi.map((classe) {
                      return DropdownMenuItem(
                          value: classe.sezione,
                          child: Center(child: Text(classe.sezione)));
                    }).toList(),
                    icon: const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_circle_down_sharp)),
                    iconEnabledColor: Colors.black,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    dropdownColor: Colors.purple[700],
                    underline: Container(),
                    isExpanded: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            showTabel
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      border: TableBorder(
                          bottom: BorderSide(
                              width: 1,
                              color: Colors.purple.shade700,
                              style: BorderStyle.solid)),
                      columns: const [
                        DataColumn(
                            label: Text('Studente',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                        DataColumn(
                            label: Text('Presenza',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)))
                      ],
                      rows: List<DataRow>.generate(
                          studenti.length,
                          (index) => DataRow(cells: [
                                DataCell(
                                    Text(
                                        '${studenti[index].nome} ${studenti[index].cognome}'),
                                    onTap: () => _showStudente(studenti[index])),
                                DataCell(Checkbox(
                                    value: false, onChanged: (bool? value) {}))
                              ])),
                    ),
                  )
                : const SizedBox(),
          ],
        ));
  }

  void _showStudente(Studente studente) {
    CupertinoAlertDialog showStudent = CupertinoAlertDialog(
      title: Text('${studente.nome} ${studente.cognome}'),
      actions: [
        CupertinoTextField(
          placeholder: 'Inserisci voto',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        const SizedBox(height: 10),
        const CupertinoTextField(
          placeholder: 'Inserisci note',
          keyboardType: TextInputType.emailAddress,
          minLines: 3,
          maxLines: null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              minSize: 15,
              child: const Text('Indietro'),
            ),
            CupertinoButton(
                onPressed: () {},
                minSize: 15,
                child: const Text('Salva'),
            )
          ],
        )
      ],
    );
    showCupertinoDialog(
        context: context,
        builder: (_) => showStudent
    );
  }

  Future<void> _initListStudenti(String sezione) async {
    List<Studente> newListStudenti =
        await widget.httpService.getStudentiBySezione(sezione);
    setState(() {
      studenti = newListStudenti;
      showTabel = true;
      scelta = sezione;
    });
  }

  Future<List<Classe>> _getListaClassi() async {
    List<Classe> classi = await widget.httpService.getClassiByDocente();
    return classi;
  }
}
