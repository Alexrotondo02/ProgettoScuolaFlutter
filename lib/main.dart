import 'package:flutter/material.dart';
import 'package:progetto_scuola/http_service/service_dati.dart';
import 'package:progetto_scuola/pagine/myapp.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const SchoolProject());

class SchoolProject extends StatelessWidget {
  const SchoolProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('it', 'IT'),
        ],
        locale: ServiceDati.getLocale(),
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true),
        title: 'School project',
        home: MyApp());
  }
}

