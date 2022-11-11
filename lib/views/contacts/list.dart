import 'package:bytebank2/database/dao/contact.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/views/contacts/form.dart';
import 'package:flutter/material.dart';

import '../../components/centered_message.dart';
import '../../components/loading.dart';
import '../transactions/form.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transfer',
        ),
      ),
      body: FutureBuilder(
        future: _contactDao.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          final List<Contact> contacts =
              snapshot.data != null ? snapshot.data as List<Contact> : [];
          if (contacts.isEmpty) {
            return const CenteredMessage(
              "Lista de contatos está vazia.",
              Icons.warning,
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final Contact contact = contacts[index];
              return _ContactItem(
                contact,
                onClick: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TransactionForm(contact))),
              );
            },
            itemCount: contacts.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => const ContactForm(),
              ),
            )
            .then((value) => setState(() {})),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  const _ContactItem(this.contact, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name!,
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
