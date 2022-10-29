import 'dart:convert';

import 'package:http/http.dart';

import '../../models/contact.dart';
import '../../views/transactions/list.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client
        .get(Uri.parse(baseUrl))
        .timeout(const Duration(seconds: 15));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Map<String, dynamic> contactJson = transactionJson['contact'];
      final Transaction transaction = Transaction(
        transactionJson['value'],
        Contact(
          0,
          contactJson['name'],
          contactJson['accountNumber'],
        ),
      );
      transactions.add(transaction);
    }
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {
    final Contact contact = transaction.contact;
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': contact.name,
        'accountNumber': contact.accountNumber,
      }
    };

    final String transactionJson = jsonEncode(transactionMap);
    final Response response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson,
    );

    return _toTransaction(response);
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> json = jsonDecode(response.body);
    final Map<String, dynamic> contactJson = json['contact'];
    return Transaction(
      json['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
  }
}
