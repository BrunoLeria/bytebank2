import 'package:bytebank2/components/feature_item.dart';
import 'package:bytebank2/database/dao/contact.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/views/dashboard.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class Settings extends StatefulWidget {
  final Contact contact;

  Settings(this.contact, {Key? key}) : super(key: key);

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
              child: widget.contact.image == null
                  ? const Icon(
                      Icons.portrait,
                      color: Colors.grey,
                      size: 96.0,
                      semanticLabel: 'Profile avatar',
                    )
                  : Image.asset('images/bytebank_logo.png'),
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
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ButtonBar(
                children: [
                  FeatureItem(
                    'Change avatar',
                    Icons.camera_alt,
                    onClick: () => _chooseProfilePicture(context),
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

_chooseProfilePicture(BuildContext context) async {
  // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
}
