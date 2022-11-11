import 'dart:convert';

import 'package:bytebank2/models/balance.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../views/transactions/list.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(Uri.parse(baseUrl));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(
      Transaction transaction, String password, context) async {
    if (transaction.value >
        Provider.of<Balance>(context, listen: false).value) {
      throw CustomException("Saldo insufisiente");
    }
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(Uri.parse(baseUrl),
        headers: {'Content-type': 'application/json', 'password': password},
        body: transactionJson);
    if (response.statusCode == 200) {
      Provider.of<Balance>(context, listen: false).subtract(transaction.value);
      return Transaction.fromJson(jsonDecode(response.body));
    }
    throw HttpException(_getMessage(response.statusCode));
  }

  String? _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }

    return "Erro desconhecido.  ";
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'Houve um erro ao enviar a transação.',
    401: 'Falha na autenticação',
    409: 'Essa transação já existe.',
    500:
        'Houve um problema de conexão com servidor. Por favor, tente novamente mais tarde.'
  };
}

class HttpException implements Exception {
  final String? message;

  HttpException(this.message);
}

class CustomException implements Exception {
  final String? message;

  CustomException(this.message);
}
