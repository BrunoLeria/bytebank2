import 'package:bytebank2/components/feature_item.dart';
import 'package:bytebank2/models/avatar.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/views/avatar.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final Contact contact;
  final Avatar avatar;

  Settings(this.contact, this.avatar, {Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: widget.avatar.imagem == null
                  ? const Icon(
                      Icons.portrait,
                      color: Colors.grey,
                      size: 96.0,
                      semanticLabel: 'Profile avatar',
                    )
                  : widget.avatar.imageFromBase64String(250, 250),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${widget.contact.name!}',
                    style: const TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    "Email: ${widget.contact.email!}",
                    style: const TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    'Número da conta: ${widget.contact.accountNumber!}',
                    style: const TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  FeatureItem(
                    'Change avatar',
                    Icons.camera_alt,
                    onClick: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AvatarPage(),
                          fullscreenDialog: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
