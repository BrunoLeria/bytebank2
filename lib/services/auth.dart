import 'package:bytebank2/components/response_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?>? _firebaseUser;
  var userIsLogged = false;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser!.bindStream(_auth.authStateChanges());

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      userIsLogged = user != null;
    });
  }

  User? get user => _firebaseUser!.value;
  static AuthService get to => Get.find<AuthService>();

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        const FailureDialog('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        const FailureDialog('Wrong password provided for that user.');
      }
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const FailureDialog('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        const FailureDialog('The account already exists for that email.');
      }
    } catch (e) {
      FailureDialog(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
