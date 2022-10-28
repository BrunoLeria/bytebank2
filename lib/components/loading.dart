import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String message;

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
    ;
  }
}
