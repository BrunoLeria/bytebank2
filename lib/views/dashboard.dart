import 'package:bytebank2/components/balance_card.dart';
import 'package:bytebank2/components/feature_item.dart';
import 'package:bytebank2/database/dao/avatar.dart';
import 'package:bytebank2/database/dao/contact.dart';
import 'package:bytebank2/models/avatar.dart';
import 'package:bytebank2/views/contacts/list.dart';
import 'package:bytebank2/views/deposits/form.dart';
import 'package:bytebank2/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/balance.dart';
import '../models/contact.dart';
import '../services/auth.dart';
import 'login.dart';
import 'transactions/list.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Dashboard";
    updateBalance(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => _showSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BalanceCard(),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    FeatureItem(
                      'Deposit',
                      Icons.money,
                      onClick: () => _showDepositForm(context),
                    ),
                    FeatureItem(
                      'Transfer',
                      Icons.monetization_on,
                      onClick: () => _showContactList(context),
                    ),
                    FeatureItem(
                      'Transaction Feed',
                      Icons.description,
                      onClick: () => _showTransactionsList(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactList(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ContactsList()));
  }

  void _showTransactionsList(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const TransactionsList()));
  }

  void _showSettings(BuildContext context) async {
    String? email = AuthService.to.user?.email ?? '';
    Contact contact = await ContactDao().findByEmail(email);
    Avatar avatar = await AvatarDao().findByEmail(email);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Settings(contact, avatar)));
  }

  _showDepositForm(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DepositForm()));
  }

  void _logout(BuildContext context) {
    AuthService.to.signOut(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  void updateBalance(BuildContext context) {
    Provider.of<Balance>(context, listen: false).getCurrentUserBalance();
  }
}
