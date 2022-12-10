import 'package:bytebank2/models/balance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/loading.dart';

class DepositForm extends StatefulWidget {

  const DepositForm({Key? key}) : super(key: key);

  @override
  State<DepositForm> createState() => _DepositFormState();
}

class _DepositFormState extends State<DepositForm> {
  TextEditingController valueController = TextEditingController();

  bool sending = false;

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
              Visibility(
                visible: sending,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Loading(
                    message: "Sending...",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: valueController,
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
                    child: const Text('Deposit'),
                    onPressed: () {
                      _initiateDeposit(context);
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

  void _initiateDeposit(BuildContext context) {
    final double? valor = double.tryParse(valueController.text);
    final validateDeposit = _validateDeposit(valor);

    if (validateDeposit) {
      _updateState(context, valor);
      Navigator.pop(context);
    }
  }

  _validateDeposit(double? valor) {
    if (valor != null || valor != 0.0) {
      return true;
    }
    return false;
  }

  _updateState(context, value) {
    Provider.of<Balance>(context, listen: false).add(value);
  }
}
