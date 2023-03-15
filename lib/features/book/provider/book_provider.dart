import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epub_reader/features/book/models/book_model.dart';
import 'package:epub_reader/utils/strings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class BookRepository {
  final FirebaseFirestore firestore;

  BookRepository({
    required this.firestore,
  });

  Future<List<BookModel>> getBooks({
    required String userId,
  }) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection(Strings.usersCollection)
        .doc(userId)
        .collection(Strings.booksCollection)
        .get();
    final List<BookModel> books = querySnapshot.docs.map(
      (doc) {
        return BookModel.fromMap(doc.data() as Map<String, dynamic>);
      },
    ).toList();
    return books;
  }

  Future<void> addBooks({
    required List<BookModel> books,
    required String userId,
  }) async {
    for (var book in books) {
      await firestore
          .collection(Strings.usersCollection)
          .doc(userId)
          .collection('books')
          .doc(book.id)
          .set(
            book.toMap(),
          );
    }
  }
}
