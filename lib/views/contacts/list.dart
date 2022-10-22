import 'package:bytebank2/views/contacts/form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
        ),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('Alex'),
              subtitle: const Text('1000'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactForm(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
