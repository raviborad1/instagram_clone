import 'package:flutter/material.dart';

class textFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  final String hintext;

  const textFieldInput(
      {Key? key,
      required this.textInputType,
      required this.textEditingController,
      required this.hintext,
      this.isPass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hintext,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
    );
  }
}
