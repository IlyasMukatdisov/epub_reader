// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookModel {
  final String title;
  final String authors;
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
    String? authors,
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
      authors: map['authors'] as String,
      id: map['id'] as String,
      progress: map['progress'] != null ? map['progress'] as String : null,
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

    return other.title == title && other.authors == authors;
  }

  @override
  int get hashCode {
    return title.hashCode ^ authors.hashCode;
  }
}
