import 'dart:io';
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
              pickBooks().then(
                (books) async {
                  if (books != []) {
                    getBooks(books).then(
                      (bookModels) {
                        final savedBooks = ref.watch(booksProvider).value;
                        if (savedBooks != null) {
                          savedBooks.map(
                            (savedBook) {
                              bookModels.map(
                                (bookModel) {
                                  if (savedBook.title == bookModel.title &&
                                      const ListEquality().equals(
                                        savedBook.authors,
                                        bookModel.authors,
                                      )) {
                                    bookModels.remove(bookModel);
                                    debugPrint('${savedBook.title} removed');
                                  }
                                },
                              );
                            },
                          );
                        }
                        ref.read(bookRepositoryProvider).addBooks(
                              books: bookModels,
                              userId: ref.read(authProvider).currentUser!.uid,
                            );
                      },
                    ).onError(
                      (error, stackTrace) {
                        Utils.showMessage(
                          context: context,
                          message: error.toString(),
                        );
                      },
                    );
                  }
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
}

Future<List<BookModel>> getBooks(List<File> books) async {
  final List<EpubBook> epubBooks = [];
  for (var book in books) {
    epubBooks.add(
      await EpubReader.readBook(
        await book.readAsBytes(),
      ),
    );
  }
  const uuid = Uuid();

  final bookModels = epubBooks.map(
    (epubBook) {
      List<String> authors = [];
      epubBook.AuthorList?.map((author) => authors.add(author ?? 'Author'));
      return BookModel(
        title: epubBook.Title ?? 'Title',
        authors: authors,
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
