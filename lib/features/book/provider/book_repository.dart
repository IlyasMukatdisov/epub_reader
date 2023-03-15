import 'package:epub_reader/features/book/models/book_model.dart';

abstract class BookRepository {
  Stream<List<BookModel>> getBooks({
    required String userId,
  });
  Future<void> addBooks({
    required List<BookModel> books,
    required String userId,
  });
}
