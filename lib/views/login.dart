import 'package:bytebank2/services/auth.dart';
import 'package:bytebank2/views/contacts/form.dart';
import 'package:bytebank2/views/dashboard.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final String _emailLabel = "Email";
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: _emailLabel,
                  icon: const Icon(Icons.email),
                ),
                style: TextStyle(fontSize: _fontSizeForLabels),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            TextField(
              obscureText: true,
              controller: _passwordController,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: _passwordLabel,
                icon: const Icon(Icons.lock),
              ),
              style: TextStyle(fontSize: _fontSizeForLabels),
              keyboardType: TextInputType.number,
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
                    onPressed: () => login(context),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  login(BuildContext context) {
    AuthService.to
        .signIn(_emailController.text, _passwordController.text, context);
  }
}
