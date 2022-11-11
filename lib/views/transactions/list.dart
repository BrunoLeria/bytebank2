import 'package:bytebank2/components/loading.dart';
import 'package:flutter/material.dart';

import '../../api/webclients/transaction.dart';
import '../../components/centered_message.dart';
import '../../models/contact.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({Key? key}) : super(key: key);

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
        ),
        body: FutureBuilder<List<Transaction>>(
            future: _webClient.findAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              }

              final List<Transaction> transactions = snapshot.data != null
                  ? snapshot.data as List<Transaction>
                  : [];

              if (transactions.isEmpty) {
                return const CenteredMessage(
                  "Lista de transações está vazia.",
                  Icons.warning,
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final Transaction transaction = transactions[index];
                  return _TransactionsItem(transaction);
                },
                itemCount: transactions.length,
              );
            }));
  }
}

class _TransactionsItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionsItem(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(
          transaction.value.toString(),
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          transaction.contact.name!,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class Transaction {
  final String id;
  final double value;
  final Contact contact;

  Transaction(
    this.id,
    this.value,
    this.contact,
  );

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        value = json['value'],
        contact = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
        'contact': contact.toJson(),
      };
}
