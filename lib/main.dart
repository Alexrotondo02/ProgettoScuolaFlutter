import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:progetto_scuola/http_service/service_dati.dart';
import 'package:progetto_scuola/pagine/myapp.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const CheckConnection());

class CheckConnection extends StatefulWidget {
  const CheckConnection({super.key});

  @override
  State<CheckConnection> createState() => _CheckConnectionState();
}

class _CheckConnectionState extends State<CheckConnection> {
  StreamSubscription? internetconnection;
  bool isoffline = false;

  @override
  void initState() {
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none){
        setState(() {
          isoffline = true;
        });
      }else if(result == ConnectivityResult.mobile){
        setState(() {
          isoffline = false;
        });
      }else if(result == ConnectivityResult.wifi){
        setState(() {
          isoffline = false;
        });
      }
    });
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return isoffline ? PageError('Internet non disponibile si prega di riattivarlo') : const SchoolProject();
  }
}

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

// ignore: must_be_immutable
class PageError extends StatelessWidget {
  String text;
  PageError(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Center(
              child: Text(text, style: const TextStyle(fontSize: 17))
          ),
        ),
      ),
    );
  }
}

