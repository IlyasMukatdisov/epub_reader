import 'dart:io';

import 'package:epub_reader/features/book/models/book_model.dart';

abstract class BookRepository {
  Stream<List<BookModel>> getBooksInfo({
    required String userId,
  });

  Future<void> addBooks({
    required List<BookModel> books,
    required String userId,
  });

  Future<List<String>> addBooksToStorage({
    required String userId,
    required List<File> books,
    required List<BookModel> bookModels,
  });

  Future<List<File>> downloadBooksFromStorage({
    required String userId,
  });
}
