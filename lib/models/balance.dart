import 'package:flutter/material.dart';

class Balance extends ChangeNotifier {
  double value;

  Balance(this.value);

  void add(double valor) {
    value += valor;
    notifyListeners();
  }

  void subtract(double valor) {
    value -= valor;
    notifyListeners();
  }

  @override
  String toString() {
    return 'R\$ $value';
  }
}
