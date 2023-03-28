import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progetto_scuola/classi/Assenza.dart';
import 'package:progetto_scuola/classi/Classe.dart';
import 'package:progetto_scuola/http_service/service_dati.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classi/Docente.dart';
import '../classi/Studente.dart';

class HttpService {
  final Dio dio = Dio();
  final String url = 'http://192.168.0.79:8090';
  static final HttpService _singleton = HttpService._internal();

  HttpService._internal();

  factory HttpService() {
    return _singleton;
  }

  Future<Map<String, dynamic>> getJsonToken() async {
    final store = await SharedPreferences.getInstance();
    final stringJsonToken = store.get('token') ?? '';
    if (stringJsonToken != '') {
      final Map<String, dynamic> jsonToken =
          json.decode(stringJsonToken.toString());
      return jsonToken;
    } else {
      return {'token': '', 'utenza': ''};
    }
  }

  Future<bool> loginStudente(String userCode, String password) async {
    try {
      //per ricevere il token
      final token = await dio.post('$url/auth/authenticate-student',
          data: {'userCode': userCode, 'password': password});

      //setting token nello store
      final store = await SharedPreferences.getInstance();
      return await store.setString('token', token.toString());
    } catch (error) {
      return false;
    }
  }

  Future<bool> loginDocente(
      String codiceFiscale, String password, String mail) async {
    try {
      //per ricevere il token
      final token = await dio.post('$url/auth/authenticate-docente', data: {
        'codiceFiscale': codiceFiscale,
        'password': password,
        'mail': mail
      });

      //setting token nello store
      final store = await SharedPreferences.getInstance();
      return await store.setString('token', token.toString());
    } catch (error) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getStudente(String token) async {
    try {
      final String sub = _decodifica(token)['sub'];
      //per settare l'headers
      final options = Options(headers: {'Authorization': 'Bearer $token'});
      //per ottenere lo studente
      try {
        final studenteJson = await dio.get<Map<String, dynamic>>(
            '$url/studente/$sub/get-studente',
            options: options);
        return {
          'studente': Studente.fromJson(studenteJson.data!),
          'status': studenteJson.statusCode
        };
      } on DioError catch (error) {
        return {
          'message': error.response!.data,
          'status': error.response!.statusCode
        };
      }
    } catch (error) {
      return {'message': 'Si prega di attivare internet', 'status': 0};
    }
  }

  Future<Map<String, dynamic>> getDocente(String token) async {
    try {
      final String sub = _decodifica(token)['sub'];
      //per settare l'headers
      final options = Options(headers: {'Authorization': 'Bearer $token'});
      //per ottenere lo studente
      try {
        final docenteJson = await dio.get<Map<String, dynamic>>(
            '$url/docente/$sub/get-docente',
            options: options);
        return {
          'docente': Docente.fromJson(docenteJson.data!),
          'status': docenteJson.statusCode
        };
      } on DioError catch (error) {
        return {
          'message': error.response!.data,
          'status': error.response!.statusCode
        };
      }
    } catch (error) {
      return {'message': 'Si prega di attivare internet', 'status': 0};
    }
  }

  Future<bool> logout() async {
    ServiceDati.setUtenza('');
    ServiceDati.setDocente(Docente());
    ServiceDati.setStudente(Studente());
    final store = await SharedPreferences.getInstance();
    return await store.remove('token');
  }

  Future<Map<String, dynamic>> updateStudente(Studente studente) async {
    try {
      final Map<String, dynamic> jsonToken = await getJsonToken();

      final options =
          Options(headers: {'Authorization': 'Bearer ${jsonToken['token']}'});

      try {
        final message = await dio.put('$url/studente/update',
            options: options, data: studente.toJson());
        return {'message': message.data, 'status': message.statusCode};
      } on DioError catch (error) {
        return {
          'message': error.response!.data,
          'status': error.response!.statusCode
        };
      }
    } catch (error) {
      return {
        'message': 'Errore durante la modifica dello studente',
        'status': 0
      };
    }
  }

  Future<Map<String, dynamic>> updateDocente(Docente docente) async {
    try {
      final Map<String, dynamic> jsonToken = await getJsonToken();

      final options =
          Options(headers: {'Authorization': 'Bearer ${jsonToken['token']}'});

      try {
        final message = await dio.put('$url/docente/update',
            options: options, data: docente.toJson());
        return {'message': message.data, 'status': message.statusCode};
      } on DioError catch (error) {
        return {
          'message': error.response!.data,
          'status': error.response!.statusCode
        };
      }
    } catch (error) {
      return {'message': 'Errore durante la modifica del docente', 'status': 0};
    }
  }

  Future<List<Assenza>> getAssenze() async {
    try {
      final Map<String, dynamic> jsonToken = await getJsonToken();
      final String userCode = _decodifica(jsonToken['token'])['sub'];

      final options =
          Options(headers: {'Authorization': 'Bearer ${jsonToken['token']}'});

      try {
        final response = await dio.get('$url/studente/$userCode/get-assenze',
            options: options);
        return Assenza.getListAssenze(response.data);
      } on DioError {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<Map<String, dynamic>> saveAssenze() async {
    try {
      final Map<String, dynamic> jsonToken = await getJsonToken();
      final String userCode = ServiceDati.getStudente().userCode!;

      final options = Options(
          headers: {'Authorization': 'Bearer ${jsonToken['token']}'},
          contentType: 'application/json');

      try {
        final response =
            await dio.put('$url/studente/$userCode/giustifica-assenze',
                options: options,
                data: ServiceDati.getAssenze().map((assenza) {
                  return assenza.toJson();
                }).toList());

        return {'message': response.data, 'status': response.statusCode};
      } on DioError catch (error) {
        return {
          'message': error.response!.data,
          'status': error.response!.statusCode
        };
      }
    } catch (error) {
      return {'message': 'Si prega di attivare internet', 'status': 0};
    }
  }

  Future<List<Classe>> getListaClassi() async {
    try {
      try {
        final response = await dio.get('$url/classe/find-all');
        return Classe.getListClassi(response.data);
      } on DioError {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Docente>> getListaDocenti() async {
    try {
      try {
        final response = await dio.get('$url/docente/find-all');
        return Docente.getListDocenti(response.data);
      } on DioError {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Classe>> getClassiByDocente() async {
    try {
      final Map<String, dynamic> jsonToken = await getJsonToken();
      final String codiceFiscale = ServiceDati.getDocente().codiceFiscale;

      final options =
          Options(headers: {'Authorization': 'Bearer ${jsonToken['token']}'});

      try {
        final response =
            await dio.get('$url/docente/find/$codiceFiscale', options: options);
        return Classe.getListClassi(response.data);
      } on DioError {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Studente>> getStudentiBySezione(String sezione) async {
    try {
      final Map<String, dynamic> jsonToken = await getJsonToken();

      final options =
          Options(headers: {'Authorization': 'Bearer ${jsonToken['token']}'});

      try{
        final response = await dio.get('$url/classe/$sezione/studenti', options: options);
        return Studente.getListaStudenti(response.data);
      } on DioError {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Map<String, dynamic> _decodifica(String token) {
    return JwtDecoder.decode(token);
  }
}
