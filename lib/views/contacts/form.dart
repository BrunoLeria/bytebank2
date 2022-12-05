import 'dart:math';

import 'package:bytebank2/components/response_dialog.dart';
import 'package:bytebank2/database/dao/contact.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final ContactDao _contactDao = ContactDao();
  final String _appBarTitle = "New user";
  final String _nameLabel = "Full name";
  final String _emailLabel = "Email";
  final String _passwordLabel = "Password";
  final String _elevatedButtonLabel = "Create";
  final double _fontSizeForLabels = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: _nameLabel,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  style: TextStyle(fontSize: _fontSizeForLabels),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: _emailLabel,
                  prefixIcon: const Icon(Icons.email),
                ),
                style: TextStyle(fontSize: _fontSizeForLabels),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: _passwordLabel,
                  prefixIcon: const Icon(Icons.lock),
                ),
                style: TextStyle(fontSize: _fontSizeForLabels),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      const int id = 0;
                      final String name = _nameController.text;
                      final String email = _emailController.text;
                      final String password = _passwordController.text;
                      final int accountNumber = generateRadomAccountNumber();
                      const double balance = 1000.0;
                      final Contact newContact =
                          Contact(id, name, email, accountNumber);
                      newContact.balance = balance;
                      newContact.password = password;
                      _contactDao
                          .save(newContact, password, context)
                          .then((id) {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(_elevatedButtonLabel),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  int generateRadomAccountNumber() {
    final Random random = Random();
    int accountNumber = random.nextInt(10000);
    _contactDao.findAllAccountNumbers().then((accountNumbers) {
      while (accountNumbers.contains(accountNumber)) {
        accountNumber = random.nextInt(10000);
      }
    });
    return accountNumber;
  }
}
