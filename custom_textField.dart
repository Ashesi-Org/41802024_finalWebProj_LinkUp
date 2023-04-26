import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String text;
  final TextEditingController ctrl;

  const CustomTextField({Key? key, required this.text, required this.ctrl});

  @override
  Widget build(BuildContext context){
    return TextFormField(
      validator: (value){
        if (value == null || value.isEmpty){
          return "Required field";
        }
        return null;
      },
      controller: ctrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: text,
        filled: true,
        fillColor: Colors.white70,
      ),
    );
  }



}