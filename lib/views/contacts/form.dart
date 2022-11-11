import 'package:bytebank2/databases/dao/contact.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _accountNumberController =
      TextEditingController();

  final ContactDao _contactDao = ContactDao();
  final String _appBarTitle = "New Contact";
  final String _nameLabel = "Full name";
  final String _accountNumberLabel = "Account number";
  final String _elevatedButtonLabel = "Create";
  final double _fontSizeForLabels = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              controller: _accountNumberController,
              decoration: InputDecoration(
                labelText: _accountNumberLabel,
                prefixIcon: const Icon(Icons.account_balance),
              ),
              style: TextStyle(fontSize: _fontSizeForLabels),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    const int id = 0;
                    final String name = _nameController.text;
                    final int? accountNumber =
                        int.tryParse(_accountNumberController.text);
                    final Contact newContact =
                        Contact(id, name, accountNumber, 0);
                    _contactDao
                        .save(newContact)
                        .then((id) => Navigator.pop(context));
                  },
                  child: Text(_elevatedButtonLabel),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
