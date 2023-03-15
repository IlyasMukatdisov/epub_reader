import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Provider ;


final authProvider = Provider(
  (ref) => AuthRepository(auth: FirebaseAuth.instance),
);

class AuthRepository {
  final FirebaseAuth auth;

  AuthRepository({
    required this.auth,
  });

  User? get currentUser => auth.currentUser;

  Future<void> createUser({
    required String email,
    required String password,
  }) =>
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<void> logOut() => FirebaseAuth.instance.signOut();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> sendEmailVerification() => currentUser!.sendEmailVerification();

  Future<void> sendPasswordReset({
    required String toEmail,
  }) =>
      FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
}
