import 'package:bytebank2/components/response_dialog.dart';
import 'package:bytebank2/views/dashboard.dart';
import 'package:bytebank2/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SuccessDialog? successDialog = new SuccessDialog();
  final FailureDialog? failureDialog = new FailureDialog();

  Rx<User?>? _firebaseUser;
  RxBool userIsLogged = false.obs;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser!.bindStream(_auth.authStateChanges());

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        userIsLogged.value = false;
      } else {
        print('User is signed in!');
        userIsLogged.value = true;
      }
    });
  }

  User? get user => _firebaseUser!.value;
  static AuthService get to => Get.find<AuthService>();

  Future<bool?> signIn(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (userIsLogged.value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Dashboard()));
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        failureDialog!.showFailureSnackBar(context,
            message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        failureDialog!.showFailureSnackBar(context,
            message: 'Wrong password provided for that user.');
      }
      return false;
    } catch (e) {
      failureDialog!.showFailureSnackBar(context, message: e.toString());
      return false;
    }
  }

  signUp(String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      signOut(context);
      successDialog!.showSuccessfulSnackBar(context, "Welcome to Bytebank!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        failureDialog!.showFailureSnackBar(context,
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        failureDialog!.showFailureSnackBar(context,
            message: 'The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  signOut(BuildContext context) async {
    await _auth.signOut();
    if (!userIsLogged.value) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    }
  }

  static Future<bool> authenticateUser() async {
    //initialize Local Authentication plugin.
    final LocalAuthentication localAuthentication = LocalAuthentication();
    //status of authentication.
    bool isAuthenticated = false;
    //check if device supports biometrics authentication.
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    //check if user has enabled biometrics.
    //check
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    //if device supports biometrics and user has enabled biometrics, then authenticate.
    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
            localizedReason: 'Scan your fingerprint to authenticate',
            options: const AuthenticationOptions(
                biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
      } on PlatformException catch (e) {
        print(e);
      }
    }
    return isAuthenticated;
  }
}
