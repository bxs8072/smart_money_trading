import 'package:firebase_auth/firebase_auth.dart';

import '../services/error_services/firebase_auth_error_message.dart';

class AuthApi {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get stream => firebaseAuth.authStateChanges();
  Future<void> reloadUserData() async {
    //will reload current user with change in user state.
    await firebaseAuth.currentUser!.reload();
  }

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If registration is successful them send account activation link to the registered email address
      await userCredential.user!.sendEmailVerification();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Send error with specific message according to the error codes from firebase
      throw FirebaseAuthErrorMessage(e.code).message;
    }
  }

  Future<void> sendVerification(User user) async {
    try {
      await user.sendEmailVerification();
      // If registration is successful them send account activation link to the registered email address
    } on FirebaseAuthException catch (e) {
      // Send error with specific message according to the error codes from firebase
      throw FirebaseAuthErrorMessage(e.code).message;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential? userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Send error with specific message according to the error codes from firebase

      throw FirebaseAuthErrorMessage(e.code).message;
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      // Send password reset link to provided email address
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      // If invalid email or unregistered email then send error
      throw FirebaseAuthErrorMessage(e.code).message;
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
