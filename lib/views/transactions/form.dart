import 'dart:async';

import 'package:bytebank2/components/loading.dart';
import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:bytebank2/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../api/webclients/transaction.dart';
import '../../components/response_dialog.dart';
import '../../models/contact.dart';
import '../dashboard.dart';
import 'list.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm(this.contact, {Key? key}) : super(key: key);

  @override
  TransactionFormState createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionID = const Uuid().v4();
  bool _sending = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SuccessDialog? successDialog = const SuccessDialog();
  final FailureDialog? failureDialog = const FailureDialog();
  bool sucess = false;

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
                  widget.contact.email!,
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
                  decoration: const InputDecoration(
                      labelText: 'Value',
                      prefixIcon: Icon(Icons.monetization_on)),
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
      failureDialog!.showFailureSnackBar(
        message: "Informe um valor válido para a transação.",
      );
    }
    final transactionCreated =
        Transaction(transactionID, value!, widget.contact);
    showDialog(
      context: context,
      builder: (contextDialog) {
        return TransactionAuthDialog(
          onConfirm: (password) =>
              _save(transactionCreated, password).then((value) {
            sucess = value ?? false;
            if (sucess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              );
            }
          }),
        );
      },
    );
  }

  Future<bool?> _save(Transaction transactionCreated, String password) async {
    bool? transactionResult = false;
    setState(() {
      _sending = true;
    });
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    bool? result = await AuthService.to.signIn(email, password);
    if (!result!) {
      setState(() {
        _sending = false;
      });
      failureDialog!.showFailureSnackBar(message: "Transação não autorizada.");
      return result;
    }
    await _webClient
        .save(transactionCreated, "1000")
        .then((transaction) {
          successDialog!.showSuccessfulSnackBar('Transação feita com sucesso!');
          transactionResult = true;
        })
        .catchError((e) {},
            test: (e) => e is HttpException || e is CustomException)
        .catchError((e) {
          sendToCrashlytics(e, transactionCreated);
          failureDialog!.showFailureSnackBar(
            message:
                "Houve um problema com a conexão. Tente novamente mais tarde.",
          );
        }, test: (e) => e is TimeoutException)
        .catchError((e) {
          sendToCrashlytics(e, transactionCreated);
          failureDialog!.showFailureSnackBar(
            message:
                'Sua transação não foi concluída. Tente novamente mais tarde.',
          );
        }, test: (e) => e is Exception)
        .catchError((e) {
          sendToCrashlytics(e, transactionCreated);
          failureDialog!.showFailureSnackBar(
            message: 'Erro desconhecido, por favor entre contato com o nosso',
          );
        })
        .whenComplete(() => setState(() {
              _sending = false;
            }));
    return transactionResult;
  }

  void sendToCrashlytics(e, Transaction transactionCreated) {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      FirebaseCrashlytics.instance
          .setCustomKey("Exception", e.runtimeType.toString());
      if (e.runtimeType.toString() == "HttpException") {
        FirebaseCrashlytics.instance.setCustomKey("http_code", e.message);
      }
      FirebaseCrashlytics.instance
          .setCustomKey("http_body", transactionCreated.toString());
      FirebaseCrashlytics.instance.recordError(e.message, null);
    }
  }
}
