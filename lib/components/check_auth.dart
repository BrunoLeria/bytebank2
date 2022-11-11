import 'package:bytebank2/views/dashboard.dart';
import 'package:bytebank2/views/login.dart';
import 'package:flutter/material.dart';

class CheckAuth extends StatelessWidget {
  final bool userIsLogged = false;

  @override
  Widget build(BuildContext context) {
    return userIsLogged ? Dashboard() : Login();
  }
}
