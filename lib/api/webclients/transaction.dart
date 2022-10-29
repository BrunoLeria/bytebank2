import 'dart:convert';

import 'package:http/http.dart';

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
      transactions.add(Transaction.fromJson(transactionJson));
    }
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(Uri.parse(baseUrl),
        headers: {'Content-type': 'application/json', 'password': '1000'},
        body: transactionJson);

    return _toTransaction(response);
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return Transaction.fromJson(json);
  }
}
