import 'package:bytebank2/views/dashboard.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _accountNumberController =
      TextEditingController();
  final String _accountNumberLabel = "Account number";
  final String _passwordLabel = "Password";
  final double _fontSizeForLabels = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.asset('images/bytebank_logo.png'),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: _accountNumberLabel,
                ),
                style: TextStyle(fontSize: _fontSizeForLabels),
                keyboardType: TextInputType.number,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: _passwordLabel,
              ),
              style: TextStyle(fontSize: _fontSizeForLabels),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Dashboard()))),
            ),
          ],
        ),
      ),
    );
  }
}
