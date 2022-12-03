import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:local_auth/local_auth.dart';
import 'firebase_options.dart';
import 'package:bytebank2/components/check_auth.dart';
import 'package:bytebank2/models/balance.dart';
import 'package:bytebank2/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.lazyPut<AuthService>(() => AuthService());
  // Pass all uncaught errors from the framework to Crashlytics.

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FirebaseCrashlytics.instance.setUserIdentifier("qhs4mgkg9xt4tdi");
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runZonedGuarded<Future<void>>(() async {
    runApp(MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => Balance(0))],
        child: const ByteBankApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green[900],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green[900],
          secondary: Colors.blueAccent[700],
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent[700],
          ),
        ),
      ),
      home: CheckAuth(),
    );
  }
}
