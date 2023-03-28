import 'package:flutter/material.dart';
import 'package:progetto_scuola/http_service/httpservice.dart';
import 'myapp.dart';

class LoginPage extends StatefulWidget {
  final String user;

  const LoginPage(this.user, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String labelKey;
  late String placeholderKey;
  final TextEditingController key = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final HttpService httpService = HttpService();

  @override
  void initState() {
    if (widget.user == 'studente') {
      labelKey = 'User code';
      placeholderKey = 'Inserisci user code';
    } else {
      labelKey = 'Codice fiscale';
      placeholderKey = 'Inserisci codice fiscale';
    }
    setState(() {
      labelKey = labelKey;
      placeholderKey = placeholderKey;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsetsDirectional.zero,
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 16, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Expanded(
                              child: Text('Welcome Back',
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            createTextField(key, labelKey, placeholderKey),
                            widget.user == 'docente'
                                ? createTextField(
                                    mail, 'Mail', 'Inserisci la tua mail')
                                : const SizedBox(),
                            createTextField(password, 'Password',
                                'Inserisci la tua password')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 12, 20, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            TextButton(
                              onPressed: () {
                                if(widget.user == 'studente'){
                                  loginStudente();
                                }else {
                                  loginDocente();
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(50, 150, 255, 100))),
                              child: const Text('Login',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 2,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: Color(0xFFDBE2E7),
                      ),
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 12, 0, 12),
                          child: TextButton(
                              onPressed: () {},
                              child: const Text('Create account',
                                  style: TextStyle(fontSize: 18)))),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget createTextField(
      TextEditingController controller, String label, String placeholder) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
                controller: controller,
                obscureText: label.toLowerCase() == 'password',
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: placeholder,
                  hintStyle: TextStyle(color: Colors.grey[400]),
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

  void alertDialog() {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void loginStudente() async {
    alertDialog();
    bool callSuccess = await httpService.loginStudente(key.text, password.text);
    SnackBar snackBar = SnackBar(
        content: Text(callSuccess
            ? 'Login riuscito'
            : 'Login non riuscito! User code o password errate'),
        backgroundColor: callSuccess ? Colors.green : Colors.red);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    if (callSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp()));
    }
  }

  void loginDocente() async {
    alertDialog();
    bool callSuccess =
        await httpService.loginDocente(key.text, password.text, mail.text);
    SnackBar snackBar = SnackBar(
        content: Text(callSuccess
            ? 'Login riuscito'
            : 'Login non riuscito! Codice fiscale, mail o password errate'),
        backgroundColor: callSuccess ? Colors.green : Colors.red);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    if (callSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp()));
    }
  }
}
