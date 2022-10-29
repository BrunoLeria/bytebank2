import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String message;

  // ignore: use_key_in_widget_constructors
  const Loading({this.message = 'Loading'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text('Loading'),
        ],
      ),
    );
  }
}
