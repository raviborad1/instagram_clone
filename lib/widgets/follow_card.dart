import 'package:flutter/material.dart';

class followbutton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final Function()? function;
  final Color borderColor;

  const followbutton(
      {Key? key,
      required this.text,
      required this.backgroundColor,
      required this.borderColor,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: backgroundColor,
          ),
          alignment: Alignment.center,

          width:250 ,
          height: 27,
          child: Text(
            text,
            style: TextStyle(color: textColor,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
