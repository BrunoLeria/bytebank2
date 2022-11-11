import 'package:bytebank2/services/auth.dart';
import 'package:bytebank2/views/dashboard.dart';
import 'package:bytebank2/views/login.dart';
import 'package:flutter/material.dart';

class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthService.to.userIsLogged.value ? Dashboard() : Login();
  }
}
