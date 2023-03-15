// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class BookModel {
  final String title;
  final List<String> authors;
  final String id;
  final String? progress;
  BookModel({
    required this.title,
    required this.authors,
    required this.id,
    required this.progress,
  });

  BookModel copyWith({
    String? title,
    List<String>? authors,
    String? id,
    String? progress,
  }) {
    return BookModel(
      title: title ?? this.title,
      authors: authors ?? this.authors,
      id: id ?? this.id,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'authors': authors,
      'id': id,
      'progress': progress,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      title: map['title'] as String,
      authors: List<String>.from(
        (map['authors']),
      ),
      id: map['id'] as String,
      progress: map['progress'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookModel(title: $title, authors: $authors, id: $id, progress: $progress)';
  }

  @override
  bool operator ==(covariant BookModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        listEquals(other.authors, authors) &&
        other.id == id &&
        other.progress == progress;
  }

  @override
  int get hashCode {
    return title.hashCode ^ authors.hashCode ^ id.hashCode ^ progress.hashCode;
  }
}
