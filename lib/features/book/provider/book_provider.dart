import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/features/book/models/book_model.dart';
import 'package:epub_reader/features/book/provider/book_repository.dart';
import 'package:epub_reader/utils/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => FirebaseBookRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  ),
);

final booksProvider = StreamProvider.autoDispose<List<BookModel>>((ref) {
  final userId = ref.watch(authProvider).currentUser?.uid;
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBooksInfo(userId: userId!);
});

class FirebaseBookRepository implements BookRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseBookRepository({
    required this.firestore,
    required this.storage,
  });

  @override
  Stream<List<BookModel>> getBooksInfo({
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
  Future<void> addBooks({
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

// Returns a list of stored books paths
  @override
  Future<List<String>> addBooksToStorage({
    required List<File> books,
    required List<BookModel> bookModels,
    required String userId,
  }) async {
    final List<String> paths = [];
    for (int i = 0; i < bookModels.length; i++) {
      final String path =
          '${Strings.usersCollection}/$userId/${Strings.booksCollection}/${bookModels.elementAt(i).id}';
      final booksRef = storage.ref().child(path);
      await booksRef.putFile(
        books.elementAt(i),
      );
      paths.add(path);
    }
    return paths;
  }

  @override
  Future<List<File>> downloadBooksFromStorage({
    required List<BookModel> bookModels,
  }) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final List<File> files = downloadBooks(
      bookModels: bookModels,
      appDocDir: appDocDir,
    );
    return files;
  }

  List<File> downloadBooks({
    required List<BookModel> bookModels,
    required Directory appDocDir,
  }) {
    final List<File> files = [];
    for (BookModel bookModel in bookModels) {
      final storageRef = storage.ref();
      final storagePathRef = storageRef.child(bookModel.path);
      final filePath =
          "${appDocDir.absolute}/${Strings.booksCollection}/${bookModel.id}";
      final File file = File(filePath);
      final downloadTask = storagePathRef.writeToFile(file);
      downloadTask.snapshotEvents.listen(
        (taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              debugPrint('Downloading... ${taskSnapshot.bytesTransferred}');
              break;
            case TaskState.paused:
              debugPrint('Paused ${taskSnapshot.bytesTransferred}');
              break;
            case TaskState.success:
              debugPrint('Downloaded ${taskSnapshot.bytesTransferred}');
              files.add(file);
              break;

            case TaskState.canceled:
              debugPrint('Canceled');
              break;
            case TaskState.error:
              debugPrint('Downloading Error');
              break;
          }
        },
      );
    }
    return files;
  }
}
