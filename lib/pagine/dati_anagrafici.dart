import 'package:flutter/material.dart';
import 'package:progetto_scuola/classi/Docente.dart';
import 'package:progetto_scuola/classi/Studente.dart';
import 'package:progetto_scuola/http_service/service_dati.dart';

class DatiAnagrafici extends StatefulWidget {
  static bool isChange = false;

  const DatiAnagrafici({super.key});

  @override
  State<DatiAnagrafici> createState() => _DatiAnagraficiState();
}

class _DatiAnagraficiState extends State<DatiAnagrafici> {
  late TextEditingController nomeController;
  late TextEditingController cognomeController;
  late TextEditingController mailController;
  late TextEditingController passwordController;
  late TextEditingController userCodeController;
  late TextEditingController sezioneController;

  late TextEditingController codiceFiscaleController;
  late TextEditingController sezioniController;
  late TextEditingController materieController;

  @override
  void initState() {
    passwordController = TextEditingController(text: '****************');
    if (ServiceDati.getUtenza() == 'studente') {
      nomeController =
          TextEditingController(text: ServiceDati.getStudente().nome);
      cognomeController =
          TextEditingController(text: ServiceDati.getStudente().cognome);
      mailController =
          TextEditingController(text: ServiceDati.getStudente().mail);
      userCodeController =
          TextEditingController(text: ServiceDati.getStudente().userCode);
      sezioneController =
          TextEditingController(text: ServiceDati.getStudente().sezione);
    } else {
      nomeController =
          TextEditingController(text: ServiceDati.getDocente().nome);
      cognomeController =
          TextEditingController(text: ServiceDati.getDocente().cognome);
      mailController =
          TextEditingController(text: ServiceDati.getDocente().mail);
      codiceFiscaleController =
          TextEditingController(text: ServiceDati.getDocente().codiceFiscale);
      sezioniController =
          TextEditingController(text: ServiceDati.getDocente().sezioni);
      materieController =
          TextEditingController(text: ServiceDati.getDocente().materie);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(width: 15),
              Text('${ServiceDati.getUtenza()}:',
                  style: const TextStyle(fontSize: 25)),
            ],
          ),
          _getTextField(nomeController, 'Nome'),
          _getTextField(cognomeController, 'Cognome'),
          _getTextField(mailController, 'Mail'),
          _getTextField(passwordController, 'Password'),
          ServiceDati.getUtenza() == 'studente'
              ? _getTextField(userCodeController, 'User code')
              : _getTextField(codiceFiscaleController, 'Codice fiscale'),
          ServiceDati.getUtenza() == 'studente'
              ? _getTextField(sezioneController, 'Sezione')
              : _getTextField(sezioniController, 'Sezioni'),
          ServiceDati.getUtenza() == 'docente'
              ? _getTextField(materieController, 'Materie')
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _getTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
                enabled: (label.toLowerCase()=='mail' || label.toLowerCase()=='password') ? true : false,
                onChanged: (_) {
                    if(ServiceDati.getUtenza()=='studente'){
                      setState(() {
                        ServiceDati.setStudente(getStudente());
                      });
                    }else{
                      setState(() {
                        ServiceDati.setDocente(getDocente());
                      });
                    }
                },
                controller: controller,
                obscureText: label.toLowerCase() == 'password',
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFDBE2E7),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                ),
                style: const TextStyle(color: Color(0xFF2B343A))),
          ),
        ],
      ),
    );
  }

  Studente getStudente() {
    return Studente.allParams(
        nomeController.text,
        cognomeController.text,
        mailController.text,
        passwordController.text,
        userCodeController.text,
        sezioneController.text);
  }

  Docente getDocente() {
    return Docente.allParams(
        nomeController.text,
        cognomeController.text,
        mailController.text,
        passwordController.text,
        codiceFiscaleController.text,
        materieController.text,
        sezioniController.text);
  }
}
