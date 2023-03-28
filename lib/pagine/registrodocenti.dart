import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progetto_scuola/http_service/httpservice.dart';
import 'package:progetto_scuola/pagine/dati_anagrafici.dart';
import 'package:progetto_scuola/pagine/registro_docente/lista_studenti.dart';
import 'package:progetto_scuola/widget/bottom_navigatation_bar.dart';

import '../http_service/service_dati.dart';

Map<String, Widget> _getBody = {
  'Dati-anagrafici': const DatiAnagrafici(),
  'Lista-studenti': ListaStudentiDocente()
};

class RegistroDocente extends StatefulWidget {
  final HttpService httpService = HttpService();

  RegistroDocente({super.key});

  @override
  State<RegistroDocente> createState() => _RegistroDocenteState();
}

class _RegistroDocenteState extends State<RegistroDocente> {
  late String _setBody;

  @override
  void initState() {
    setState(() {
      _setBody = 'Dati-anagrafici';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _getFloatingActionButton(),
        body: _getBody[_setBody] ?? Container(),
        bottomNavigationBar: _getBottomNavigationBar());
  }

  FloatingActionButton? _getFloatingActionButton() {
    if (_setBody == 'Dati-anagrafici') {
      return FloatingActionButton(
          onPressed: () {
            _getMessageUpdate();
          },
          child: const Icon(FontAwesomeIcons.floppyDisk));
    } 
    return null;
  }

  Widget _getBottomNavigationBar() {
    return MyBottomNavigationBar(onSelected: (value) {
      setState(() {
        _setBody = value;
      });
    });
  }

  Future<void> _getMessageUpdate() async {
    final Map<String, dynamic> value =
        await widget.httpService.updateDocente(ServiceDati.getDocente());
    _showSnackBar(value);
  }

  void _showSnackBar(Map<String, dynamic> value) {
    SnackBar snackBar = const SnackBar(content: Text(''));
    final status = value['status'];
    final message = value['message'];
    if (status == 201 || status == 200) {
      snackBar =
          SnackBar(content: Text(message), backgroundColor: Colors.green);
    } else {
      snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red);
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
