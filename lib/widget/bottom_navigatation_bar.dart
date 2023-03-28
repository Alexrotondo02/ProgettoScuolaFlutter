import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final ValueChanged<String> onSelected;

  const MyBottomNavigationBar({required this.onSelected, super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  String user = '';
  late int currentIndex;
  List<String> listPathStudente = [
    'Dati-anagrafici',
    'Assenze',
    'Voti',
    'Registro'
  ];
  List<String> listPathDocente = [
    'Dati-anagrafici',
    'Lista-studenti',
    'Firma-docente',
    'Registro'
  ];

  @override
  void initState() {
    init();
    setState(() {
      user = user;
      currentIndex = 0;
    });
    super.initState();
  }

  void init() async {
    final store = await SharedPreferences.getInstance();
    final stringJsonToken = store.get('token')!;
    final jsonToken = json.decode(stringJsonToken.toString());
    user = jsonToken['utenza'];
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          String selezione = '';
          selezione = (user == 'studente')
              ? listPathStudente.elementAt(index)
              : listPathDocente.elementAt(index);
          setState(() {
            currentIndex = index;
            widget.onSelected(selezione);
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[600],
        items: [
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.addressCard),
              label: 'Dati anagrafici'),
          user == 'studente'
              ? const BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.faceTired), label: 'Assenze')
              : const BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.list), label: 'Lista studenti'),
          user == 'studente'
              ? const BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.listCheck), label: 'Voti')
              : const BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.pen), label: 'Firma docente'),
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.book), label: 'Registro'),
        ]);
  }
}
