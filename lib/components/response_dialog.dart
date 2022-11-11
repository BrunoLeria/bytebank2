import 'package:flutter/material.dart';

class ResponseDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData? icon;
  final Color colorIcon;

  const ResponseDialog({
    Key? key,
    this.title = "",
    this.message = "",
    this.icon,
    this.buttonText = 'Ok',
    this.colorIcon = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Visibility(
        visible: title.isNotEmpty,
        child: Text(title),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: icon != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Icon(
                icon,
                size: 64,
                color: colorIcon,
              ),
            ),
          ),
          Visibility(
            visible: message.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(buttonText),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const SuccessDialog({
    Key? key,
    this.message = '',
    this.title = 'Success',
    this.icon = Icons.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponseDialog(
      title: title,
      message: message,
      icon: icon,
      colorIcon: Colors.green,
    );
  }

  void showSuccessfulSnackBar(BuildContext context, String message) {
    Navigator.pop(context);
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[900],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class FailureDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const FailureDialog({
    Key? key,
    this.message = '',
    this.title = 'Failure',
    this.icon = Icons.warning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponseDialog(
      title: title,
      message: message,
      icon: icon,
      colorIcon: Colors.red,
    );
  }

  void showFailureSnackBar(BuildContext context,
      {String message =
          'Erro desconhecido, por favor entre contato com o nosso'}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[900],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
