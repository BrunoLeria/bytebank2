import 'package:bytebank2/services/auth.dart';
import 'package:bytebank2/views/contacts/form.dart';
import 'package:bytebank2/views/dashboard.dart';
import 'package:flutter/material.dart';

import '../components/response_dialog.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final String _emailLabel = "Email";

  final String _passwordLabel = "Password";

  final double _fontSizeForLabels = 24.0;

  final FailureDialog? failureDialog = const FailureDialog();

  bool _informedEmail = false;
  bool logged = false;

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
                          ? login().then((value) => {
                                logged = value ?? false,
                                if (logged)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const Dashboard(),
                                      ),
                                    )
                                  }
                              })
                          : showPasswordField(),
                      child: const Text('Login with password'),
                    ),
                    ElevatedButton(
                      onPressed: () => loginWithBiometrics().then((value) => {
                                logged = value ?? false,
                                if (logged)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const Dashboard(),
                                      ),
                                    )
                                  }
                              }),
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

  showPasswordField() {
    if (_emailController.text.isEmpty) {
      failureDialog!.showFailureSnackBar(message: 'Please, inform your email');
      return;
    }
    setState(() {
      _informedEmail = true;
    });
  }

  Future<bool?> login() async {
    bool? status = await AuthService.to
        .signIn(_emailController.text, _passwordController.text);
    return status;
  }

  Future<bool?> loginWithBiometrics() async {
    if (_emailController.text.isEmpty) {
      failureDialog!.showFailureSnackBar(message: 'Please, inform your email');
      return false;
    }
    bool? status = await AuthService.to.authenticateUser(_emailController.text);
    return status;
  }
}
