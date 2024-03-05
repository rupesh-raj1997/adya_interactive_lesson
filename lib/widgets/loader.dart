import 'package:flutter/material.dart';

Widget circularLoader(){
  return const SizedBox(
    height: double.infinity, // Fill the entire height of the parent
    child: Center(
      child: CircularProgressIndicator(), // Loader widget
    ),
  );
}