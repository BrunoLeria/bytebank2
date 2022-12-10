import 'package:bytebank2/database/dao/avatar.dart';
import 'package:bytebank2/database/dao/contact.dart';
import 'package:bytebank2/models/avatar.dart';
import 'package:bytebank2/models/contact.dart';
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
        future: _contactDao.findAllExceptMe(),
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
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  const _ContactItem(this.contact, {required this.onClick});

  Future<Avatar> getAvatar() async {
    final AvatarDao avatarDao = AvatarDao();
    final Avatar avatar = await avatarDao.findByEmail(contact.email!);
    return avatar;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAvatar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        final Avatar avatar = snapshot.data != null
            ? snapshot.data as Avatar
            : Avatar(null, null, null);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => onClick(),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                    width: 5,
                  )),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    avatar.imagem == null
                        ? const Icon(
                            Icons.portrait,
                            color: Colors.grey,
                            size: 100,
                            semanticLabel: 'Profile avatar',
                          )
                        : avatar.imageFromBase64String(100, 100),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name!,
                          style: const TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                        Text(
                          contact.email!,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
