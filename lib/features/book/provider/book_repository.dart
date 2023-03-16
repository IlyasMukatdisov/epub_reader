import 'dart:io';

import 'package:epub_reader/features/book/models/book_model.dart';

abstract class BookRepository {
  Stream<List<BookModel>> getBooks({
    required String userId,
  });
  Future<void> addBooksToDb({
    required List<BookModel> books,
    required String userId,
  });

  Future<void> addBooksToStorage({
    required String userId,
    required List<File> books,
    required List<BookModel> bookModels,
  });

  Future<List<File>> getBooksFromStorage({
    required String userId,
  });
}
