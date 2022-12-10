import 'package:bytebank2/components/response_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../database/dao/contact.dart';
import '../models/contact.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SuccessDialog? successDialog = const SuccessDialog();
  final FailureDialog? failureDialog = const FailureDialog();

  Rx<User?>? _firebaseUser;
  RxBool userIsLogged = false.obs;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser!.bindStream(_auth.authStateChanges());

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        userIsLogged.value = false;
      } else {
        userIsLogged.value = true;
      }
    });
  }

  User? get user => _firebaseUser!.value;
  static AuthService get to => Get.find<AuthService>();

  Future<void> isUserSignedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        userIsLogged.value = false;
      } else {
        userIsLogged.value = true;
      }
    });
  }

  Future<bool?> signIn(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        failureDialog!.showFailureSnackBar(message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        failureDialog!.showFailureSnackBar(message: 'Wrong password provided for that user.');
      }
      return false;
    } catch (e) {
      failureDialog!.showFailureSnackBar(message: e.toString());
      return false;
    }
  }

  signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      successDialog!.showSuccessfulSnackBar("Welcome to Bytebank!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        failureDialog!.showFailureSnackBar(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        failureDialog!.showFailureSnackBar(message: 'The account already exists for that email.');
      }
    } catch (e) {
      failureDialog!.showFailureSnackBar(message: e.toString());
    }
  }

  signOut() async {
    await _auth.signOut();
  }

  Future<bool?> authenticateUser(BuildContext context, String email) async {
    //initialize Local Authentication plugin.
    final LocalAuthentication localAuthentication = LocalAuthentication();
    //status of authentication.
    bool? isAuthenticated = false;
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
        if (isAuthenticated) {
          Contact currentUser = await ContactDao().findByEmail(email);
          String password = currentUser.password!;
          isAuthenticated = await signIn(email, password);
        }
      } on PlatformException {
        failureDialog!.showFailureSnackBar(message: 'Failed to authenticate. Try again later.');
      }
    }
    return isAuthenticated;
  }
}
