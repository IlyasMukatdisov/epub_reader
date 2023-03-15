import 'package:flutter/material.dart';

class AllBooksScreen extends StatelessWidget {
  const AllBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('All Books'),
      ),
      body: const Center(
        child: Text('All Books'),
      )
    );
  }
}