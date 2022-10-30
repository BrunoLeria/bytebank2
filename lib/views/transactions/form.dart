import 'dart:async';

import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:flutter/material.dart';

import '../../api/webclients/transaction.dart';
import '../../components/response_dialog.dart';
import '../../models/contact.dart';
import 'list.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.contact.name!,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transfer'),
                    onPressed: () {
                      _initiateTransaction(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _initiateTransaction(BuildContext context) {
    final double? value = double.tryParse(_valueController.text);
    if (value == null) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return const FailureDialog(
                "Informe um valor válido para a transação.");
          });
    }
    final transactionCreated = Transaction(value!, widget.contact);
    showDialog(
      context: context,
      builder: (contextDialog) {
        return TransactionAuthDialog(
          onConfirm: (password) => _save(transactionCreated, password, context),
        );
      },
    );
  }

  void _save(Transaction transactionCreated, String password,
      BuildContext context) async {
    await _webClient.save(transactionCreated, password).then((transaction) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (contextDialog) {
            return const SuccessDialog("Transação feita com sucesso!");
          });
    }).catchError((e) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return FailureDialog(e.message);
          });
    }, test: (e) => e is HttpException).catchError((e) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return const FailureDialog(
                "Houve um problema com a coneão. Tente novamente mais tarde.");
          });
    }, test: (e) => e is TimeoutException);
    ;
  }
}
