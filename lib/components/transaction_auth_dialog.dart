import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {
  const TransactionAuthDialog({Key? key, required this.onConfirm})
      : super(key: key);
  final Function(String password) onConfirm;

  @override
  State<TransactionAuthDialog> createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final title = "Authenticate";

  final confirmButtonText = "Confirm";

  final cancelButtonText = "Cancel";

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        maxLength: 6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 64,
          letterSpacing: 24,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(cancelButtonText),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm(_passwordController.text);
            Navigator.pop(context);
          },
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
