import 'package:epub_reader/features/auth/provider/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Provider;

final authProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(auth: FirebaseAuth.instance),
);

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth auth;

  FirebaseAuthRepository({
    required this.auth,
  });

  @override
  User? get currentUser => auth.currentUser;

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<void> signOut() => FirebaseAuth.instance.signOut();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => currentUser!.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({
    required String toEmail,
  }) =>
      FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
}
