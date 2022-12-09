import 'package:bytebank2/services/auth.dart';
import 'package:bytebank2/views/contacts/form.dart';
import 'package:flutter/material.dart';

import '../components/response_dialog.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final String _emailLabel = "Email";

  final String _passwordLabel = "Password";

  final double _fontSizeForLabels = 24.0;


  bool _informedEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_informedEmail ? 'Password' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.adb_sharp,
                  color: Colors.green,
                  size: 96.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _informedEmail
                    ? TextField(
                        obscureText: true,
                        controller: _passwordController,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: _passwordLabel,
                          icon: const Icon(Icons.lock),
                        ),
                        style: TextStyle(fontSize: _fontSizeForLabels),
                        keyboardType: TextInputType.number,
                      )
                    : TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: _emailLabel,
                          icon: const Icon(Icons.email),
                        ),
                        style: TextStyle(fontSize: _fontSizeForLabels),
                        keyboardType: TextInputType.emailAddress,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ContactForm(),
                          ),
                        );
                      },
                      child: const Text('Register'),
                    ),
                    ElevatedButton(
                      onPressed: () => _informedEmail
                          ? login(context)
                          : showPasswordField(context),
                      child: const Text('Login with password'),
                    ),
                    ElevatedButton(
                      onPressed: () => loginWithBiometrics(context),
                      child: const Text('Login with biometrics'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showPasswordField(BuildContext context) {
    if (_emailController.text.isEmpty) {
      FailureDialog(message: 'Please, inform your email');
      return;
    }
    setState(() {
      _informedEmail = true;
    });
  }

  login(BuildContext context) {
    AuthService.to
        .signIn(_emailController.text, _passwordController.text, context);
  }

  loginWithBiometrics(BuildContext context) async {
    if (_emailController.text.isEmpty) {
      FailureDialog(message: 'Please, inform your email');
      return;
    }
    await AuthService.to.authenticateUser(context, _emailController.text);
  }
}
