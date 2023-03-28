import 'dart:ui';

import 'package:progetto_scuola/classi/Docente.dart';
import 'package:progetto_scuola/classi/Studente.dart';

import '../classi/Assenza.dart';

class ServiceDati{
  static Locale? _locale;
  static String? _utenza;
  static Studente? _studente;
  static Docente? _docente;
  static List<Assenza>? _assenze;

  static void setLocale(Locale newLocale) {
    _locale = newLocale;
  }

  static Locale getLocale() {
    return _locale ?? const Locale('en', 'US');
  }

  static void setUtenza(String newUtenza){
    _utenza = newUtenza;
  }

  static String getUtenza() {
    return _utenza ?? '';
  }

  static void setStudente(Studente newStudente) {
    _studente = newStudente;
  }

  static Studente getStudente() {
    return _studente ?? Studente();
  }

  static void setDocente(Docente newDocente) {
    _docente = newDocente;
  }

  static Docente getDocente() {
    return _docente ?? Docente();
  }

  static void setAssenze(List<Assenza> assenzeGiustificate) {
    _assenze = assenzeGiustificate;
  }

  static List<Assenza> getAssenze() {
    return _assenze ?? [];
  }
}