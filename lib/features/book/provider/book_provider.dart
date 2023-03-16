import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/features/book/models/book_model.dart';
import 'package:epub_reader/features/book/provider/book_repository.dart';
import 'package:epub_reader/utils/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => FirebaseBookRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  ),
);

final booksProvider = StreamProvider.autoDispose<List<BookModel>>((ref) {
  final userId = ref.watch(authProvider).currentUser?.uid;
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBooks(userId: userId!);
});

class FirebaseBookRepository implements BookRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseBookRepository({
    required this.firestore,
    required this.storage,
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
  Future<void> addBooksToStorage({
    required List<File> books,
    required List<BookModel> bookModels,
    required String userId,
  }) async {
    for (int i = 0; i < bookModels.length; i++) {
      final String path =
          '${Strings.usersCollection}/$userId/${Strings.booksCollection}/${bookModels.elementAt(i).id}';
      final booksRef = storage.ref().child(path);
      await booksRef.putFile(
        books.elementAt(i),
      );
    }
  }

  @override
  Future<List<File>> getBooksFromStorage({
    required String userId,
  }) async {
    final String path =
        '${Strings.usersCollection}/$userId/${Strings.booksCollection}';
    final ListResult listResults = await storage.ref().child(path).listAll();
    for(Reference reference in listResults.items){
      await reference.getData();
    }
    
  }
}
