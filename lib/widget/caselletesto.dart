import 'package:flutter/material.dart';

class CasellaTesto extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  const CasellaTesto(this.controller, this.placeholder, {super.key});

  @override
  State<CasellaTesto> createState() => _CasellaTestoState();
}

class _CasellaTestoState extends State<CasellaTesto> {

  @override
  Widget build(BuildContext context) {
    bool inputTypePassword = false;
    if(widget.placeholder.contains('password')){
      inputTypePassword = true;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: inputTypePassword,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide:BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.placeholder,
          hintStyle: TextStyle(color:Colors.grey[500]),
        ),
      ),
    );
  }
}