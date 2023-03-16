import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/features/book/models/book_model.dart';
import 'package:epub_reader/features/book/provider/book_repository.dart';
import 'package:epub_reader/utils/strings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => FirebaseBookRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

final booksProvider = StreamProvider.autoDispose<List<BookModel>>((ref) {
  final userId = ref.watch(authProvider).currentUser?.uid;
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBooks(userId: userId!);
});

class FirebaseBookRepository implements BookRepository {
  final FirebaseFirestore firestore;

  FirebaseBookRepository({
    required this.firestore,
  });

  @override
  Stream<List<BookModel>> getBooks({
    required String userId,
  }) {
    return firestore
        .collection(Strings.usersCollection)
        .doc(userId)
        .collection(Strings.booksCollection)
        .snapshots()
        .asyncMap(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BookModel.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> addBooksToDb({
    required List<BookModel> books,
    required String userId,
  }) async {
    for (var book in books) {
      await firestore
          .collection(Strings.usersCollection)
          .doc(userId)
          .collection(Strings.booksCollection)
          .doc(book.id)
          .set(
            book.toMap(),
          );
    }
  }

  @override
  Future<void> addBooksToStorage({required List<File> books}) async {}
}
