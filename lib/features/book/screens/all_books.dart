import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/features/book/models/book_model.dart';
import 'package:epub_reader/features/book/provider/book_provider.dart';
import 'package:epub_reader/utils/utils.dart';
import 'package:epub_view/epub_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class AllBooksScreen extends StatelessWidget {
  const AllBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Consumer(
          builder: (context, ref, child) => FloatingActionButton(
            onPressed: () {
              pickBooks().then((bookFiles) {
                bookSaveLogic(
                  bookFiles: bookFiles,
                  context: context,
                  ref: ref,
                );
              }).onError(
                (error, stackTrace) {
                  debugPrint(
                    error.toString(),
                  );
                  debugPrint(
                    stackTrace.toString(),
                  );
                  Utils.showMessage(
                    context: context,
                    message: error.toString(),
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        appBar: AppBar(
          title: const Text('All Books'),
        ),
        body: const AllBooksList());
  }

  void bookSaveLogic({
    required List<File> bookFiles,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (bookFiles != []) {
      final savedBooks = ref.read(booksProvider).value;
      final List<EpubBook> epubBooks = getEpubBooks(bookFiles);

      final List<BookModel> bookModels = getBooks(epubBooks);

      if (savedBooks != null) {
        bookModels.removeWhere(
          (bookModel) {
            if (savedBooks.contains(bookModel)) {
              debugPrint(
                'Book ${bookModel.title} by ${bookModel.authors} already exists',
              );
              Utils.showMessage(
                context: context,
                message:
                    'Book ${bookModel.title} by ${bookModel.authors} already exists',
              );
              return true;
            } else {
              return false;
            }
          },
        );
        for (final savedBook in savedBooks) {
          for (final epubBook in epubBooks) {
            if (epubBook.Title == savedBook.title &&
                epubBook.Author == savedBook.authors) {
              epubBooks.remove(epubBook);
            }
          }
        }
      }
      if (bookModels.isNotEmpty && epubBooks.isNotEmpty) {
        ref.read(bookRepositoryProvider).addBooksToDb(
              books: bookModels,
              userId: ref.read(authProvider).currentUser!.uid,
            );
      }
    }
  }
}

List<EpubBook> getEpubBooks(List<File> files) {
  final epubBooks = <EpubBook>[];
  files.map(
    (file) async {
      final epubBook = await EpubReader.readBook(
        file.readAsBytes(),
      );
      epubBooks.add(epubBook);
    },
  );

  return epubBooks;
}

List<BookModel> getBooks(List<EpubBook> epubBooks) {
  const uuid = Uuid();

  final bookModels = epubBooks.map(
    (epubBook) {
      return BookModel(
        title: epubBook.Title ?? 'Title',
        authors: epubBook.Author ?? 'Author',
        id: uuid.v4(),
        progress: '',
      );
    },
  ).toList();
  return bookModels;
}

Future<List<File>> pickBooks() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: [
      'epub',
    ],
  );

  if (result != null) {
    List<File> files = result.paths.map((path) => File(path!)).toList();
    return files;
  } else {
    return []; // User canceled the picker
  }
}

class AllBooksList extends ConsumerWidget {
  const AllBooksList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    return books.when(
      data: (data) => Center(
        child: Text(
          '${data.length} items',
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          '$error',
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
