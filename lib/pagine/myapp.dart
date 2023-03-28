import 'package:flutter/material.dart';
import 'package:progetto_scuola/http_service/service_dati.dart';
import 'package:progetto_scuola/pagine/elencoclassi.dart';
import 'package:progetto_scuola/pagine/elencodocenti.dart';
import 'package:progetto_scuola/pagine/registrodocenti.dart';
import 'package:progetto_scuola/pagine/registrofamiglie.dart';
import 'package:progetto_scuola/widget/drawer.dart';

import '../classi/Docente.dart';
import '../classi/Studente.dart';
import '../http_service/httpservice.dart';
import 'homepage.dart';

Map<String, Widget> _getBody = {
  'Home': const HomePage(),
  'Elenco-classi': ElencoClassi(),
  'Elenco-docenti': ElencoDocenti(),
  'Registro-famiglie': RegistroFamiglia(),
  'Registro-docenti': RegistroDocente()
};

class MyApp extends StatefulWidget {
  final HttpService httpService = HttpService();

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late String _setBody;

  @override
  void initState() {
    setState(() {
      _setBody = 'Home';
    });
    _init();
    super.initState();
  }

  Future<void> _init() async {
    final Map<String, dynamic> jsonToken =
        await widget.httpService.getJsonToken();
    final String token = jsonToken['token'];
    final String utenza = jsonToken['utenza'];

    if (token.isEmpty) {
      return;
    }

    setState(() {
      ServiceDati.setUtenza(utenza);
    });

    if (ServiceDati.getUtenza() == 'studente') {
      final Map<String, dynamic> data =
          await widget.httpService.getStudente(token);

      final int status = data['status'];
      Studente? studente;

      if (status == 200) {
        studente = data['studente'];
        setState(() {
          ServiceDati.setStudente(studente!);
        });
      } else if(status != 403) {
        final message = data['message'];
        _showSnackBar(message);
      } else {
        widget.httpService.logout();
      }
    } else {
      final Map<String, dynamic> data =
          await widget.httpService.getDocente(token);

      final int status = data['status'];
      Docente? docente;

      if (status == 200) {
        docente = data['docente'];
        setState(() {
          ServiceDati.setDocente(docente!);
        });
      } else if(status != 403) {
        final message = data['message'];
        _showSnackBar(message);
      } else {
        widget.httpService.logout();
      }
    }
  }

  void _showSnackBar(String message) {
    SnackBar snackBar =
        SnackBar(content: Text(message), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      ServiceDati.setLocale(Localizations.localeOf(context));
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Scuola xx')),
      drawer: _drawer(),
      body: _getBody[_setBody] ?? Container(),
    );
  }

  Widget _drawer() {
    if (ServiceDati.getUtenza() == 'studente') {
      return MyDrawer(
          onSelected: (value) {
        setState(() {
          _setBody = value;
        });
      });
    } else if (ServiceDati.getUtenza() == 'docente') {
      return MyDrawer(onSelected: (value) {
        setState(() {
          _setBody = value;
        });
      });
    } else {
      return MyDrawer(onSelected: (value) {
        setState(() {
          _setBody = 'Home';
        });
      });
    }
  }
}
