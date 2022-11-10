import 'dart:async';

import 'package:bytebank2/components/loading.dart';
import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../api/webclients/transaction.dart';
import '../../components/response_dialog.dart';
import '../../models/contact.dart';
import 'list.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm(this.contact, {Key? key}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionID = const Uuid().v4();
  bool _sending = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Loading(
                    message: "Sending...",
                  ),
                ),
              ),
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
      _showFailureMessage(
        context,
        message: "Informe um valor válido para a transação.",
      );
    }
    final transactionCreated =
        Transaction(transactionID, value!, widget.contact);
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
    setState(() {
      _sending = true;
    });
    await _webClient.save(transactionCreated, password).then((transaction) {
      _showSuccessfulMessage(context);
    }).catchError((e) {
      sendToCrashlytics(e, transactionCreated);
      _showFailureMessage(
        context,
        message: e.message,
      );
    }, test: (e) => e is HttpException).catchError((e) {
      sendToCrashlytics(e, transactionCreated);
      _showFailureMessage(
        context,
        message: "Houve um problema com a conexão. Tente novamente mais tarde.",
      );
    }, test: (e) => e is TimeoutException).catchError((e) {
      sendToCrashlytics(e, transactionCreated);
      _showFailureMessage(context);
    }).whenComplete(() => setState(() {
          _sending = false;
        }));
  }

  void sendToCrashlytics(e, Transaction transactionCreated) {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      FirebaseCrashlytics.instance.setCustomKey("Exception", e.toString());
      FirebaseCrashlytics.instance.setCustomKey("http_code", e.StatusCode);
      FirebaseCrashlytics.instance
          .setCustomKey("http_body", transactionCreated.toString());
      FirebaseCrashlytics.instance.recordError(e.message, null);
    }
  }

  void _showFailureMessage(BuildContext context,
      {String message =
          'Erro desconhecido, por favor entre contato com o nosso'}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[900],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSuccessfulMessage(BuildContext context) {
    Navigator.pop(context);
    final snackBar = SnackBar(
      content: const Text('Transação feita com sucesso!'),
      backgroundColor: Colors.green[900],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
