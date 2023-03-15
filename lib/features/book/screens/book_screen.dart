import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({
    super.key,
  });

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> with WidgetsBindingObserver {
  late EpubController _epubController;

  @override
  void initState() {
    super.initState();
    _epubController = EpubController(
      // Load document
      document: EpubDocument.openAsset('assets/book.epub'),
      // Set start point
      epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );
  }

  @override
  void dispose() async {
    _epubController.generateEpubCfi();
    _epubController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        _epubController.generateEpubCfi();
        debugPrint('AppLifecycleState.detached');
        break;
      default: return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show actual chapter name
        title: EpubViewActualChapter(
          controller: _epubController,
          builder: (chapterValue) => Text(
            'Chapter: ${chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? ''}',
            textAlign: TextAlign.start,
          ),
        ),
      ),
      // Show table of contents
      drawer: Drawer(
        child: EpubViewTableOfContents(
          controller: _epubController,
        ),
      ),
      // Show epub document
      body: EpubView(
        controller: _epubController,
      ),
    );
  }
}
