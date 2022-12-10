import 'package:bytebank2/database/dao/contact.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/services/auth.dart';
import 'package:flutter/material.dart';

class Balance extends ChangeNotifier {
  double value;

  Balance(this.value);

  void getCurrentUserBalance() async {
    String? email = AuthService.to.user?.email ?? '';
    final double balance = await ContactDao().getBalance(email);
    value = balance;
    notifyListeners();
  }

  void add(double valor) async {
    String? email = AuthService.to.user?.email ?? '';

    Contact currentUser = await ContactDao().findByEmail(email);
    currentUser.balance = currentUser.balance! + valor;
    await ContactDao().update(currentUser);
    value += valor;
    notifyListeners();
  }

  void subtract(Contact contact) async {
    String? email = AuthService.to.user?.email ?? '';
    double valorTransferencia = value;

    Contact currentUser = await ContactDao().findByEmail(email);
    currentUser.balance = currentUser.balance! - valorTransferencia;
    await ContactDao().update(currentUser);
    value -= valorTransferencia;
    notifyListeners();

    int accountNumber = contact.accountNumber ?? 0;
    contact = await ContactDao().findByAccountNumber(accountNumber);
    print(valorTransferencia);
    print(contact.balance);
    contact.balance = contact.balance! + valorTransferencia;
    print(accountNumber);
    print(contact.balance);
    await ContactDao().update(contact);

    
  }

  @override
  String toString() {
    return 'R\$ $value';
  }
}
