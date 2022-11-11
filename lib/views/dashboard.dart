import 'package:bytebank2/components/balance_card.dart';
import 'package:bytebank2/views/contacts/list.dart';
import 'package:bytebank2/views/deposits/form.dart';
import 'package:flutter/material.dart';
import 'transactions/list.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "Dashboard";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                    _FeatureItem(
                      'Deposit',
                      Icons.money,
                      onClick: () => _showDepositForm(context),
                    ),
                    _FeatureItem(
                      'Transfer',
                      Icons.monetization_on,
                      onClick: () => _showContactList(context),
                    ),
                    _FeatureItem(
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

  _showDepositForm(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DepositForm()));
  }
}

class _FeatureItem extends StatelessWidget {
  final String? name;
  final IconData? icon;
  final Function onClick;

  const _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32.0,
                ),
                Text(
                  name!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
