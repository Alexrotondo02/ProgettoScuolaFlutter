import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progetto_scuola/http_service/httpservice.dart';
import 'package:progetto_scuola/http_service/service_dati.dart';

import '../classi/Docente.dart';
import '../classi/Studente.dart';
import '../pagine/loginpage.dart';
import '../pagine/myapp.dart';

// ignore: must_be_immutable
class MyDrawer extends StatefulWidget {
  HttpService httpService = HttpService();
  final ValueChanged<String> onSelected;

  MyDrawer({required this.onSelected, super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool showPersonaleAta = false;
  dynamic user;
  String? utenza;
  final String imageUrlDrawerHeader =
      'https://rassegnanazionale.it/wp-content/uploads/2022/09/progetti-scuola-telefono-azzurro.jpg';

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    final Map<String, dynamic> jsonToken =
        await widget.httpService.getJsonToken();
    setState(() {
      utenza = jsonToken['utenza'];
    });

    if (utenza!.isEmpty) {
      return;
    }

    if (utenza == 'studente') {
      user = ServiceDati.getStudente();
    } else {
      user = ServiceDati.getDocente();
    }
    setState(() {
      user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _getHeaderDrawer(),
          _listTileDrawer(const Icon(FontAwesomeIcons.house), 'Home'),
          _listTileDrawer(
              Icon(showPersonaleAta
                  ? FontAwesomeIcons.arrowUp
                  : FontAwesomeIcons.arrowDown),
              'Personale ata'),
          showPersonaleAta ? _showPersonaleAta() : const SizedBox(),
          (user is Studente || user == null)
              ? _listTileDrawer(
                  const Icon(FontAwesomeIcons.bookOpen), 'Registro famiglie')
              : const SizedBox(),
          (user is Docente || user == null)
              ? _listTileDrawer(
                  const Icon(FontAwesomeIcons.bookOpen), 'Registro docenti')
              : const SizedBox(),
          const Divider(),
          _loginLogout()
        ],
      ),
    );
  }

  Widget _getHeaderDrawer() {
    if (user != null) {
      return _accountsDrawerHeader(user);
    } else {
      return DrawerHeader(
          padding: EdgeInsets.zero, child: Image.network(imageUrlDrawerHeader));
    }
  }

  // header del drawer
  UserAccountsDrawerHeader _accountsDrawerHeader(dynamic loggedUser) {
    return UserAccountsDrawerHeader(
      accountName: Text(loggedUser.nome),
      accountEmail: Text(loggedUser.mail),
      currentAccountPictureSize: const Size(60, 75),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Center(child: Icon(Icons.person, size: 40)),
      ),
      otherAccountsPictures: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(utenza!.substring(0, 2).toUpperCase(),
              style: const TextStyle(fontSize: 20)),
        )
      ],
    );
  }

  // icona login o logout nel drawer
  ListTile _loginLogout() {
    if (utenza == 'studente' || utenza == 'docente') {
      return ListTile(
        leading: const Icon(FontAwesomeIcons.rightFromBracket),
        title: const Text('Logout'),
        onTap: () {
          widget.httpService.logout();
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
      );
    }
    return ListTile(
        leading: const Icon(FontAwesomeIcons.rightToBracket),
        title: const Text('Login'),
        onTap: () {
          final button_1 = TextButton(
              child: const Text('Studente', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginPage('studente')));
              });
          final button_2 = TextButton(
            child: const Text('Docente', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage('docente')));
            },
          );
          _alertDialog(
              'Selezionare lo user',
              'Questa azione ti porterà sulla schermata login scelta',
              button_1,
              button_2);
        });
  }

  Padding _showPersonaleAta() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
      child: Column(
        children: [
          _listTileDrawer(const Icon(FontAwesomeIcons.list), 'Elenco classi'),
          _listTileDrawer(const Icon(FontAwesomeIcons.list), 'Elenco docenti'),
          const Divider(),
          _listTileDrawer(
              const Icon(FontAwesomeIcons.universalAccess), 'Segreteria'),
          _listTileDrawer(
              const Icon(FontAwesomeIcons.list), 'Elenco cordinatori'),
        ],
      ),
    );
  }

  ListTile _listTileDrawer(Icon icon, String title) {
    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () => _pressedList(title.toLowerCase()));
  }

  void _pressedList(String title) {
    switch (title) {
      case 'home':
        _funzioneHome();
        break;
      case 'personale ata':
        setState(() {
          showPersonaleAta = !showPersonaleAta;
        });
        break;
      case 'elenco classi':
        _funzioneElencoClassi();
        break;
      case 'elenco docenti':
        _funzioneElencoDocenti();
        break;
      case 'registro famiglie':
        _funzioneRegistro('Registro-famiglie');
        break;
      case 'registro docenti':
        _funzioneRegistro('Registro-docenti');
        break;
    }
  }

  void _funzioneHome() {
    widget.onSelected('Home');
    Navigator.pop(context);
  }

  void _funzioneElencoClassi() {
    widget.onSelected('Elenco-classi');
    Navigator.pop(context);
  }

  void _funzioneElencoDocenti() {
    widget.onSelected('Elenco-docenti');
    Navigator.pop(context);
  }

  void _funzioneRegistro(String path) {
    if (user == null) {
      final button_1 = TextButton(
          child: const Text('cancel'),
          onPressed: () {
            Navigator.pop(context);
          });
      final button_2 = TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(FontAwesomeIcons.rightToBracket),
              SizedBox(width: 10),
              Text('Login')
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                        (path.contains('famiglie')) ? 'studente' : 'docente')));
          });
      _alertDialog(
          'Impossibile entrare in questa sezione',
          'Se si vuole accedere a questa sezione si prega di effettuare il login',
          button_1,
          button_2);
      return;
    }
    widget.onSelected(path);
    Navigator.pop(context);
  }

  //alert dialog
  void _alertDialog(String title, String content, TextButton texButton_1,
      TextButton textButton_2) {
    AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(content),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [texButton_1, textButton_2]);
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }
}
