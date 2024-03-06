import 'package:flutter/material.dart';

Widget PrimaryButton({onPressed, child, disabled}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: child,
    style: ElevatedButton.styleFrom(
      elevation: 2,
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

const btnFontStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);
